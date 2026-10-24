#!/bin/bash

ROOT="$(pwd)" && \
rm -rf dist build /tmp/smoke-build /tmp/smoke-venv && \
echo "=== 1. Building wheel ===" && \
python3 -m venv /tmp/smoke-build && \
/tmp/smoke-build/bin/pip install torch \
    --index-url https://download.pytorch.org/whl/cpu && \
/tmp/smoke-build/bin/pip wheel . --no-deps -w dist && \
echo "=== 2. Checking wheel tag ===" && \
ls dist/*.whl | grep linux && \
echo "=== 3. Creating clean venv ===" && \
python3 -m venv /tmp/smoke-venv && \
echo "=== 4. Installing torch and our wheel ===" && \
/tmp/smoke-venv/bin/pip install torch \
    --index-url https://download.pytorch.org/whl/cpu && \
/tmp/smoke-venv/bin/pip install "$ROOT"/dist/*.whl && \
echo "=== 5. Testing import and call from neutral directory ===" && \
cd /tmp && \
/tmp/smoke-venv/bin/python -c 'import torch; from fse_ops import dead_zone; x=torch.tensor([-2.0,0.5,2.0],dtype=torch.float32); expected=torch.tensor([-2.0,0.0,2.0],dtype=torch.float32); assert torch.equal(dead_zone(x),expected)' && \
echo "OK"
