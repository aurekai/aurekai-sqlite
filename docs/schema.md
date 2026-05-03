# Schema Reference

## model_memory

Stores `.akmodel`, `.bfmodel`, `.akfpqx`, `.bffpqx` artifact metadata and optional binary payload.

| Column | Type | Notes |
|---|---|---|
| `id` | INTEGER PK | Auto-increment |
| `artifact_name` | TEXT | File name of the artifact |
| `artifact_ext` | TEXT | `.akmodel` / `.bfmodel` / `.akfpqx` / `.bffpqx` |
| `operator_id` | TEXT | Aurekai operator that produced the artifact |
| `version` | TEXT | Aurekai release version |
| `schema_version` | TEXT | Always `aurekai.deploy.v1` |
| `size_bytes` | INTEGER | File size |
| `sha256` | TEXT | Hex SHA-256 checksum |
| `payload` | BLOB | Raw artifact bytes (optional) |
| `created_at` | TEXT | ISO-8601 UTC |
| `updated_at` | TEXT | ISO-8601 UTC |

---

## sae_dictionaries

Stores `.aksae` / `.bfsae` Sparse Autoencoder dictionary artifacts.

| Column | Type | Notes |
|---|---|---|
| `id` | INTEGER PK | Auto-increment |
| `artifact_name` | TEXT | File name |
| `artifact_ext` | TEXT | `.aksae` / `.bfsae` |
| `operator_id` | TEXT | Producing operator |
| `version` | TEXT | Aurekai release version |
| `schema_version` | TEXT | Always `aurekai.deploy.v1` |
| `layer_index` | INTEGER | Network layer index |
| `feature_count` | INTEGER | Number of learned features |
| `size_bytes` | INTEGER | File size |
| `sha256` | TEXT | Hex SHA-256 checksum |
| `payload` | BLOB | Raw bytes (optional) |
| `created_at` | TEXT | ISO-8601 UTC |
| `updated_at` | TEXT | ISO-8601 UTC |

---

## semantic_cache

Stores semantic cache key→value pairs with optional embedding blobs.

| Column | Type | Notes |
|---|---|---|
| `id` | INTEGER PK | Auto-increment |
| `cache_key` | TEXT UNIQUE | Hash key (e.g. SHA-256 of input) |
| `embedding` | BLOB | Optional embedding vector |
| `value` | TEXT | Cached response |
| `hit_count` | INTEGER | Number of times this entry was served |
| `version` | TEXT | Aurekai release version |
| `expires_at` | TEXT | ISO-8601 UTC expiry (nullable) |
| `created_at` | TEXT | ISO-8601 UTC |
| `updated_at` | TEXT | ISO-8601 UTC |

---

## manifests

Stores `aurekai.deploy.v1` deploy manifest records.

| Column | Type | Notes |
|---|---|---|
| `id` | INTEGER PK | Auto-increment |
| `schema_version` | TEXT | Always `aurekai.deploy.v1` |
| `name` | TEXT | Manifest name (e.g. `aurekai`) |
| `version` | TEXT | Release version |
| `operator_count` | INTEGER | Number of operators in release |
| `runtime_ref` | TEXT | Native runtime git ref |
| `helm_chart_ver` | TEXT | Helm chart version |
| `pypi_ver` | TEXT | PyPI package version |
| `npm_ver` | TEXT | npm package version |
| `jsr_ver` | TEXT | JSR package version |
| `raw_json` | TEXT | Full manifest JSON |
| `created_at` | TEXT | ISO-8601 UTC |

Unique constraint on `(name, version)`.

---

## proof_bundles

Stores proof bundle export records from `akai run --sae-audit`.

| Column | Type | Notes |
|---|---|---|
| `id` | INTEGER PK | Auto-increment |
| `recipe_name` | TEXT | Recipe file that was run |
| `status` | TEXT | `ok` / `fail` / `partial` |
| `operator_id` | TEXT | Producing operator |
| `version` | TEXT | Aurekai release version |
| `schema_version` | TEXT | Always `aurekai.deploy.v1` |
| `proof_json` | TEXT | Proof bundle JSON payload |
| `exported_at` | TEXT | ISO-8601 UTC |
