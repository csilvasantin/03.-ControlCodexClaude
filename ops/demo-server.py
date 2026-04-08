#!/usr/bin/env python3
"""
demo-server.py — Servidor ligero para demos en directo.
Expone el estado de Tailscale como JSON en http://localhost:3031/status
La pagina admiranext.html lo consulta cada 3s en modo DEMO.

Uso:
  python ops/demo-server.py
"""

import json
import re
import subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler
from pathlib import Path

PORT = 3031
MACHINES_PATH = Path(__file__).resolve().parent.parent / "data" / "machines.json"

TAILSCALE_TO_ID = {
    "macmini":              "admira-macmini",
    "macbookairnines":      "admira-macbookairnines",
    "macbookpronegro14":    "admira-macbookpronegro14",
    "macbookair16":         "admira-macbookair16",
    "macbookairluna":       "admira-macbookairluna",
    "macbookairluna-1":     "admira-macbookairazul",
    "macbook-air-de-carla": "admira-macbook-carla",
    "macbookairblanco":     "admira-macbookairblanco",
    "macbookairplata":      "admira-macbookairplata",
    "macbookairazul":       "admira-macbookairazul",
}


def get_tailscale_live():
    """Ejecuta tailscale status y devuelve dict {machine_id: online/offline}."""
    try:
        result = subprocess.run(
            ["tailscale", "status"], capture_output=True, text=True, timeout=5
        )
    except Exception:
        return {}

    status = {}
    for line in result.stdout.strip().splitlines():
        parts = line.split()
        if len(parts) < 4:
            continue
        hostname = parts[1]
        rest = " ".join(parts[4:])
        is_offline = "offline" in rest
        machine_id = TAILSCALE_TO_ID.get(hostname)
        if machine_id:
            status[machine_id] = "offline" if is_offline else "online"
    return status


def build_response():
    """Lee machines.json y sobreescribe status con Tailscale en vivo."""
    try:
        data = json.loads(MACHINES_PATH.read_text(encoding="utf-8"))
    except Exception:
        data = {"machines": []}

    live = get_tailscale_live()

    for m in data.machines if hasattr(data, 'machines') else data.get("machines", []):
        ts_status = live.get(m["id"])
        if ts_status:
            m["status"] = ts_status

    return data


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/status" or self.path.startswith("/status?"):
            payload = build_response()
            body = json.dumps(payload).encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header("Cache-Control", "no-cache")
            self.end_headers()
            self.write(body)
        elif self.path == "/ping":
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.write(b"pong")
        else:
            self.send_response(404)
            self.end_headers()

    def do_OPTIONS(self):
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def write(self, data):
        self.wfile.write(data)

    def log_message(self, format, *args):
        status_line = args[0] if args else ""
        if "/ping" not in str(status_line):
            print(f"[DEMO] {self.address_string()} {format % args}")


if __name__ == "__main__":
    print(f"Demo server en http://localhost:{PORT}/status")
    print("La pagina admiranext.html consulta este endpoint en modo DEMO.")
    print("Ctrl+C para parar.\n")
    HTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
