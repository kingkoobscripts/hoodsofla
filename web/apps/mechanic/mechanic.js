(function() {
    let cart = [];
    
    window.addEventListener("message", function(event) {
        if (event.data.action === "setVehicleMods") {
            renderMods(event.data.mods);
        }
    });

    function renderMods(mods) {
        const perf = document.getElementById("perf-list");
        const cosm = document.getElementById("cosmetic-list");
        if (!perf) return;

        perf.innerHTML = mods.performance.map(mod => `
            <div class="mod-item">
                <div>
                    <div>${mod.name}</div>
                    <small style="color:var(--text-dim)">Current: ${mod.current == -1 ? 'Stock' : 'Stage ' + (mod.current + 1)}</small>
                </div>
                <select onchange="previewPart(${mod.modId}, this.value)" style="background:transparent; color:white; border:1px solid var(--glass-border); border-radius:5px;">
                    ${generateOptions(mod.count, mod.current)}
                </select>
                <button onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})" style="background:var(--accent-green); border:none; border-radius:5px; padding:5px 10px; color:white;">+</button>
            </div>
        `).join('');
    }

    function generateOptions(count, current) {
        let html = `<option value="-1">Stock</option>`;
        for(let i = 0; i < count; i++) {
            html += `<option value="${i}" ${i == current ? 'selected' : ''}>Stage ${i+1}</option>`;
        }
        return html;
    }

    window.previewPart = function(modId, level) {
        fetch(`https://${GetParentResourceName()}/previewMod`, {
            method: "POST",
            body: JSON.stringify({ modId, level: parseInt(level) })
        });
    };

    window.addToCart = function(modId, name, price) {
        cart.push({ modId, name, price });
        updateCart();
    };

    function updateCart() {
        const list = document.getElementById("cart-items-list");
        const total = document.getElementById("cart-total-val");
        let sum = 0;

        list.innerHTML = cart.map((item, index) => {
            sum += item.price;
            return `<div class="mod-item"><span>${item.name}</span><span>$${item.price}</span></div>`;
        }).join('');
        
        total.innerText = `$${sum.toLocaleString()}`;
    }

    window.confirmBuild = function() {
        fetch(`https://${GetParentResourceName()}/confirmBuild`, {
            method: "POST",
            body: JSON.stringify({ cart: cart })
        });
        cart = [];
        updateCart();
    };
})();