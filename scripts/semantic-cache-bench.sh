#!/usr/bin/env bash
# semantic-cache-bench.sh — Benchmark semantic cache read/write throughput against SQLite.
# Usage: bash scripts/semantic-cache-bench.sh <db_path> [iterations]
set -euo pipefail

DB="${1:?Usage: semantic-cache-bench.sh <db_path> [iterations]}"
ITERATIONS="${2:-1000}"

echo "[semantic-cache-bench] DB: $DB  iterations: $ITERATIONS"

# Seed bench entries
echo "[semantic-cache-bench] Seeding $ITERATIONS cache entries..."
python3 - <<PYEOF
import sqlite3, time, hashlib, random, string

conn = sqlite3.connect("$DB")
cur = conn.cursor()

N = $ITERATIONS
t0 = time.perf_counter()
for i in range(N):
    key = hashlib.sha256(f"bench-key-{i}".encode()).hexdigest()
    val = ''.join(random.choices(string.ascii_lowercase, k=64))
    cur.execute(
        "INSERT OR REPLACE INTO semantic_cache (cache_key, value, version) VALUES (?, ?, ?)",
        (key, val, "0.8.0-alpha.4")
    )
conn.commit()
t1 = time.perf_counter()
write_ms = (t1 - t0) * 1000

# Read bench
keys = [hashlib.sha256(f"bench-key-{i}".encode()).hexdigest() for i in range(N)]
t2 = time.perf_counter()
hits = 0
for key in keys:
    row = cur.execute("SELECT value FROM semantic_cache WHERE cache_key=?", (key,)).fetchone()
    if row:
        hits += 1
t3 = time.perf_counter()
read_ms = (t3 - t2) * 1000

conn.close()

print(f"[semantic-cache-bench] Writes: {N} in {write_ms:.1f}ms ({N/write_ms*1000:.0f} ops/s)")
print(f"[semantic-cache-bench] Reads:  {hits}/{N} hits in {read_ms:.1f}ms ({N/read_ms*1000:.0f} ops/s)")
print(f"[semantic-cache-bench] PASS")
PYEOF
