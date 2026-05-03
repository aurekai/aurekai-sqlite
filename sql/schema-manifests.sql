-- aurekai-sqlite: manifests table
-- Stores aurekai.deploy.v1 manifest records.

CREATE TABLE IF NOT EXISTS manifests (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    schema_version  TEXT    NOT NULL DEFAULT 'aurekai.deploy.v1',
    name            TEXT    NOT NULL,
    version         TEXT    NOT NULL,
    operator_count  INTEGER,
    runtime_ref     TEXT,
    helm_chart_ver  TEXT,
    pypi_ver        TEXT,
    npm_ver         TEXT,
    jsr_ver         TEXT,
    raw_json        TEXT    NOT NULL,
    created_at      TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_manifests_name_version ON manifests (name, version);
CREATE INDEX IF NOT EXISTS idx_manifests_schema_version      ON manifests (schema_version);
