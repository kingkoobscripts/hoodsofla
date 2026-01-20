(function() {
    let currentCart = [];
    let vehicleMods = { performance: [], cosmetic: [] };

    // Listen for data from Lua
    window.addEventListener("message", function(event) {
        if (event.data.action === "setVehicleMods") {
            vehicleMods = event.data.mods;
            renderAllMods();
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
        // Prevent duplicate parts of the same category in cart
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
        
        fetch(`https://${GetParentResourceName()}/confirmBuild`, {
            method: "POST",
            body: JSON.stringify({ cart: currentCart })
        });
        
        currentCart = [];
        updateCartUI();
    };

    window.switchMechTab = function(tab) {
        // Logic for switching sub-views in the mechanic app
        console.log("Switching to tab:", tab);
        const items = document.querySelectorAll(".nav-item");
        items.forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");
    };
})();