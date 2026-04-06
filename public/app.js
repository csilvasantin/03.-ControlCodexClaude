const summaryNode = document.querySelector("#summary");
const machinesNode = document.querySelector("#machines");
const template = document.querySelector("#machine-template");
let isStaticMode = false;
const API_OVERRIDE_PARAM = new URLSearchParams(location.search).get("api");
const API_OVERRIDE_STORAGE_KEY = "admiranextTeam.apiBase";
const DEFAULT_FUNNEL_URL = "https://macmini.tail48b61c.ts.net";
const FUNNEL_HOST = "macmini.tail48b61c.ts.net";
const isLocal = location.hostname === "localhost" || location.hostname === "127.0.0.1" || location.hostname === FUNNEL_HOST;
const LOCAL_API_CANDIDATES = ["http://127.0.0.1:4140", "http://localhost:4140", "http://127.0.0.1:3030", "http://localhost:3030"];
let apiBase = "";

function normalizeBase(base) {
  if (!base) return "";
  return String(base).trim().replace(/\/+$/, "");
}

function readConfiguredApiBase() {
  const override =
    API_OVERRIDE_PARAM ||
    localStorage.getItem(API_OVERRIDE_STORAGE_KEY) ||
    window.TEAMWORK_API_BASE ||
    "";
  const normalized = normalizeBase(override);
  if (API_OVERRIDE_PARAM && normalized) {
    localStorage.setItem(API_OVERRIDE_STORAGE_KEY, normalized);
  }
  return normalized;
}

function buildApiCandidates() {
  const configured = readConfiguredApiBase();
  const candidates = [];
  const seen = new Set();

  function push(base) {
    const normalized = normalizeBase(base);
    if (seen.has(normalized)) return;
    seen.add(normalized);
    candidates.push(normalized);
  }

  if (configured) push(configured);
  if (isLocal) push("");
  if (!isLocal) {
    for (const localBase of LOCAL_API_CANDIDATES) push(localBase);
  }
  if (location.origin && !location.origin.startsWith("file://")) push(location.origin);
  push(DEFAULT_FUNNEL_URL);
  if (!isLocal) push("");

  return candidates;
}

async function fetchWithTimeout(url, options = {}, timeoutMs = 3500) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  try {
    return await fetch(url, { ...options, signal: controller.signal });
  } finally {
    clearTimeout(timer);
  }
}

async function resolveApiBase() {
  const candidates = buildApiCandidates();
  for (const candidate of candidates) {
    const probeUrl = `${candidate || ""}/api/machines`;
    try {
      const response = await fetchWithTimeout(probeUrl, { cache: "no-store" });
      if (response.ok) {
        apiBase = candidate;
        isStaticMode = false;
        return candidate;
      }
    } catch {
      // try next candidate
    }
  }

  apiBase = "";
  return null;
}

function apiUrl(path) {
  return `${apiBase || ""}${path}`;
}

function formatDate(value) {
  try {
    return new Date(value).toLocaleString("es-ES");
  } catch {
    return value;
  }
}

function createSummary(data) {
  const machines = data.machines;
  const members = new Set(machines.map((item) => item.member));
  const counts = {
    maquinas: machines.length,
    miembros: members.size,
    online: machines.filter((item) => item.status === "online").length,
    busy: machines.filter((item) => item.status === "busy").length,
    offline: machines.filter((item) => item.status === "offline").length,
    maintenance: machines.filter((item) => item.status === "maintenance").length
  };

  summaryNode.innerHTML = "";
  for (const [label, value] of Object.entries(counts)) {
    const card = document.createElement("div");
    card.className = "summary-card";
    card.innerHTML = `<strong>${value}</strong><span>${label}</span>`;
    summaryNode.append(card);
  }
}

async function syncMachine(id, status, note, currentFocus) {
  if (isStaticMode) {
    return;
  }

  await fetch(apiUrl(`/api/machines/${id}/sync`), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ status, note, currentFocus })
  });
}

function renderMachines(data) {
  machinesNode.innerHTML = "";

  for (const machine of data.machines) {
    const fragment = template.content.cloneNode(true);
    const card = fragment.querySelector(".card");
    const badge = fragment.querySelector(".status-badge");
    const saveButton = fragment.querySelector(".save-button");
    const statusSelect = fragment.querySelector(".status-select");
    const noteInput = fragment.querySelector(".note-input");
    const focusInput = fragment.querySelector(".focus-input");

    fragment.querySelector(".member").textContent = machine.member;
    fragment.querySelector(".name").textContent = machine.name;
    fragment.querySelector(".role").textContent = machine.role ?? "Sin rol definido";
    fragment.querySelector(".id").textContent = machine.id;
    fragment.querySelector(".machine-role").textContent = machine.machineRole ?? "Sin clasificar";
    fragment.querySelector(".location").textContent = machine.location;
    fragment.querySelector(".platform").textContent = machine.platform;
    fragment.querySelector(".color").textContent = machine.color ?? "—";
    fragment.querySelector(".last-seen").textContent = formatDate(machine.lastSeen);
    fragment.querySelector(".note").textContent = machine.note;
    fragment.querySelector(".current-focus").textContent = machine.currentFocus ?? "Sin foco operativo";

    badge.textContent = machine.status;
    badge.classList.add(`status-${machine.status}`);
    statusSelect.value = machine.status;
    noteInput.value = machine.note;
    focusInput.value = machine.currentFocus ?? "";
    if (isStaticMode) {
      statusSelect.disabled = true;
      noteInput.disabled = true;
      focusInput.disabled = true;
      saveButton.disabled = true;
      saveButton.textContent = "Solo lectura";
    }

    saveButton.addEventListener("click", async () => {
      if (isStaticMode) {
        return;
      }

      saveButton.disabled = true;
      saveButton.textContent = "Sincronizando...";
      await syncMachine(machine.id, statusSelect.value, noteInput.value, focusInput.value);
      await load();
    });

    card.dataset.machineId = machine.id;
    machinesNode.append(fragment);
  }
}

async function fetchData() {
  await resolveApiBase();
  try {
    if (!apiBase && !isLocal) {
      throw new Error("api unavailable");
    }
    const response = await fetch(apiUrl("/api/machines"), { cache: "no-store" });
    if (!response.ok) {
      throw new Error("api unavailable");
    }

    isStaticMode = false;
    return await response.json();
  } catch {
    const response = await fetch("./machines.json?v=20260321-1", { cache: "no-store" });
    isStaticMode = true;
    return await response.json();
  }
}

async function load() {
  const data = await fetchData();
  createSummary(data);
  renderMachines(data);
}

load();
