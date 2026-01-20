(function() {
    let allVehicles = [];
    let selectedVehicle = null;

    window.addEventListener("message", function(event) {
        if (event.data.action === "openShowroom") {
            allVehicles = event.data.vehicles;
            renderVehicles(allVehicles);
        }
    });

    function renderVehicles(vehicles) {
        const grid = document.getElementById("vehicle-grid");
        if (!grid) return;

        grid.innerHTML = vehicles.map(veh => `
            <div class="vehicle-card" onclick="selectVehicle('${veh.model}')">
                <img src="assets/${veh.model}.png" onerror="this.src='assets/default_car.png'">
                <h3>${veh.label}</h3>
                <div class="price">$${veh.price.toLocaleString()}</div>
            </div>
        `).join("");
    }

    window.filterCategory = function(cat) {
        const filtered = cat === 'all' ? allVehicles : allVehicles.filter(v => v.category === cat);
        renderVehicles(filtered);
        
        const items = document.querySelectorAll(".nav-item");
        items.forEach(i => i.classList.remove("active"));
        event.currentTarget.classList.add("active");
    };

    window.selectVehicle = function(model) {
        selectedVehicle = allVehicles.find(v => v.model === model);
        document.getElementById("modal-veh-name").innerText = selectedVehicle.label;
        document.getElementById("modal-veh-price").innerText = `$${selectedVehicle.price.toLocaleString()}`;
        document.getElementById("purchase-modal").style.display = "flex";
        
        fetch(`https://${GetParentResourceName()}/previewVehicle`, {
            method: "POST",
            body: JSON.stringify({ model: model })
        });
    };

    window.closeModal = function() {
        document.getElementById("purchase-modal").style.display = "none";
    };

    window.confirmPurchase = function() {
        if (!selectedVehicle) return;
        fetch(`https://${GetParentResourceName()}/buyVehicle`, {
            method: "POST",
            body: JSON.stringify({ model: selectedVehicle.model })
        });
        closeModal();
    };
})();