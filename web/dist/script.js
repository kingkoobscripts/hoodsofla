let shoppingCart = [];
let currentVehicleMods = {};

window.addEventListener("message", function(event) {
    const data = event.data;

    if (data.action === "openMechanicMenu") {
        document.body.classList.add("visible");
        updateUI(data.data);
        goHome();
        launchApp('mechanic');
    }

    if (data.action === "setVehicleMods") {
        currentVehicleMods = data.mods;
        renderTuningMenu();
    }
});

function updateUI(data) {
    document.getElementById("ui-shop-name").innerText = data.shopName;
    document.getElementById("ui-mechanic-name").innerText = data.mechanic;
    document.getElementById("ui-shop-balance").innerText = `$${data.balance.toLocaleString()}`;
    
    document.getElementById("engine-bar").style.width = `${data.health.engine}%`;
    document.getElementById("body-bar").style.width = `${data.health.body}%`;
}

function launchApp(appId) {
    document.querySelectorAll(".page").forEach(p => p.classList.remove("active"));
    document.getElementById(`app-${appId}`).classList.add("active");
    
    if (appId === 'mechanic') {
        fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
    }
}

function switchTab(tabId) {
    document.querySelectorAll(".tab-content").forEach(t => t.classList.remove("active"));
    document.querySelectorAll(".nav-btn").forEach(b => b.classList.remove("active"));
    
    document.getElementById(`tab-${tabId}`).classList.add("active");
    event.currentTarget.classList.add("active");
}

function renderTuningMenu() {
    const container = document.getElementById("mod-render-area");
    let html = `<h3>Performance Upgrades</h3>`;
    
    currentVehicleMods.performance.forEach(mod => {
        html += `
            <div class="mod-card">
                <div>
                    <h4 style="margin:0">${mod.name}</h4>
                    <p style="color:var(--text-dim); font-size:12px">Current: Level ${mod.current + 1}</p>
                </div>
                <div style="display:flex; gap:10px; align-items:center">
                    <select class="ios-select" onchange="previewMod(${mod.modId}, this.value)">
                        ${generateOptions(mod.count, mod.current)}
                    </select>
                    <button class="btn-add" onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})">+</button>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

function generateOptions(count, current) {
    let options = `<option value="-1">Stock</option>`;
    for (let i = 0; i < count; i++) {
        options += `<option value="${i}" ${i === current ? 'selected' : ''}>Stage ${i + 1}</option>`;
    }
    return options;
}

function previewMod(modId, level) {
    fetch(`https://${GetParentResourceName()}/previewMod`, {
        method: "POST",
        body: JSON.stringify({ modId, level: parseInt(level) })
    });
}

function addToCart(modId, name, price) {
    shoppingCart.push({ modId, name, price });
    updateCart();
}

function updateCart() {
    const container = document.getElementById("cart-items");
    const totalEl = document.getElementById("cart-total");
    
    container.innerHTML = shoppingCart.map((item, idx) => `
        <div class="cart-item" style="display:flex; justify-content:space-between; margin-bottom:10px">
            <span>${item.name}</span>
            <span style="color:var(--accent-green)">$${item.price} <i class="fas fa-trash" onclick="removeFromCart(${idx})" style="color:red; margin-left:10px"></i></span>
        </div>
    `).join('');
    
    const total = shoppingCart.reduce((sum, item) => sum + item.price, 0);
    totalEl.innerText = `$${total.toLocaleString()}`;
}

function confirmBuild() {
    if (shoppingCart.length === 0) return;
    fetch(`https://${GetParentResourceName()}/confirmBuild`, {
        method: "POST",
        body: JSON.stringify({ cart: shoppingCart })
    });
    shoppingCart = [];
    document.body.classList.remove("visible");
}

function goHome() {
    document.querySelectorAll(".page").forEach(p => p.classList.remove("active"));
    document.getElementById("home-screen").classList.add("active");
}

document.onkeydown = function(data) {
    if (data.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
        document.body.classList.remove("visible");
    }
};