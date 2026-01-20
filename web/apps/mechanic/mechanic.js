(function() {
    let currentCart = [];
    let vehicleMods = { performance: [], cosmetic: [] };
    let dynoChart = null;
    let isDynoRunning = false;

    window.addEventListener("message", function(event) {
        const data = event.data;
        if (data.action === "setVehicleMods") {
            vehicleMods = data.mods;
            renderAllMods();
            
            if (data.engineData) {
                document.getElementById("active-engine-badge").innerText = data.engineData.engine_type.replace("_", " ").toUpperCase();
            }
        }
        if (data.action === "updateDyno") { updateDynoUI(data.data); }
        if (data.action === "setShopStock") { renderOrderCatalog(data.stock); }
    });

    window.swapEngine = function(type) {
        fetch(`https://${GetParentResourceName()}/swapEngine`, {
            method: "POST",
            body: JSON.stringify({ engineType: type })
        });
    };

    window.switchMechTab = function(tab) {
        document.querySelectorAll(".view-layer").forEach(v => v.classList.remove("active"));
        const target = document.getElementById(`${tab}-view`);
        if (target) target.classList.add("active");
        
        document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");

        if (tab === 'tuning' || tab === 'engine') {
            fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
        } else if (tab === 'inventory') {
            fetch(`https://${GetParentResourceName()}/requestPartsData`, { method: "POST" });
        }
    };

    function renderAllMods() {
        const perfList = document.getElementById("perf-list");
        const cosmList = document.getElementById("cosmetic-list");
        
        perfList.innerHTML = vehicleMods.performance.map(mod => `
            <div class="mod-row">
                <div class="mod-info">
                    <span>${mod.name}</span>
                    <small>Stage ${mod.current + 1}/${mod.count}</small>
                </div>
                <button class="ios-btn ios-btn-ghost" onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})">Add to Build</button>
            </div>
        `).join("");

        cosmList.innerHTML = vehicleMods.cosmetic.map(mod => `
            <div class="mod-row">
                <div class="mod-info">
                    <span>${mod.name}</span>
                </div>
                <button class="ios-btn ios-btn-ghost" onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})">Add to Build</button>
            </div>
        `).join("");
    }

    window.addToCart = function(id, name, price) {
        currentCart.push({ modId: id, name: name, price: price });
        updateCart();
    };

    function updateCart() {
        const list = document.getElementById("cart-items-list");
        const totalEl = document.getElementById("cart-total-val");
        const countEl = document.getElementById("item-count");

        if (currentCart.length === 0) {
            list.innerHTML = `<div class="empty-cart"><i class="fas fa-shopping-basket"></i><p>No parts selected</p></div>`;
            totalEl.innerText = "$0";
            countEl.innerText = "0 Items";
            return;
        }

        list.innerHTML = currentCart.map((item, idx) => `
            <div class="cart-item">
                <span>${item.name}</span>
                <div style="display:flex; align-items:center; gap:10px;">
                    <span style="color:var(--accent-green)">$${item.price}</span>
                    <i class="fas fa-trash" onclick="removeFromCart(${idx})" style="color:var(--accent-red); cursor:pointer;"></i>
                </div>
            </div>
        `).join("");

        const total = currentCart.reduce((sum, item) => sum + item.price, 0);
        totalEl.innerText = `$${total.toLocaleString()}`;
        countEl.innerText = `${currentCart.length} Items`;
    }

    window.removeFromCart = function(idx) {
        currentCart.splice(idx, 1);
        updateCart();
    };

    window.confirmBuild = function() {
        if (currentCart.length === 0) return;
        fetch(`https://${GetParentResourceName()}/confirmBuild`, {
            method: "POST",
            body: JSON.stringify({ cart: currentCart })
        });
        currentCart = [];
        updateCart();
    };

    function renderOrderCatalog(stock) {
        const grid = document.getElementById("order-list");
        grid.innerHTML = stock.map(item => `
            <div class="glass-card order-item">
                <div class="order-icon"><i class="fas fa-box"></i></div>
                <div class="order-details">
                    <h4>${item.name}</h4>
                    <p>Current Stock: <span style="color:white">${item.amount}</span></p>
                </div>
                <div class="order-action">
                    <span class="order-price">$${item.price}</span>
                    <button class="ios-btn ios-btn-primary" onclick="purchasePart('${item.item}')">Order</button>
                </div>
            </div>
        `).join("");
    }

    window.purchasePart = function(partItem) {
        fetch(`https://${GetParentResourceName()}/orderPart`, {
            method: "POST",
            body: JSON.stringify({ part: partItem })
        });
    };
})();