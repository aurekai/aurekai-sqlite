#!/usr/bin/env bash
# manifest-verify.sh — Verify an aurekai.deploy.v1 manifest is stored in the DB.
# Usage: bash scripts/manifest-verify.sh <db_path> <manifest_name> <manifest_version>
set -euo pipefail

DB="${1:?Usage: manifest-verify.sh <db_path> <name> <version>}"
MANIFEST_NAME="${2:?manifest name required}"
MANIFEST_VERSION="${3:?manifest version required}"

echo "[manifest-verify] DB: $DB  name: $MANIFEST_NAME  version: $MANIFEST_VERSION"

count=$(sqlite3 "$DB" \
    "SELECT count(*) FROM manifests WHERE name='$MANIFEST_NAME' AND version='$MANIFEST_VERSION' AND schema_version='aurekai.deploy.v1';")

if [ "$count" -lt 1 ]; then
    echo "[manifest-verify] FAIL: manifest not found or schema_version mismatch." >&2
    exit 1
fi

echo "[manifest-verify] Found $count row(s)."
sqlite3 "$DB" -header -column \
    "SELECT id, name, version, schema_version, operator_count, created_at FROM manifests WHERE name='$MANIFEST_NAME' AND version='$MANIFEST_VERSION';"
echo "[manifest-verify] PASS"
