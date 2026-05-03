# Quickstart

## 1. Clone the repo

```bash
git clone https://github.com/aurekai/aurekai-sqlite.git
cd aurekai-sqlite
```

## 2. Install Aurekai runtime

```bash
npm install -g @aurekai/runtime@0.8.0-alpha.4
```

## 3. Initialize the database

```bash
bash scripts/init-db.sh /path/to/aurekai.db
```

This applies all five schemas (`model_memory`, `sae_dictionaries`, `semantic_cache`, `manifests`, `proof_bundles`).

## 4. Run doctor deep

```bash
bash scripts/doctor-deep.sh /path/to/aurekai.db
```

Verifies all required tables exist, prints row counts, and runs `akai doctor --deep`.

## 5. Insert a manifest

```python
import sqlite3, json

db = sqlite3.connect("/path/to/aurekai.db")
manifest = json.load(open("examples/sample-aurekai.manifest.json"))
db.execute(
    """INSERT INTO manifests (schema_version, name, version, operator_count, raw_json)
       VALUES (?,?,?,?,?)""",
    (manifest["schema_version"], manifest["name"], manifest["version"],
     manifest["operator_count"], json.dumps(manifest))
)
db.commit()
```

## 6. Pack a model memory artifact

```bash
bash scripts/model-memory-pack.sh /path/to/aurekai.db path/to/artifact.akmodel
```

## 7. Run the release gate

```bash
bash scripts/release-gate.sh /path/to/aurekai.db
```

Checks that all artifact tables have at least one row and no `proof_bundles` row has `status=fail`.

## 8. End-to-end example

```bash
bash examples/sample-db-init.sh
```

## 9. Run the test suite

```bash
bash tests/validate-schemas.sh
bash tests/validate-scripts.sh
```
