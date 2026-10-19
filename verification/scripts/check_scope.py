#!/usr/bin/env python3
"""Check the frozen source inventory; this is not a Rust parser or a proof checker."""

import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
FUNCTION = re.compile(r"^\s*(?:pub(?:\([^)]*\))?\s+)?(?:const\s+)?fn\s+(\w+)")
TEST_START = re.compile(r"^\s*#\[(?:test|cfg\(test\))\]")


def tracked_paths():
    return sorted([p.relative_to(ROOT).as_posix() for p in (ROOT / "src").rglob("*.rs")]
                  + ["Cargo.toml", "Cargo.lock", "rust-toolchain.toml", "README.md"])


def inventory(path):
    """Current layout: production prefix followed by tests. No macro expansion."""
    functions = []
    cutoff = None
    for number, line in enumerate((ROOT / path).read_text().splitlines(), 1):
        if TEST_START.match(line):
            cutoff = number
            break
        match = FUNCTION.match(line)
        if match:
            name = match.group(1)
            functions.append({"id": f"{path}:{number}:{name}", "name": name,
                              "line": number, "signature_start": line.strip()})
    return functions, cutoff


def check():
    baseline = json.loads((ROOT / "verification/baseline.json").read_text())
    coverage = json.loads((ROOT / "verification/coverage.json").read_text())
    errors = []
    if sorted(baseline["sha256"]) != tracked_paths():
        errors.append("Baseline file set changed")
    for path, expected in baseline["sha256"].items():
        actual = hashlib.sha256((ROOT / path).read_bytes()).hexdigest() if (ROOT / path).exists() else None
        if actual != expected:
            errors.append(f"Baseline differs: {path}")
    if coverage["baseline_commit"] != baseline["commit"]:
        errors.append("Coverage commit differs from baseline")
    expected_sources = sorted(p for p in tracked_paths() if p.endswith(".rs"))
    sources = [m["source"] for m in coverage["modules"]]
    if sorted(sources) != expected_sources:
        errors.append("Coverage module set differs from baseline")
    count = 0
    for module in coverage["modules"]:
        functions, cutoff = inventory(module["source"])
        recorded = [{k: row[k] for k in ("id", "name", "line", "signature_start")}
                    for row in module["functions"]]
        if functions != recorded or cutoff != module["test_region_start"]:
            errors.append(f"Inventory differs: {module['source']}")
        for row in module["functions"]:
            if row["contract"] not in coverage["contracts"]:
                errors.append(f"Unknown contract: {row['id']}")
            if row["proof_status"] != "not_started" or row["theorem"] is not None:
                errors.append(f"Step-one checker cannot certify proof status: {row['id']}")
        count += len(functions)
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Scope consistent: {len(baseline['sha256'])} baseline files, "
          f"{len(sources)} Rust modules, {count} lexical function entries; 0 proved.")
    print("Macro expansion, cfg reachability and external dependency closure remain for step 2.")
    return 0


if __name__ == "__main__":
    sys.exit(check())
