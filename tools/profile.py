import torch

from fse_ops import dead_zone

x = torch.randn(5_000_000, dtype=torch.float32)

for _ in range(50):
    y = dead_zone(x)

assert y.shape == x.shape
