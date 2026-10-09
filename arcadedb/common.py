"""Minimal ArcadeDB HTTP client (standard library only)."""
import base64
import json
import os
import urllib.request

HOST = "localhost"
PORT = int(os.environ.get("ARCADEDB_HTTP_PORT", "22480"))
PASSWORD = os.environ.get("ARCADEDB_ROOT_PASSWORD", "lsqbbenchmark")
DB = "lsqb"
VERSION = os.environ.get("ARCADEDB_VERSION", "unknown")
AUTH = "Basic " + base64.b64encode(f"root:{PASSWORD}".encode()).decode()


def post(path, payload, timeout=3000):
    req = urllib.request.Request(
        f"http://{HOST}:{PORT}{path}",
        data=json.dumps(payload).encode(),
        headers={"Authorization": AUTH, "Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return json.loads(r.read() or b"{}")
    except urllib.error.HTTPError as e:
        raise SystemExit(f"HTTP {e.code} for {payload.get('command', payload)[:80]!r}: {e.read().decode()[:500]}")


def command(cmd, language="sql", timeout=3000):
    return post(f"/api/v1/command/{DB}", {"language": language, "command": cmd}, timeout)
