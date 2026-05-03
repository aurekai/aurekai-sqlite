#!/usr/bin/env bash
# validate-scripts.sh — Smoke-test all template scripts against a fresh database.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
DB=$(mktemp /tmp/aurekai-validate-XXXXXX.db)
trap 'rm -f "$DB"' EXIT

echo "[validate-scripts] DB: $DB"

# Init
bash "$REPO_ROOT/scripts/init-db.sh" "$DB"

# Manifest insert + verify
sqlite3 "$DB" <<SQL
INSERT INTO manifests (schema_version, name, version, operator_count, raw_json)
VALUES ('aurekai.deploy.v1', 'aurekai', '0.8.0-alpha.4', 89, '{"schema_version":"aurekai.deploy.v1"}');
SQL
bash "$REPO_ROOT/scripts/manifest-verify.sh" "$DB" aurekai 0.8.0-alpha.4

# SAE insert + audit
sqlite3 "$DB" <<SQL
INSERT INTO sae_dictionaries (artifact_name, artifact_ext, layer_index, size_bytes, sha256)
VALUES ('test.aksae', '.aksae', 0, 1024, 'deadbeef');
SQL
bash "$REPO_ROOT/scripts/sae-audit.sh" "$DB"

# Proof bundle insert + export
sqlite3 "$DB" <<SQL
INSERT INTO proof_bundles (recipe_name, status, version, schema_version, proof_json)
VALUES ('test.recipe.json', 'ok', '0.8.0-alpha.4', 'aurekai.deploy.v1', '{"status":"ok"}');
SQL
OUT_DIR=$(mktemp -d /tmp/aurekai-out-XXXXXX)
trap 'rm -rf "$OUT_DIR"; rm -f "$DB"' EXIT
bash "$REPO_ROOT/scripts/proof-bundle-export.sh" "$DB" "$OUT_DIR"
test -f "$OUT_DIR/proof-bundle.json" || { echo "[validate-scripts] FAIL: proof-bundle.json not written" >&2; exit 1; }

# Semantic cache bench (small)
bash "$REPO_ROOT/scripts/semantic-cache-bench.sh" "$DB" 50

# Release gate — semantic_cache and model_memory are empty so it should warn;
# patch them so gate passes
sqlite3 "$DB" <<SQL
INSERT INTO semantic_cache (cache_key, value) VALUES ('smoke-key', 'smoke-val');
INSERT INTO model_memory (artifact_name, artifact_ext) VALUES ('smoke.akmodel', '.akmodel');
SQL
bash "$REPO_ROOT/scripts/release-gate.sh" "$DB"

echo "[validate-scripts] All script checks PASS."
