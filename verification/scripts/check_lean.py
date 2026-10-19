#!/usr/bin/env python3
"""Compile against read-only, already built Lean dependencies; no writes to the donor repo.
For standalone builds use `cd verification/lean && lake build` instead.
"""
import json
import os
from pathlib import Path
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[2]
project = ROOT / 'verification/lean'
(ROOT / 'verification/logs').mkdir(parents=True, exist_ok=True)
cache = Path(os.environ.get('AENEAS_LEAN_CACHE', '/home/zhang-liao/auto_verify_dalek/curve25519-dalek-u32/.lake/packages'))
config = json.loads((ROOT / 'verification/config/extraction.json').read_text())
cache_commit = subprocess.check_output(['git', '-C', str(cache / 'aeneas'), 'rev-parse', 'HEAD'], text=True).strip()
if cache_commit != config['aeneas_commit']:
    sys.exit(f'Aeneas Lean cache version mismatch: {cache_commit}')
paths = [str(project / '.lake/build/lib/lean')]
paths += [str(p) for p in sorted(cache.glob('*/.lake/build/lib/lean'))]
paths += [str(cache / 'aeneas/backends/lean/.lake/build/lib/lean')]
env = dict(os.environ, LEAN_PATH=os.pathsep.join(paths))
lean = Path.home() / '.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean'
modules = sys.argv[1:] or ['Bls12381.TypesExternal','Bls12381.Types','Bls12381.FunsExternal','Bls12381.Funs','Bls12381']
for module in modules:
    rel = Path(*module.split('.'))
    out = project / '.lake/build/lib/lean' / rel.with_suffix('.olean')
    out.parent.mkdir(parents=True, exist_ok=True)
    log_path = ROOT / 'verification/logs' / (module + '.log')
    with log_path.open('w') as log:
        result = subprocess.run([str(lean), '-o', str(out), str(rel.with_suffix('.lean'))], cwd=project, env=env, stdout=log, stderr=subprocess.STDOUT)
    print(f'{module}: exit {result.returncode}; {log_path.relative_to(ROOT)}', flush=True)
    if result.returncode:
        print(log_path.read_text()[:12000])
        sys.exit(result.returncode)
