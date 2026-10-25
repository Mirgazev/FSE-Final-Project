# FSE Final Project: Dead Zone

This repository contains a custom PyTorch C++ extension `fse_ops.dead_zone`.

## The Operation
**Name:** `fse_ops.dead_zone`

**Formula in words:** 
For each element in the input tensor, if its absolute value is strictly less than 1, the element is replaced with 0. Otherwise, the element remains unchanged. Values exactly equal to -1.0 or 1.0 are not zeroed out.

`fse_ops.dead_zone` supports CPU tensors only with `torch.float32` dtype.

## Build, Install, and Test

Inside `lab`, at the root directory of this project, you need to run:

```bash
python3 -m venv .venv
. .venv/bin/activate

python -m pip install torch --index-url https://download.pytorch.org/whl/cpu
python -m pip install pytest

make wheel
make install
make test
```
