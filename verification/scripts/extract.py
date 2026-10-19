#!/usr/bin/env python3
"""Run pinned Charon/Aeneas; retain diagnostics and never overwrite FunsExternal.lean."""
import json
import os
from pathlib import Path
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[2]
config = json.loads((ROOT / 'verification/config/extraction.json').read_text())
tools = Path(os.environ.get('AENEAS_ROOT', config['tool_root']))
for directory, key in [(tools, 'aeneas_commit'), (tools / 'charon', 'charon_commit')]:
    actual = subprocess.check_output(['git', '-C', str(directory), 'rev-parse', 'HEAD'], text=True).strip()
    if actual != config[key]:
        sys.exit(f'{key} mismatch: expected {config[key]}, found {actual}')
for directory in ['logs', 'llbc', 'lean/Bls12381']:
    (ROOT / 'verification' / directory).mkdir(parents=True, exist_ok=True)
env = dict(os.environ, RUSTUP_TOOLCHAIN='nightly-2026-06-01', CARGO_TARGET_DIR=str(ROOT / 'verification/target'))
args = [str(tools / 'charon/bin/charon'), 'cargo', '--preset=aeneas', '--dest-file', str(ROOT / 'verification/llbc/bls12_381.llbc')]
for option in ['opaque', 'exclude']:
    for pattern in config[option]:
        args.extend(['--' + option, pattern])
args += ['--'] + config['cargo_args']
commands = [args, [str(tools / 'bin/aeneas'), '-backend', 'lean', '-loops-to-rec', '-split-files', '-emit-json', '-no-progress-bar', '-namespace', 'Bls12381', '-dest', str(ROOT / 'verification/lean/Bls12381'), str(ROOT / 'verification/llbc/bls12_381.llbc')]]
results = []
for name, command in zip(['charon', 'aeneas'], commands):
    # Remove only stale intermediate output; never touch handwritten external models.
    if name == 'charon':
        (ROOT / 'verification/llbc/bls12_381.llbc').unlink(missing_ok=True)
    with (ROOT / f'verification/logs/{name}.log').open('w') as log:
        result = subprocess.run(command, cwd=ROOT, env=env, stdout=log, stderr=subprocess.STDOUT)
    results.append({'tool': name, 'command': command, 'exit_code': result.returncode})
    print(f'{name}: exit {result.returncode}; verification/logs/{name}.log', flush=True)
    if result.returncode != 0:
        break
(ROOT / 'verification/logs/run.json').write_text(json.dumps(results, indent=2) + '\n')
if results[-1]['exit_code']:
    sys.exit(results[-1]['exit_code'])
subprocess.run([sys.executable, str(ROOT / 'verification/scripts/postprocess.py')], check=True, cwd=ROOT)
subprocess.run([sys.executable, str(ROOT / 'verification/scripts/audit_externals.py')], check=True, cwd=ROOT)
