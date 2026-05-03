-- aurekai-sqlite: semantic_cache table
-- Stores semantic cache entries (embedding key → cached value).

CREATE TABLE IF NOT EXISTS semantic_cache (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    cache_key    TEXT    NOT NULL UNIQUE,
    embedding    BLOB,
    value        TEXT    NOT NULL,
    hit_count    INTEGER NOT NULL DEFAULT 0,
    version      TEXT    NOT NULL DEFAULT '0.8.0-alpha.4',
    expires_at   TEXT,
    created_at   TEXT    NOT NULL DEFAULT (datetime('now')),
    updated_at   TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_semantic_cache_key        ON semantic_cache (cache_key);
CREATE INDEX IF NOT EXISTS idx_semantic_cache_expires_at ON semantic_cache (expires_at);
