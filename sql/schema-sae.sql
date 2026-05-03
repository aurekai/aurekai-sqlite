-- aurekai-sqlite: sae_dictionaries table
-- Stores Sparse Autoencoder (SAE) dictionary artifacts (.aksae / .bfsae).

CREATE TABLE IF NOT EXISTS sae_dictionaries (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    artifact_name  TEXT    NOT NULL,
    artifact_ext   TEXT    NOT NULL CHECK (artifact_ext IN ('.aksae', '.bfsae')),
    operator_id    TEXT,
    version        TEXT    NOT NULL DEFAULT '0.8.0-alpha.4',
    schema_version TEXT    NOT NULL DEFAULT 'aurekai.deploy.v1',
    layer_index    INTEGER,
    feature_count  INTEGER,
    size_bytes     INTEGER,
    sha256         TEXT,
    payload        BLOB,
    created_at     TEXT    NOT NULL DEFAULT (datetime('now')),
    updated_at     TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_sae_artifact_name ON sae_dictionaries (artifact_name);
CREATE INDEX IF NOT EXISTS idx_sae_operator_id   ON sae_dictionaries (operator_id);
CREATE INDEX IF NOT EXISTS idx_sae_layer_index   ON sae_dictionaries (layer_index);
