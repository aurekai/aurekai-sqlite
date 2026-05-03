-- aurekai-sqlite: model_memory table
-- Stores .akmodel / .bfmodel artifact metadata and binary payload.

CREATE TABLE IF NOT EXISTS model_memory (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    artifact_name  TEXT    NOT NULL,
    artifact_ext   TEXT    NOT NULL CHECK (artifact_ext IN ('.akmodel', '.bfmodel', '.akfpqx', '.bffpqx')),
    operator_id    TEXT,
    version        TEXT    NOT NULL DEFAULT '0.8.0-alpha.4',
    schema_version TEXT    NOT NULL DEFAULT 'aurekai.deploy.v1',
    size_bytes     INTEGER,
    sha256         TEXT,
    payload        BLOB,
    created_at     TEXT    NOT NULL DEFAULT (datetime('now')),
    updated_at     TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_model_memory_artifact_name ON model_memory (artifact_name);
CREATE INDEX IF NOT EXISTS idx_model_memory_operator_id   ON model_memory (operator_id);
CREATE INDEX IF NOT EXISTS idx_model_memory_version       ON model_memory (version);
