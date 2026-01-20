let currentApp = null;
let currentData = {};
let activeTab = "overview";
let shoppingCart = [];

window.addEventListener("message", function(event) {
    const data = event.data;
    if (data.action === "openMechanicMenu") {
        document.body.classList.add("visible");
        currentData = data.data;
        goHome();
    }
    if (data.action === "setVehicleMods") {
        renderTuning(data.mods);
    }
});

function renderTuning(mods) {
    document.getElementById("page-title").innerText = "Custom Build";
    const render = document.getElementById("app-content-render");
    
    let html = `
        <div style="display:grid; grid-template-columns: 1fr 350px; gap: 20px;">
            <div class="tuning-scroll-area" style="max-height: 550px; overflow-y: auto; padding-right: 10px;">
    `;
    
    // Performance Section
    html += `<h3 style="margin-bottom: 15px; color: var(--accent-orange)">Performance</h3>`;
    mods.performance.forEach(mod => {
        html += `
            <div class="tuning-item">
                <div class="mod-info">
                    <h4>${mod.name}</h4>
                    <p>Level ${mod.current + 1} / ${mod.count}</p>
                </div>
                <div style="display:flex; align-items:center; gap: 10px;">
                    <select onchange="previewPart(${mod.modId}, this.value)" class="ios-input">
                        ${generateOptions(mod.count, mod.current)}
                    </select>
                    <button class="ios-btn ios-btn-ghost" onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})">Add</button>
                </div>
            </div>
        `;
    });

    html += `</div>
        <div class="glass-card cart-sidebar">
            <h3>Build List</h3>
            <div id="cart-items" style="margin: 20px 0; min-height: 200px;">
                ${renderCart()}
            </div>
            <div class="cart-total" style="border-top: 1px solid rgba(255,255,255,0.1); padding-top: 15px;">
                <div style="display:flex; justify-content:space-between; margin-bottom: 10px;">
                    <span>Subtotal</span>
                    <span id="cart-subtotal">$0</span>
                </div>
                <button class="ios-btn ios-btn-primary" style="width:100%" onclick="finalizeBuild()">Install & Invoice</button>
            </div>
        </div>
    </div>`;

    render.innerHTML = html;
    updateCartDisplay();
}

function generateOptions(count, current) {
    let options = "";
    for(let i = -1; i < count; i++) {
        options += `<option value="${i}" ${i == current ? 'selected' : ''}>${i == -1 ? 'Stock' : 'Stage ' + (i+1)}</option>`;
    }
    return options;
}

function previewPart(modId, level) {
    fetch(`https://${GetParentResourceName()}/previewMod`, {
        method: "POST",
        body: JSON.stringify({ modId: modId, level: parseInt(level) })
    });
}

function addToCart(modId, name, price) {
    const level = 1; // Simplified for example
    shoppingCart.push({ modId, name, price, level });
    updateCartDisplay();
}

function renderCart() {
    if (shoppingCart.length === 0) return `<p style="color:var(--text-dim); text-align:center;">No parts selected</p>`;
    return shoppingCart.map((item, index) => `
        <div class="cart-item" style="display:flex; justify-content:space-between; margin-bottom: 8px; font-size: 13px;">
            <span>${item.name}</span>
            <span style="color:var(--accent-green)">$${item.price} <i class="fas fa-times" onclick="removeFromCart(${index})" style="margin-left:8px; cursor:pointer; color:var(--accent-red)"></i></span>
        </div>
    `).join('');
}

function updateCartDisplay() {
    const container = document.getElementById("cart-items");
    if (container) container.innerHTML = renderCart();
    
    const subtotal = shoppingCart.reduce((sum, item) => sum + item.price, 0);
    const subtotalEl = document.getElementById("cart-subtotal");
    if (subtotalEl) subtotalEl.innerText = `$${subtotal.toLocaleString()}`;
}

function removeFromCart(index) {
    shoppingCart.splice(index, 1);
    updateCartDisplay();
}

function finalizeBuild() {
    if (shoppingCart.length === 0) return;
    fetch(`https://${GetParentResourceName()}/confirmBuild`, {
        method: "POST",
        body: JSON.stringify({ cart: shoppingCart })
    });
    shoppingCart = [];
}