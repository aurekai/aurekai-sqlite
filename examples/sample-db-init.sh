#!/usr/bin/env bash
# sample-db-init.sh — End-to-end example: init DB, insert sample manifest, run release gate.
# This is a demo only — artifacts are synthetic.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
DB="/tmp/aurekai-sample.db"

echo "=== aurekai-sqlite sample walkthrough ==="
echo ""

# 1. Init
echo "Step 1: Initialise database"
bash "$REPO_ROOT/scripts/init-db.sh" "$DB"
echo ""

# 2. Insert a manifest
echo "Step 2: Insert sample manifest"
MANIFEST=$(cat "$REPO_ROOT/examples/sample-aurekai.manifest.json")
sqlite3 "$DB" <<SQL
INSERT INTO manifests (schema_version, name, version, operator_count, runtime_ref, helm_chart_ver, pypi_ver, npm_ver, jsr_ver, raw_json)
VALUES (
    'aurekai.deploy.v1',
    'aurekai',
    '0.8.0-alpha.4',
    89,
    'git:1ba1f19',
    '0.8.1',
    '0.8.0a3',
    '0.8.0-alpha.4',
    '0.8.0-alpha.3',
    '$(echo "$MANIFEST" | sed "s/'/''/g")'
);
SQL
echo ""

# 3. Insert a synthetic SAE entry
echo "Step 3: Insert synthetic SAE dictionary row"
sqlite3 "$DB" <<SQL
INSERT INTO sae_dictionaries (artifact_name, artifact_ext, operator_id, layer_index, feature_count, size_bytes, sha256)
VALUES ('layer-0-features.aksae', '.aksae', 'akai_sae_encode', 0, 512, 4096,
        'abc123def456abc123def456abc123def456abc123def456abc123def456abc123');
SQL
echo ""

# 4. Insert a proof bundle
echo "Step 4: Insert proof bundle"
sqlite3 "$DB" <<SQL
INSERT INTO proof_bundles (recipe_name, status, operator_id, version, schema_version, proof_json)
VALUES ('bench.recipe.json', 'ok', 'akai_run_operator', '0.8.0-alpha.4', 'aurekai.deploy.v1',
        '{"status":"ok","proof":"generated","recipe":"bench.recipe.json"}');
SQL
echo ""

# 5. Semantic cache bench (100 iterations as quick smoke test)
echo "Step 5: Semantic cache smoke bench (100 iterations)"
bash "$REPO_ROOT/scripts/semantic-cache-bench.sh" "$DB" 100
echo ""

# 6. Release gate
echo "Step 6: Release gate"
bash "$REPO_ROOT/scripts/release-gate.sh" "$DB" || true
echo ""

echo "=== Done. DB at: $DB ==="
