# FSE Final Project: Dead Zone

This repository contains a custom PyTorch C++ extension `fse_ops.dead_zone`.

## The Operation
**Name:** `fse_ops.dead_zone`

**Formula in words:** 
For each element in the input tensor, if its absolute value is strictly less than 1, the element is replaced with 0. Otherwise, the element remains unchanged. Values exactly equal to -1.0 or 1.0 are not zeroed out.

## Build, Install, and Test

All commands are wrapped in the `Makefile`:

```bash
# Build the wheel into dist/
make wheel

# Install the wheel into the current environment
make install

# Run the pytest suite against the installed wheel
make test
