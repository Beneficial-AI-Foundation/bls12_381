#!/usr/bin/env python3
"""Explicit, audited compatibility patches for Aeneas 5d08da45 / Lean 4.31.
Run only on freshly generated output. No mathematical algorithms are replaced here.
"""
import json
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[2]
p = ROOT / 'verification/lean/Bls12381/Funs.lean'
s = p.read_text()
changes = []
def replace(old, new, expected):
    global s
    count = s.count(old)
    if count != expected:
        raise RuntimeError(f'Expected {expected} occurrences, got {count}: {old}')
    s = s.replace(old, new)
    changes.append({'old': old, 'new': new, 'count': count})
replace('(by :', '(«by» :', 4)
replace('core.cmp.Eq.assert_fields_are_eq.default', 'assert_fields_are_eq_trait_default', 11)
# The builtin Iterator contains only next; adapters are separate model functions.
start = s.index('  map :=', s.index('impl_def core.iter.adapters.rev.Rev.Insts.CoreIterTraitsIteratorIterator'))
end = s.index('\n}', start)
removed = s[start:end]
assert '  fold :=' in removed and '  rev :=' in removed
s = s[:start] + s[end:]
changes.append({'reason': 'Builtin Iterator has no map/fold/rev fields; use external adapter functions', 'removed': removed})
replace('coreitertraitsiteratorIteratorInst.fold', 'core.iter.traits.iterator.Iterator.fold.default coreitertraitsiteratorIteratorInst', 5)
for method in ['doubling_step','addition_step']:
    name='pairings.FromG2PreparedG2Affine.from.Adder.Insts.Bls12_381PairingsMillerLoopDriverTuple.'+method
    replace('  '+method+' :=\n    '+name+'\n', '  '+method+' := fun self x => do\n    let self ← '+name+' self x\n    ok ((), self)\n', 1)
p.write_text(s)
(ROOT / 'verification/logs/postprocess.json').write_text(json.dumps(changes, indent=2, ensure_ascii=False)+'\n')
print(f'Applied {len(changes)} recorded compatibility patches.')
