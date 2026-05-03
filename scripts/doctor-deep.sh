#!/usr/bin/env bash
# doctor-deep.sh — SQLite connectivity check, schema integrity, and akai doctor --deep.
# Usage: bash scripts/doctor-deep.sh <db_path>
set -euo pipefail

DB="${1:?Usage: doctor-deep.sh <db_path>}"
REQUIRED_TABLES=(model_memory sae_dictionaries semantic_cache manifests proof_bundles)

echo "[doctor-deep] Checking SQLite file: $DB"
if [ ! -f "$DB" ]; then
    echo "[doctor-deep] ERROR: database file not found: $DB" >&2
    exit 1
fi

echo "[doctor-deep] Verifying required tables..."
for tbl in "${REQUIRED_TABLES[@]}"; do
    count=$(sqlite3 "$DB" "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='$tbl';")
    if [ "$count" -ne 1 ]; then
        echo "[doctor-deep] MISSING table: $tbl" >&2
        exit 1
    fi
    echo "  OK: $tbl"
done

echo "[doctor-deep] Row counts:"
for tbl in "${REQUIRED_TABLES[@]}"; do
    rows=$(sqlite3 "$DB" "SELECT count(*) FROM $tbl;")
    echo "  $tbl: $rows rows"
done

echo "[doctor-deep] Running akai doctor --deep ..."
akai doctor --deep

echo "[doctor-deep] PASS"
