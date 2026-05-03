<p align="center">
  <img src="https://raw.githubusercontent.com/aurekai/aurekai/main/assets/aurekai-logo.svg" alt="Aurekai" width="520" />
</p>

# aurekai-sqlite

Aurekai integration surface for SQLite — lightweight, serverless, embedded data-ml storage for model memory, SAE dictionaries, semantic cache, manifests, and proof bundles.

Status: active
Type: data-ml

## Overview

`aurekai-sqlite` provides DDL schemas and scripts to persist and query Aurekai artifacts using SQLite (`sqlite3`). No server required — everything runs embedded. Works with `akai` CLI, the Python `aurekai` SDK, and any standard SQLite tooling.

## Core Template Set

| Template | Description |
|---|---|
| `doctor-deep` | Connectivity check, schema integrity, and `akai doctor --deep` |
| `manifest-verify` | Validate `aurekai.deploy.v1` manifest row in the database |
| `model-memory-pack` | Insert `.akmodel` / `.bfmodel` artifacts into `model_memory` table |
| `sae-audit` | Audit SAE dictionary rows in `sae_dictionaries` table |
| `semantic-cache-bench` | Benchmark semantic cache read/write throughput against SQLite |
| `proof-bundle-export` | Export proof bundle rows to `out/proof-bundle.json` |
| `release-gate` | Verify all artifact tables are populated before publish |

## Quick Start

```bash
# 1. Install Aurekai runtime
npm install -g @aurekai/runtime@0.8.0-alpha.4

# 2. Init the database
bash scripts/init-db.sh /tmp/aurekai.db

# 3. Run doctor deep
bash scripts/doctor-deep.sh /tmp/aurekai.db

# 4. Pack a model memory artifact
bash scripts/model-memory-pack.sh /tmp/aurekai.db path/to/artifact.akmodel

# 5. Run the release gate
bash scripts/release-gate.sh /tmp/aurekai.db
```

## Directory Layout

```
sql/                   DDL schema files
scripts/               Template scripts (doctor-deep, model-memory-pack, …)
examples/              Sample inputs and usage
tests/                 Validation scripts
docs/                  Quickstart, schema reference, script reference
```

## SQL Schemas

| File | Tables |
|---|---|
| `sql/schema-model-memory.sql` | `model_memory` |
| `sql/schema-sae.sql` | `sae_dictionaries` |
| `sql/schema-semantic-cache.sql` | `semantic_cache` |
| `sql/schema-manifests.sql` | `manifests` |
| `sql/schema-proof-bundles.sql` | `proof_bundles` |

## Canonical References

- Platform: https://github.com/aurekai/aurekai
- Native runtime: https://github.com/aurekai/native-runtime
- Integration registry: https://github.com/aurekai/aurekai/blob/main/registry/integrations.json
- Ecosystem map: https://github.com/aurekai/aurekai/blob/main/ECOSYSTEM_NAMES.md
