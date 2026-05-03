-- aurekai-sqlite: proof_bundles table
-- Stores proof bundle export records from `akai run --sae-audit`.

CREATE TABLE IF NOT EXISTS proof_bundles (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    recipe_name    TEXT    NOT NULL,
    status         TEXT    NOT NULL DEFAULT 'ok' CHECK (status IN ('ok', 'fail', 'partial')),
    operator_id    TEXT,
    version        TEXT    NOT NULL DEFAULT '0.8.0-alpha.4',
    schema_version TEXT    NOT NULL DEFAULT 'aurekai.deploy.v1',
    proof_json     TEXT    NOT NULL,
    exported_at    TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_proof_bundles_recipe_name ON proof_bundles (recipe_name);
CREATE INDEX IF NOT EXISTS idx_proof_bundles_status      ON proof_bundles (status);
CREATE INDEX IF NOT EXISTS idx_proof_bundles_operator_id ON proof_bundles (operator_id);
