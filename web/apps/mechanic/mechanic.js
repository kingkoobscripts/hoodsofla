(function() {
    let currentCart = [];
    let vehicleMods = { performance: [], cosmetic: [] };
    let dynoChart = null;
    let isDynoRunning = false;

    function initDynoChart() {
        const ctx = document.getElementById("dynoChart");
        if (!ctx) return;
        
        dynoChart = new Chart(ctx.getContext("2d"), {
            type: "line",
            data: {
                labels: Array(20).fill(""),
                datasets: [
                    {
                        label: "Horsepower",
                        borderColor: "#FF9500",
                        backgroundColor: "rgba(255, 149, 0, 0.1)",
                        data: Array(20).fill(0),
                        tension: 0.4,
                        fill: true,
                        pointRadius: 0
                    },
                    {
                        label: "Torque",
                        borderColor: "#007AFF",
                        backgroundColor: "rgba(0, 122, 255, 0.1)",
                        data: Array(20).fill(0),
                        tension: 0.4,
                        fill: true,
                        pointRadius: 0
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, grid: { color: "rgba(255,255,255,0.05)" }, ticks: { color: "#8E8E93" } },
                    x: { display: false }
                },
                plugins: { legend: { display: false } },
                animation: false
            }
        });
    }

    const messageHandler = function(event) {
        const data = event.data;
        if (data.action === "setVehicleMods") {
            vehicleMods = data.mods;
            renderAllMods();
            if (data.engineData) {
                const badge = document.getElementById("active-engine-badge");
                if (badge) badge.innerText = (data.engineData.engine_type || "STOCK").replace("_", " ").toUpperCase();
            }
        }
        if (data.action === "updateDyno" && isDynoRunning) {
            updateDynoUI(data.data);
        }
        if (data.action === "setShopStock") {
            renderOrderCatalog(data.stock);
        }
    };

    window.addEventListener("message", messageHandler);

    function updateDynoUI(data) {
        if (!document.getElementById("dyno-hp")) return;
        document.getElementById("dyno-hp").innerText = data.hp;
        document.getElementById("dyno-torque").innerText = data.torque;
        document.getElementById("dyno-speed").innerText = data.speed;
        document.getElementById("dyno-rpm").innerText = Math.floor(data.rpm * 8000);

        if (dynoChart) {
            dynoChart.data.datasets[0].data.shift();
            dynoChart.data.datasets[0].data.push(data.hp);
            dynoChart.data.datasets[1].data.shift();
            dynoChart.data.datasets[1].data.push(data.torque);
            dynoChart.update();
        }
    }

    window.toggleDyno = function() {
        isDynoRunning = !isDynoRunning;
        const btn = document.getElementById("dyno-toggle-btn");
        btn.innerText = isDynoRunning ? "Stop Test" : "Start Test";
        btn.className = isDynoRunning ? "ios-btn ios-btn-red" : "ios-btn ios-btn-primary";

        if (isDynoRunning && !dynoChart) initDynoChart();

        fetch(`https://${GetParentResourceName()}/toggleDyno`, {
            method: "POST",
            body: JSON.stringify({ state: isDynoRunning })
        });
    }

    window.switchMechTab = function(tab) {
        document.querySelectorAll(".view-layer").forEach(v => v.classList.remove("active"));
        document.getElementById(`${tab}-view`).classList.add("active");
        
        document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");

        if (tab === "tuning" || tab === "engine") {
            fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST", body: JSON.stringify({}) });
        } else if (tab === "inventory") {
            fetch(`https://${GetParentResourceName()}/requestPartsData`, { method: "POST", body: JSON.stringify({}) });
        } else if (tab === "dyno") {
            setTimeout(initDynoChart, 50);
        }
    };

    function renderAllMods() {
        const perfList = document.getElementById("perf-list");
        const cosmList = document.getElementById("cosmetic-list");
        if (!perfList) return;
        
        perfList.innerHTML = vehicleMods.performance.map(mod => `
            <div class="mod-row">
                <div class="mod-info">
                    <span>${mod.name}</span>
                    <small>Stage ${mod.current + 1}/${mod.count}</small>
                </div>
                <button class="ios-btn ios-btn-ghost" onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})">Add</button>
            </div>
        `).join("");

        cosmList.innerHTML = vehicleMods.cosmetic.map(mod => `
            <div class="mod-row">
                <div class="mod-info">
                    <span>${mod.name}</span>
                </div>
                <button class="ios-btn ios-btn-ghost" onclick="addToCart(${mod.modId}, '${mod.name}', ${mod.price})">Add</button>
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
        if (!list) return;

        if (currentCart.length === 0) {
            list.innerHTML = `<div class="empty-cart"><p>No parts selected</p></div>`;
            totalEl.innerText = "$0";
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

    window.purchasePart = function(partItem) {
        fetch(`https://${GetParentResourceName()}/orderPart`, {
            method: "POST",
            body: JSON.stringify({ part: partItem })
        });
    };

    window.swapEngine = function(type) {
        fetch(`https://${GetParentResourceName()}/swapEngine`, {
            method: "POST",
            body: JSON.stringify({ engineType: type })
        });
    };
})();