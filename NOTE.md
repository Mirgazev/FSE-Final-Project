# Project Note

## Bug encountered

During development, the GitHub Actions workflow was invalid and GitHub reported `No event triggers defined in on`. This meant that the repository did not have a working CI pipeline.

The issue was fixed by adding a valid `.github/workflows/ci.yml` with push and pull-request triggers and the required Ruff and pytest steps. The fix was introduced in commit `f091dde` (`fixed Dockerfile and added ci.yml`).

## Unsupported input case

`fse_ops.dead_zone` supports CPU tensors with `torch.float32` dtype.

Tensors with another dtype, for example `torch.int64`, are rejected by the C++ `TORCH_CHECK`. In Python this appears as a `RuntimeError` with the message `dead_zone expects torch.float32`.

## Profiling

The operation was profiled on a CPU tensor containing 5,000,000 `float32` elements. The operation was called 50 times.

Command used:

/tmp/smoke-venv/bin/python -m cProfile -s cumulative tools/profile.py

`cProfile` reported 1.467 seconds for the complete program. The 50 calls to the compiled `fse_ops._C.dead_zone` function used 0.317 seconds cumulatively, with 0.006 seconds per call reported by `cProfile`.
