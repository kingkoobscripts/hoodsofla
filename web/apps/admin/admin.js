(function() {
    let currentBusinessData = null;

    window.addEventListener("message", function(event) {
        if (event.data.action === "setBusinessData") {
            currentBusinessData = event.data.business;
            updateDashboard();
        }
    });

    function updateDashboard() {
        if (!currentBusinessData) return;
        
        document.getElementById("shop-subtext").innerText = currentBusinessData.name;
        document.getElementById("shop-balance").innerText = `$${currentBusinessData.balance.toLocaleString()}`;
        document.getElementById("stat-staff").innerText = currentBusinessData.employees.length;
        document.getElementById("stat-services").innerText = currentBusinessData.logs.length;
        
        renderLogs(currentBusinessData.logs || []);
    }

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
        const content = document.getElementById("admin-view-content");
        const items = document.querySelectorAll(".nav-item");
        items.forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");

        if (tab === 'employees') {
            renderEmployeeManagement();
        } else if (tab === 'overview') {
            location.reload(); // Simple refresh to home
        }
    };

    function renderEmployeeManagement() {
        const container = document.getElementById("admin-view-content");
        container.innerHTML = `
            <div class="glass-card">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                    <h3>Staff Roster</h3>
                    <button class="ios-btn ios-btn-primary" onclick="hirePrompt()">+ Hire Near</button>
                </div>
                <div class="employee-list">
                    ${currentBusinessData.employees.map(emp => `
                        <div class="log-row">
                            <span>${emp.name}</span>
                            <button class="ios-btn ios-btn-ghost" style="color:var(--accent-red)" onclick="fireEmployee('${emp.citizenid}')">Terminate</button>
                        </div>
                    `).join("")}
                </div>
            </div>
        `;
    }

    window.hirePrompt = function() {
        // In a real scenario, we'd trigger a client-side search for nearest player
        const id = prompt("Enter Server ID of the player to hire:");
        if (id) {
            fetch(`https://${GetParentResourceName()}/hireEmployee`, {
                method: "POST",
                body: JSON.stringify({ targetId: parseInt(id) })
            });
        }
    };

    window.fireEmployee = function(cid) {
        if (confirm("Are you sure you want to fire this employee?")) {
            fetch(`https://${GetParentResourceName()}/fireEmployee`, {
                method: "POST",
                body: JSON.stringify({ citizenid: cid })
            });
        }
    };
})();