#!/usr/bin/env bash
# validate-schemas.sh — Confirm all SQL schema files apply cleanly to a fresh database.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
DB=$(mktemp /tmp/aurekai-validate-XXXXXX.db)
trap 'rm -f "$DB"' EXIT

echo "[validate-schemas] Testing against: $DB"

bash "$REPO_ROOT/scripts/init-db.sh" "$DB"

EXPECTED_TABLES=(model_memory sae_dictionaries semantic_cache manifests proof_bundles)
for tbl in "${EXPECTED_TABLES[@]}"; do
    count=$(sqlite3 "$DB" "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='$tbl';")
    if [ "$count" -ne 1 ]; then
        echo "[validate-schemas] FAIL: table $tbl not found." >&2
        exit 1
    fi
    echo "  OK: $tbl"
done

echo "[validate-schemas] PASS — all tables present."
