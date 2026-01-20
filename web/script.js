function loadApp(appName) {
    document.getElementById("home-screen").classList.remove("active");
    document.getElementById("app-layer").classList.add("active");
    
    fetch(`apps/${appName}/${appName}.html`)
        .then(response => response.text())
        .then(html => {
            document.getElementById("app-content").innerHTML = html;
            
            // Load app-specific script
            const script = document.createElement("script");
            script.src = `apps/${appName}/${appName}.js`;
            document.body.appendChild(script);

            // Notify Lua we opened an app
            if (appName === "mechanic") {
                fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
            }
        });
}

function goHome() {
    document.getElementById("app-layer").classList.remove("active");
    document.getElementById("home-screen").classList.add("active");
    document.getElementById("app-content").innerHTML = "";
}

window.addEventListener("message", function(event) {
    const data = event.data;
    if (data.action === "openMechanicMenu") {
        document.body.classList.add("visible");
    }
    if (data.action === "closeUI") {
        document.body.classList.remove("visible");
    }
});

document.onkeydown = function(data) {
    if (data.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
    }
};