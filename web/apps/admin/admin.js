(function() {
    window.addEventListener("message", function(event) {
        if (event.data.action === "setBusinessData") {
            const data = event.data.business;
            document.getElementById("shop-subtext").innerText = data.name;
            document.getElementById("shop-balance").innerText = `$${data.balance.toLocaleString()}`;
            document.getElementById("stat-staff").innerText = data.employees.length;
            
            renderLogs(data.logs || []);
        }
    });

    function renderLogs(logs) {
        const container = document.getElementById("recent-logs");
        if (logs.length === 0) {
            container.innerHTML = `<p class="empty-msg">No recent activity found.</p>`;
            return;
        }

        container.innerHTML = logs.map(log => `
            <div class="log-row">
                <div>
                    <span style="display:block; font-weight:600;">${log.mechanic_name}</span>
                    <small style="color:var(--text-dim)">Plate: ${log.plate}</small>
                </div>
                <div style="text-align:right">
                    <span style="display:block; color:var(--accent-green)">+$${log.cost}</span>
                    <small style="color:var(--text-dim)">${new Date(log.timestamp).toLocaleDateString()}</small>
                </div>
            </div>
        `).join("");
    }

    window.switchAdminTab = function(tab) {
        const items = document.querySelectorAll(".nav-item");
        items.forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");
        
        // Tab logic for staff hiring/firing would go here
    };
})();