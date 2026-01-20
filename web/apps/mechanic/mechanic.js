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
    });

    window.swapEngine = function(type) {
        fetch(`https://${GetParentResourceName()}/swapEngine`, {
            method: "POST",
            body: JSON.stringify({ engineType: type })
        });
    };

    window.switchMechTab = function(tab) {
        document.querySelectorAll(".view-layer").forEach(v => v.classList.remove("active"));
        document.getElementById(`${tab}-view`).classList.add("active");
        document.querySelectorAll(".nav-item").forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");

        if (tab === 'tuning' || tab === 'engine') {
            fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
        }
    };

    // ... (rest of previous logic for cart and dyno) ...
})();