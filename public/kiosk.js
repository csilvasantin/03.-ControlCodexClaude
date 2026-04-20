const params = new URLSearchParams(window.location.search);
const requestedMachineId = params.get("machineId");
let isStaticMode = false;

const nodes = {
  title: document.querySelector("#kiosk-title"),
  subtitle: document.querySelector("#kiosk-subtitle"),
  status: document.querySelector("#machine-status"),
  lastSeen: document.querySelector("#machine-last-seen"),
  fleetOnline: document.querySelector("#fleet-online"),
  clock: document.querySelector("#clock"),
  focus: document.querySelector("#machine-focus"),
  note: document.querySelector("#machine-note"),
  name: document.querySelector("#machine-name"),
  id: document.querySelector("#machine-id"),
  member: document.querySelector("#machine-member"),
  role: document.querySelector("#machine-role"),
  location: document.querySelector("#machine-location"),
  platform: document.querySelector("#machine-platform")
};

function formatDate(value) {
  try {
    return new Date(value).toLocaleString("es-ES");
  } catch {
    return value;
  }
}

function updateClock() {
  nodes.clock.textContent = new Date().toLocaleTimeString("es-ES", {
    hour: "2-digit",
    minute: "2-digit"
  });
}

function pickMachine(data) {
  if (requestedMachineId) {
    return data.machines.find((machine) => machine.id === requestedMachineId) ?? data.machines[0];
  }

  return data.machines[0];
}

function render(data) {
  const machine = pickMachine(data);
  const onlineCount = data.machines.filter((item) => item.status === "online").length;

  nodes.title.textContent = "Modo AdmiraNext";
  nodes.subtitle.textContent = isStaticMode
    ? "Vista kiosko en modo solo lectura"
    : "Vista kiosko conectada al panel operativo";

  nodes.status.textContent = machine.status;
  nodes.lastSeen.textContent = formatDate(machine.lastSeen);
  nodes.fleetOnline.textContent = `${onlineCount}/${data.machines.length}`;
  nodes.focus.textContent = machine.currentFocus ?? "Sin foco operativo";
  nodes.note.textContent = machine.note ?? "";
  nodes.name.textContent = machine.name;
  nodes.id.textContent = machine.id;
  nodes.member.textContent = machine.member ?? "Sin asignar";
  nodes.role.textContent = machine.machineRole ?? machine.role ?? "Sin rol";
  nodes.location.textContent = machine.location ?? "Sin ubicación";
  nodes.platform.textContent = machine.platform ?? "Sin plataforma";
}

async function fetchData() {
  try {
    const response = await fetch("/api/machines", { cache: "no-store" });
    if (!response.ok) {
      throw new Error("api unavailable");
    }

    isStaticMode = false;
    return await response.json();
  } catch {
    const response = await fetch("./machines.json?v=20260420-1", { cache: "no-store" });
    isStaticMode = true;
    return await response.json();
  }
}

async function load() {
  const data = await fetchData();
  render(data);
}

updateClock();
setInterval(updateClock, 1000);
load();
setInterval(load, 30000);
