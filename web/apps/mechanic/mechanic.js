(function() {
    let currentCart = [];
    let vehicleMods = { performance: [], cosmetic: [] };

    window.addEventListener("message", function(event) {
        if (event.data.action === "setVehicleMods") {
            vehicleMods = event.data.mods;
            renderAllMods();
        }

        if (event.data.action === "setShopStock") {
            renderStock(event.data.stock);
        }

        if (event.data.action === "setDiagnosticResult") {
            renderDiagnostics(event.data);
        }
    });

    function renderAllMods() {
        const perfContainer = document.getElementById("perf-list");
        const cosmContainer = document.getElementById("cosmetic-list");
        
        if (!perfContainer || !cosmContainer) return;

        perfContainer.innerHTML = vehicleMods.performance.map(mod => createModRow(mod, "performance")).join("");
        cosmContainer.innerHTML = vehicleMods.cosmetic.map(mod => createModRow(mod, "cosmetic")).join("");
    }

    function createModRow(mod, type) {
        return `
            <div class="mod-row">
                <div class="mod-info">
                    <h4>${mod.name}</h4>
                    <p>Current: ${mod.current === -1 ? 'Stock' : 'Stage ' + (mod.current + 1)}</p>
                </div>
                <div class="mod-actions">
                    <select class="mod-select" onchange="previewPart(${mod.modId}, this.value, '${type}')">
                        <option value="-1">Stock</option>
                        ${generateOptions(mod.count, mod.current)}
                    </select>
                    <button class="add-btn" onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            </div>
        `;
    }

    function generateOptions(count, current) {
        let html = "";
        for(let i = 0; i < count; i++) {
            html += `<option value="${i}" ${i === current ? 'selected' : ''}>Stage ${i+1}</option>`;
        }
        return html;
    }

    function renderStock(stock) {
        const viewport = document.getElementById("tuning-view");
        viewport.innerHTML = `
            <div class="glass-card">
                <div class="card-header">
                    <h3>Inventory Management</h3>
                    <button class="ios-btn ios-btn-ghost" onclick="switchMechTab('tuning')">Back to Tuning</button>
                </div>
                <div class="stock-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
                    ${stock.map(item => `
                        <div class="glass-card" style="text-align: center;">
                            <h4 style="font-size: 14px; margin-bottom: 10px;">${item.name}</h4>
                            <div style="font-size: 24px; font-weight: 800; color: ${item.amount > 0 ? 'var(--accent-green)' : 'var(--accent-red)'}">${item.amount}</div>
                            <p style="font-size: 11px; color: var(--text-dim);">In Stock</p>
                        </div>
                    `).join("")}
                </div>
            </div>
        `;
    }

    window.previewPart = function(modId, level, type) {
        fetch(`https://${GetParentResourceName()}/previewMod`, {
            method: "POST",
            body: JSON.stringify({ 
                modId: parseInt(modId), 
                level: parseInt(level),
                type: type 
            })
        });
    };

    window.addToCart = function(modId, name, price) {
        currentCart = currentCart.filter(item => item.modId !== modId);
        currentCart.push({ modId, name, price });
        updateCartUI();
    };

    window.removeFromCart = function(index) {
        currentCart.splice(index, 1);
        updateCartUI();
    };

    function updateCartUI() {
        const list = document.getElementById("cart-items-list");
        const total = document.getElementById("cart-total-val");
        const count = document.getElementById("item-count");
        
        if (!list) return;

        if (currentCart.length === 0) {
            list.innerHTML = `<div class="empty-cart"><i class="fas fa-shopping-basket"></i><p>No parts selected</p></div>`;
            total.innerText = "$0";
            count.innerText = "0 Items";
            return;
        }

        let sum = 0;
        list.innerHTML = currentCart.map((item, index) => {
            sum += item.price;
            return `
                <div class="cart-item">
                    <div class="cart-item-info">
                        <span>${item.name}</span>
                        <small>$${item.price.toLocaleString()}</small>
                    </div>
                    <i class="fas fa-trash-alt remove-item" onclick="removeFromCart(${index})"></i>
                </div>
            `;
        }).join("");

        total.innerText = `$${sum.toLocaleString()}`;
        count.innerText = `${currentCart.length} Items`;
    }

    window.confirmBuild = function() {
        if (currentCart.length === 0) return;
        
        const amount = currentCart.reduce((a, b) => a + b.price, 0);
        const reason = "Vehicle Tuning & Performance Upgrades";
        
        // Finalize Build Logic
        fetch(`https://${GetParentResourceName()}/confirmBuild`, {
            method: "POST",
            body: JSON.stringify({ cart: currentCart })
        });

        // Trigger Invoice Prompt
        fetch(`https://${GetParentResourceName()}/sendInvoice`, {
            method: "POST",
            body: JSON.stringify({ amount: amount, reason: reason })
        });

        currentCart = [];
        updateCartUI();
    };

    window.switchMechTab = function(tab) {
        const items = document.querySelectorAll(".nav-item");
        items.forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");

        if (tab === 'inventory') {
            fetch(`https://${GetParentResourceName()}/requestPartsData`, { method: "POST" });
        } else if (tab === 'tuning') {
            fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
            // Logic to revert viewport to tuning grid
        }
    };
})();