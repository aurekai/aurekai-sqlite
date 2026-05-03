#!/usr/bin/env bash
# proof-bundle-export.sh — Export proof bundle rows from SQLite to JSON.
# Usage: bash scripts/proof-bundle-export.sh <db_path> [output_dir]
set -euo pipefail

DB="${1:?Usage: proof-bundle-export.sh <db_path> [output_dir]}"
OUT_DIR="${2:-out}"

mkdir -p "$OUT_DIR"
EXPORT_FILE="$OUT_DIR/proof-bundle.json"

echo "[proof-bundle-export] DB: $DB  output: $EXPORT_FILE"

count=$(sqlite3 "$DB" "SELECT count(*) FROM proof_bundles;")
echo "[proof-bundle-export] Rows to export: $count"

python3 - <<PYEOF
import sqlite3, json

conn = sqlite3.connect("$DB")
conn.row_factory = sqlite3.Row
rows = conn.execute(
    "SELECT id, recipe_name, status, operator_id, version, schema_version, proof_json, exported_at FROM proof_bundles ORDER BY exported_at DESC"
).fetchall()

bundles = []
for row in rows:
    entry = dict(row)
    try:
        entry["proof"] = json.loads(entry.pop("proof_json"))
    except Exception:
        entry["proof"] = entry.pop("proof_json")
    bundles.append(entry)

output = {"status": "ok", "count": len(bundles), "bundles": bundles}
with open("$EXPORT_FILE", "w") as f:
    json.dump(output, f, indent=2)

conn.close()
print(f"[proof-bundle-export] Wrote {len(bundles)} bundle(s) to $EXPORT_FILE")
print("[proof-bundle-export] PASS")
PYEOF
