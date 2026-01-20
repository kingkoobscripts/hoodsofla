let currentUserData = {};
let currentActiveApp = null;

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

function updateClock() {
    const now = new Date();
    const timeStr = now.getHours().toString().padStart(2, '0') + ":" + now.getMinutes().toString().padStart(2, '0');
    document.getElementById("current-time").innerText = timeStr;
}
setInterval(updateClock, 1000);
updateClock();

function loadApp(appName) {
    if (currentActiveApp === appName) return;
    
    const appContent = document.getElementById("app-content");
    const homeScreen = document.getElementById("home-screen");
    const appLayer = document.getElementById("app-layer");

    // Reset previous app assets
    const oldScript = document.getElementById("app-script");
    const oldStyle = document.getElementById("app-style");
    if (oldScript) oldScript.remove();
    if (oldStyle) oldStyle.remove();

    homeScreen.classList.remove("active");
    appLayer.classList.add("active");
    currentActiveApp = appName;

    fetch(`apps/${appName}/${appName}.html`)
        .then(response => response.text())
        .then(html => {
            appContent.innerHTML = html;
            
            // Inject App CSS
            const link = document.createElement("link");
            link.rel = "stylesheet";
            link.href = `apps/${appName}/${appName}.css`;
            link.id = "app-style";
            document.head.appendChild(link);

            // Inject App JS
            const script = document.createElement("script");
            script.src = `apps/${appName}/${appName}.js`;
            script.id = "app-script";
            document.body.appendChild(script);

            // Initial Data Requests
            setTimeout(() => {
                if (appName === "mechanic") {
                    fetch(`https://${GetParentResourceName()}/requestVehicleData`, { method: "POST", body: JSON.stringify({}) });
                } else if (appName === "admin") {
                    fetch(`https://${GetParentResourceName()}/requestBusinessData`, { method: "POST", body: JSON.stringify({}) });
                } else if (appName === "dealership") {
                    // Logic handled in client/dealership.lua OpenShowroom
                }
            }, 100);
        });
}

function goHome() {
    document.getElementById("app-layer").classList.remove("active");
    document.getElementById("home-screen").classList.add("active");
    document.getElementById("app-content").innerHTML = "";
    currentActiveApp = null;
    
    fetch(`https://${GetParentResourceName()}/close`, { method: "POST", body: JSON.stringify({}) });
}

document.onkeydown = function(data) {
    if (data.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/close`, { method: "POST", body: JSON.stringify({}) });
    }
};