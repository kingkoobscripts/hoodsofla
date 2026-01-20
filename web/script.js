let currentUserData = {};

window.addEventListener("message", function(event) {
    const data = event.data;

    if (data.action === "openSpecificApp") {
        document.body.classList.add("visible");
        currentUserData = data.userData;
        loadApp(data.app);
    }

    if (data.action === "closeUI") {
        document.body.classList.remove("visible");
        goHome();
    }
});

function loadApp(appName) {
    const appContent = document.getElementById("app-content");
    const homeScreen = document.getElementById("home-screen");
    const appLayer = document.getElementById("app-layer");

    homeScreen.classList.remove("active");
    appLayer.classList.add("active");

    fetch(`apps/${appName}/${appName}.html`)
        .then(response => response.text())
        .then(html => {
            appContent.innerHTML = html;
            
            // Load app-specific CSS dynamically
            const link = document.createElement("link");
            link.rel = "stylesheet";
            link.href = `apps/${appName}/${appName}.css`;
            link.id = "app-style";
            document.head.appendChild(link);

            // Load app-specific JS dynamically
            const script = document.createElement("script");
            script.src = `apps/${appName}/${appName}.js`;
            script.id = "app-script";
            document.body.appendChild(script);

            // Initialize app data
            if (appName === "mechanic") {
                fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST" });
            } else if (appName === "admin") {
                fetch(`https://${GetParentResourceName()}/requestBusinessData`, { method: "POST" });
            }
        });
}

function goHome() {
    document.getElementById("app-layer").classList.remove("active");
    document.getElementById("home-screen").classList.add("active");
    document.getElementById("app-content").innerHTML = "";
    
    const oldScript = document.getElementById("app-script");
    const oldStyle = document.getElementById("app-style");
    if (oldScript) oldScript.remove();
    if (oldStyle) oldStyle.remove();
}

document.onkeydown = function(data) {
    if (data.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/close`, { method: "POST" });
    }
};