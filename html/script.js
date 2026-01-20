let currentApp = null;
let currentData = {};
let activeTab = "overview";

function updateTime() {
    const now = new Date();
    document.getElementById("current-time").innerText = now.getHours() + ":" + String(now.getMinutes()).padStart(2, '0');
}
setInterval(updateTime, 1000);
updateTime();

window.addEventListener("message", function(event) {
    const data = event.data;

    if (data.action === "openMechanicMenu") {
        document.body.classList.add("visible");
        currentData = data.data;
        
        // Update Sidebar Profile
        document.getElementById("sidebar-user-name").innerText = data.data.mechanic;
        document.getElementById("sidebar-shop-name").innerText = data.data.shopName;
        document.getElementById("user-initials").innerText = data.data.mechanic.charAt(0);
        
        // Show/Hide Admin App based on perms
        document.getElementById("admin-app-icon").style.display = data.data.isOwner ? "flex" : "none";
        
        goHome();
    }

    if (data.action === "setVehicleMods") {
        renderTuning(data.mods);
    }

    if (data.action === "closeUI") {
        document.body.classList.remove("visible");
    }
});

function openApp(appName) {
    currentApp = appName;
    document.getElementById("home-screen").classList.remove("active");
    const appLayer = document.getElementById("app-layer");
    const container = document.getElementById("app-container-main");
    
    appLayer.classList.add("active");
    
    // Set App Theme
    container.className = `app-container app-${appName}`;
    
    const nav = document.getElementById("sidebar-nav");
    nav.innerHTML = "";

    if (appName === "mechanic") {
        document.getElementById("sidebar-app-name").innerText = "M-Tablet Pro";
        setupSidebar([
            { id: "overview", icon: "fa-house", label: "Overview" },
            { id: "tuning", icon: "fa-car-on", label: "Tuning" },
            { id: "diagnostics", icon: "fa-microchip", label: "Diagnostics" },
            { id: "billing", icon: "fa-file-invoice-dollar", label: "Invoicing" }
        ]);
        renderOverview();
    } else if (appName === "admin") {
        document.getElementById("sidebar-app-name").innerText = "Business Hub";
        setupSidebar([
            { id: "finance", icon: "fa-vault", label: "Finances" },
            { id: "staff", icon: "fa-users", label: "Employees" },
            { id: "logs", icon: "fa-list-ul", label: "Service Logs" }
        ]);
        renderFinance();
    } else if (appName === "dealership") {
        document.getElementById("sidebar-app-name").innerText = "D-Tablet";
        setupSidebar([
            { id: "showroom", icon: "fa-car", label: "Showroom" },
            { id: "catalog", icon: "fa-book", label: "Catalog" }
        ]);
        // Trigger server fetch
        fetch(`https://${GetParentResourceName()}/requestShowroom`, { method: "POST" });
    }
}

function setupSidebar(items) {
    const nav = document.getElementById("sidebar-nav");
    items.forEach(item => {
        const div = document.createElement("div");
        div.className = `nav-item ${activeTab === item.id ? "active" : ""}`;
        div.innerHTML = `<i class="fas ${item.icon}"></i> <span>${item.label}</span>`;
        div.onclick = () => {
            document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
            div.classList.add("active");
            activeTab = item.id;
            switchPage(item.id);
        };
        nav.appendChild(div);
    });
}

function switchPage(pageId) {
    const render = document.getElementById("app-content-render");
    render.innerHTML = `<div style="display:flex; justify-content:center; padding: 50px;"><i class="fas fa-circle-notch fa-spin fa-2xl"></i></div>`;
    
    if (pageId === "tuning") {
        fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
    } else if (pageId === "overview") {
        renderOverview();
    } else if (pageId === "finance") {
        renderFinance();
    }
}

function renderOverview() {
    document.getElementById("page-title").innerText = "Workshop Overview";
    const render = document.getElementById("app-content-render");
    
    render.innerHTML = `
        <div class="stat-grid">
            <div class="glass-card">
                <p style="color:var(--text-dim)">Shop Balance</p>
                <h2 style="color:var(--accent-green)">$${currentData.balance.toLocaleString()}</h2>
            </div>
            <div class="glass-card">
                <p style="color:var(--text-dim)">Engine Health</p>
                <h2 style="color:var(--accent-orange)">${currentData.health.engine}%</h2>
            </div>
            <div class="glass-card">
                <p style="color:var(--text-dim)">Body Condition</p>
                <h2 style="color:var(--accent-blue)">${currentData.health.body}%</h2>
            </div>
        </div>
        
        <div class="glass-card" style="margin-top:20px;">
            <h3>Active Vehicle Diagnostics</h3>
            <p style="color:var(--text-dim); margin-bottom: 20px;">System scan ready for current vehicle in bay.</p>
            <button class="ios-btn ios-btn-primary" onclick="switchPage('tuning')">Open Tuning Module</button>
        </div>
    `;
}

function renderTuning(mods) {
    document.getElementById("page-title").innerText = "Vehicle Tuning";
    const render = document.getElementById("app-content-render");
    
    let html = `<div class="tuning-list">`;
    
    // Performance Section
    html += `<h3 style="margin: 20px 0 15px 0; color: var(--accent-orange)">Performance Upgrades</h3>`;
    mods.performance.forEach(mod => {
        html += `
            <div class="tuning-item">
                <div class="mod-info">
                    <h4>${mod.name}</h4>
                    <p>Current: Level ${mod.current + 1} / ${mod.count}</p>
                </div>
                <div style="display:flex; align-items:center;">
                    <span class="price-tag">$${mod.price}</span>
                    <button class="ios-btn ios-btn-primary" onclick="purchaseMod(${mod.modId}, ${mod.current + 1})">Install</button>
                </div>
            </div>
        `;
    });

    html += `</div>`;
    render.innerHTML = html;
}

function renderFinance() {
    document.getElementById("page-title").innerText = "Financial Center";
    const render = document.getElementById("app-content-render");
    
    render.innerHTML = `
        <div class="glass-card">
            <h3>Withdraw Business Funds</h3>
            <div style="margin-top:20px; display:flex; gap:10px;">
                <input type="number" id="withdraw-amount" placeholder="Amount..." style="background:rgba(0,0,0,0.3); border:1px solid #444; color:white; padding:12px; border-radius:10px; flex:1;">
                <button class="ios-btn ios-btn-primary" onclick="withdrawFunds()">Withdraw</button>
            </div>
        </div>
    `;
}

function goHome() {
    document.getElementById("app-layer").classList.remove("active");
    document.getElementById("home-screen").classList.add("active");
    currentApp = null;
    activeTab = "overview";
}

function purchaseMod(id, level) {
    fetch(`https://${GetParentResourceName()}/purchaseMod`, {
        method: "POST",
        body: JSON.stringify({ modId: id, level: level })
    });
}

function withdrawFunds() {
    const amount = document.getElementById("withdraw-amount").value;
    if (amount > 0) {
        fetch(`https://${GetParentResourceName()}/withdrawFunds`, {
            method: "POST",
            body: JSON.stringify({ amount: parseInt(amount) })
        });
    }
}

function closeUI() {
    fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
}

document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") closeUI();
});