(function() {
    let currentCart = [];
    let vehicleMods = { performance: [], cosmetic: [] };
    let dynoChart = null;
    let isDynoRunning = false;

    // Chart.js Setup
    function initDynoChart() {
        const ctx = document.getElementById('dynoChart').getContext('2d');
        dynoChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Horsepower',
                    borderColor: '#007AFF',
                    backgroundColor: 'rgba(0, 122, 255, 0.1)',
                    data: [],
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true
                }, {
                    label: 'Torque',
                    borderColor: '#FF9500',
                    backgroundColor: 'rgba(255, 149, 0, 0.1)',
                    data: [],
                    borderWidth: 3,
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.05)' } },
                    x: { grid: { display: false } }
                },
                plugins: { legend: { display: false } },
                animation: false
            }
        });
    }

    window.addEventListener("message", function(event) {
        const data = event.data;
        if (data.action === "setVehicleMods") {
            vehicleMods = data.mods;
            renderAllMods();
        }

        if (data.action === "updateDyno") {
            updateDynoUI(data.data);
        }

        if (data.action === "setShopStock") {
            renderStock(data.stock);
        }
    });

    function updateDynoUI(data) {
        document.getElementById("dyno-hp").innerText = data.hp;
        document.getElementById("dyno-torque").innerText = data.torque;
        document.getElementById("dyno-speed").innerText = data.speed;
        document.getElementById("dyno-rpm").innerText = Math.floor(data.rpm * 8000);

        if (dynoChart) {
            const time = new Date().toLocaleTimeString([], { hour12: false, minute: '2-digit', second: '2-digit' });
            dynoChart.data.labels.push(time);
            dynoChart.data.datasets[0].data.push(data.hp);
            dynoChart.data.datasets[1].data.push(data.torque);

            if (dynoChart.data.labels.length > 20) {
                dynoChart.data.labels.shift();
                dynoChart.data.datasets[0].data.shift();
                dynoChart.data.datasets[1].data.shift();
            }
            dynoChart.update();
        }
    }

    window.toggleDyno = function() {
        isDynoRunning = !isDynoRunning;
        const btn = document.getElementById("dyno-toggle-btn");
        
        if (isDynoRunning) {
            btn.innerText = "Stop Test";
            btn.classList.replace("ios-btn-primary", "ios-btn-ghost");
            if (!dynoChart) initDynoChart();
        } else {
            btn.innerText = "Start Test";
            btn.classList.replace("ios-btn-ghost", "ios-btn-primary");
        }

        fetch(`https://${GetParentResourceName()}/toggleDyno`, {
            method: "POST",
            body: JSON.stringify({ state: isDynoRunning })
        });
    }

    window.switchMechTab = function(tab) {
        // Handle UI Layer switching
        document.querySelectorAll(".view-layer").forEach(v => v.classList.remove("active"));
        document.getElementById(`${tab}-view`).classList.add("active");
        
        document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");

        if (tab === 'inventory') {
            fetch(`https://${GetParentResourceName()}/requestPartsData`, { method: "POST" });
        } else if (tab === 'tuning') {
            fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
        } else if (tab === 'dyno') {
            setTimeout(initDynoChart, 100);
        }
    };

    // Existing Tuning Logic
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

    window.addToCart = function(modId, name, price) {
        currentCart = currentCart.filter(item => item.modId !== modId);
        currentCart.push({ modId, name, price });
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
        fetch(`https://${GetParentResourceName()}/confirmBuild`, {
            method: "POST",
            body: JSON.stringify({ cart: currentCart })
        });
        fetch(`https://${GetParentResourceName()}/sendInvoice`, {
            method: "POST",
            body: JSON.stringify({ amount: currentCart.reduce((a,b) => a+b.price,0), reason: "Tuning" })
        });
        currentCart = [];
        updateCartUI();
    };
})();