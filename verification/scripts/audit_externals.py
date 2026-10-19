#!/usr/bin/env python3
"""Inventory every emitted external interface, distinguishing models from assumptions."""
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
directory = ROOT / 'verification/lean/Bls12381'
template = (directory / 'FunsExternal_Template.lean').read_text()
manual = (directory / 'FunsExternal.lean').read_text()
rows = []
for match in re.finditer(r'^axiom\s+([\w.]+)', template, re.M):
    name = match.group(1)
    found = re.search(r'^(axiom|def)\s+' + re.escape(name) + r'(?=\s)', manual, re.M)
    if not found:
        raise SystemExit(f'Missing external interface: {name}')
    comment = template[template.rfind('/--', 0, match.start()):match.start()]
    rust = re.search(r'/-- \[(.*?)\]:', comment, re.S)
    span = re.search(r"Source: '([^']+)', lines ([\d:]+-[\d:]+)", comment)
    local = bool(span and span.group(1).startswith('src/'))
    if not local:
        reason = 'External dependency interface not supplied by the pinned Aeneas Lean library'
    elif '.sqrt' in name:
        reason = 'Mixed recursive group between Scalar sqrt/sqrt_ratio and ff trait implementations'
    elif '.try_random' in name:
        reason = 'Aeneas internal error on random point closure/control-flow'
    elif '.batch_normalize' in name:
        reason = 'Aeneas Unreachable error on mutable slice iterator in normalization'
    elif '.multiply' in name or name.endswith('.mul'):
        reason = 'Nested iterator closure translation failure; Gt forwarding wrappers share the opaque pattern'
    elif 'recommended_wnaf' in name:
        reason = 'Nested borrows in iteration over static recommendation table'
    elif 'multi_miller_loop' in name:
        reason = 'Nested borrows in Adder doubling_step/addition_step'
    else:
        raise SystemExit(f'Unclassified local external: {name}')
    rows.append({'lean_name': name, 'rust_name': rust.group(1) if rust else None,
                 'source': span.group(1) if span else None,
                 'span': span.group(2) if span else None,
                 'local': local, 'reason': reason,
                 'status': 'manual_model_unproved' if found.group(1) == 'def' else 'unproved_axiom',
                 'rust_equivalence_proved': False})

config = json.loads((ROOT / 'verification/config/extraction.json').read_text())
report = {'schema_version': 1, 'aeneas_commit': config['aeneas_commit'],
          'cargo_args': config['cargo_args'], 'functions': rows,
          'excluded_patterns': config['exclude'],
          'disabled_features': ['bits', 'experimental', 'zeroize', 'nightly'],
          'notes': ['Excluded trait APIs are not represented by generated interfaces.',
                    'Opaque signatures/axioms are not verified implementations.',
                    'Manual models have not been proved equivalent to Rust.',
                    'Aeneas generated function counts include compiler-generated closures and wrappers.']}
(ROOT / 'verification/external-functions.json').write_text(json.dumps(report, indent=2) + '\n')
axioms = sum(row['status'] == 'unproved_axiom' for row in rows)
print(f'External inventory: {len(rows)} interfaces; {len(rows)-axioms} models, {axioms} unproved axioms.')
