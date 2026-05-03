# Scripts Reference

All scripts in `scripts/` accept `<db_path>` as their first argument.

---

## `init-db.sh`

```
bash scripts/init-db.sh <db_path>
```

Applies all five DDL schema files in order. Safe to run on an existing database (uses `CREATE TABLE IF NOT EXISTS`).

---

## `doctor-deep.sh`

```
bash scripts/doctor-deep.sh <db_path>
```

1. Verifies the database file exists.
2. Checks all five required tables are present.
3. Prints row counts per table.
4. Runs `akai doctor --deep`.

Exit 1 on any failure.

---

## `manifest-verify.sh`

```
bash scripts/manifest-verify.sh <db_path> <name> <version>
```

Queries `manifests` for a row matching `(name, version, schema_version='aurekai.deploy.v1')`. Prints the matched row and exits 1 if not found.

---

## `model-memory-pack.sh`

```
bash scripts/model-memory-pack.sh <db_path> <artifact_path> [operator_id]
```

Inserts an `.akmodel`, `.bfmodel`, `.akfpqx`, or `.bffpqx` artifact file into the `model_memory` table, including `size_bytes`, `sha256`, and raw payload bytes via SQLite's `readfile()`.

---

## `sae-audit.sh`

```
bash scripts/sae-audit.sh <db_path>
```

Prints total row count, breakdown by extension and operator, and warns if any rows are missing `sha256`.

---

## `semantic-cache-bench.sh`

```
bash scripts/semantic-cache-bench.sh <db_path> [iterations]
```

Runs `iterations` (default 1000) write + read operations against `semantic_cache` and prints throughput in ops/s.

---

## `proof-bundle-export.sh`

```
bash scripts/proof-bundle-export.sh <db_path> [output_dir]
```

Exports all `proof_bundles` rows to `<output_dir>/proof-bundle.json` (default `out/`). The JSON structure is:

```json
{
  "status": "ok",
  "count": 3,
  "bundles": [ ... ]
}
```

---

## `release-gate.sh`

```
bash scripts/release-gate.sh <db_path>
```

Checks:
1. Every table has at least one row.
2. All manifests use `schema_version = 'aurekai.deploy.v1'`.
3. No `proof_bundles` row has `status = 'fail'`.

Exits 1 if any check fails — suitable as a CI pre-publish gate.
