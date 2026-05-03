#!/usr/bin/env bash
# release-gate.sh — Verify all Aurekai artifact tables are populated before publish.
# Usage: bash scripts/release-gate.sh <db_path>
set -euo pipefail

DB="${1:?Usage: release-gate.sh <db_path>}"
FAIL=0

echo "[release-gate] DB: $DB"
echo "[release-gate] Checking artifact table populations..."

for tbl in model_memory sae_dictionaries semantic_cache manifests proof_bundles; do
    count=$(sqlite3 "$DB" "SELECT count(*) FROM $tbl;" 2>/dev/null || echo 0)
    if [ "$count" -gt 0 ]; then
        echo "  PASS  $tbl: $count row(s)"
    else
        echo "  FAIL  $tbl: 0 rows — not populated" >&2
        FAIL=1
    fi
done

echo "[release-gate] Checking manifest schema version..."
bad=$(sqlite3 "$DB" "SELECT count(*) FROM manifests WHERE schema_version != 'aurekai.deploy.v1';" 2>/dev/null || echo 0)
if [ "$bad" -gt 0 ]; then
    echo "  FAIL  $bad manifest(s) have wrong schema_version" >&2
    FAIL=1
else
    echo "  PASS  All manifests use aurekai.deploy.v1"
fi

echo "[release-gate] Checking proof bundle status..."
failed=$(sqlite3 "$DB" "SELECT count(*) FROM proof_bundles WHERE status='fail';" 2>/dev/null || echo 0)
if [ "$failed" -gt 0 ]; then
    echo "  FAIL  $failed proof bundle(s) have status=fail" >&2
    FAIL=1
else
    echo "  PASS  No failed proof bundles"
fi

if [ "$FAIL" -ne 0 ]; then
    echo "[release-gate] FAIL — release gate did not pass." >&2
    exit 1
fi

echo "[release-gate] PASS — all checks green."
