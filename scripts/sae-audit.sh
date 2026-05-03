#!/usr/bin/env bash
# sae-audit.sh — Audit SAE dictionary rows in the database.
# Usage: bash scripts/sae-audit.sh <db_path>
set -euo pipefail

DB="${1:?Usage: sae-audit.sh <db_path>}"

echo "[sae-audit] DB: $DB"

total=$(sqlite3 "$DB" "SELECT count(*) FROM sae_dictionaries;")
echo "[sae-audit] Total SAE rows: $total"

if [ "$total" -eq 0 ]; then
    echo "[sae-audit] WARNING: no SAE dictionary artifacts found in database."
fi

echo "[sae-audit] Breakdown by extension:"
sqlite3 "$DB" -header -column \
    "SELECT artifact_ext, count(*) as count, sum(size_bytes) as total_bytes FROM sae_dictionaries GROUP BY artifact_ext;"

echo "[sae-audit] Breakdown by operator:"
sqlite3 "$DB" -header -column \
    "SELECT operator_id, count(*) as count FROM sae_dictionaries GROUP BY operator_id ORDER BY count DESC;"

echo "[sae-audit] Integrity check (NULL sha256):"
nullsha=$(sqlite3 "$DB" "SELECT count(*) FROM sae_dictionaries WHERE sha256 IS NULL;")
if [ "$nullsha" -gt 0 ]; then
    echo "[sae-audit] WARNING: $nullsha row(s) missing sha256 checksum." >&2
else
    echo "  All rows have sha256."
fi

echo "[sae-audit] PASS"
