import pytest
import torch
from fse_ops import dead_zone


def test_shape():
    """1. The shape of the output."""
    x = torch.tensor(
        [[0.2, 2.0], [-3.0, 0.5]],
        dtype=torch.float32,
    )

    result = dead_zone(x)

    assert result.shape == x.shape


def test_output_dtype():
    """2. The dtype of the output is preserved."""
    x = torch.randn(5, dtype=torch.float32)
    out = dead_zone(x)
    assert out.dtype == torch.float32


def test_numeric():
    """3. One exact numeric input, compared with the pure-PyTorch specification line."""
    x = torch.tensor(
        [-2.0, -0.5, 0.0, 0.7, 3.0],
        dtype=torch.float32,
    )

    expected = torch.where(
        x.abs() < 1,
        torch.zeros_like(x),
        x,
    )

    assert torch.equal(dead_zone(x), expected)


def test_fake_op_cannot_survive():
    """4. An anti-fake test with varied values, including boundaries -1.0 and 1.0."""
    # If someone just returns x, this fails. If someone returns a constant, this fails.
    # -3.0 stays -3.0, -1.0 stays -1.0 (boundary!), 0.5 becomes 0.0, 1.0 stays 1.0 (boundary!)
    x = torch.tensor([-3.0, -1.0, 0.5, 1.0], dtype=torch.float32)
    expected = torch.tensor([-3.0, -1.0, 0.0, 1.0], dtype=torch.float32)
    
    out = dead_zone(x)
    assert torch.equal(out, expected)


def test_error_path():
    """5. Test an unsupported dtype. The C++ TORCH_CHECK must cause RuntimeError."""
    # Passing an integer tensor should trigger TORCH_CHECK
    x = torch.tensor([1, 2, 3], dtype=torch.int32)
    
    with pytest.raises(RuntimeError, match="dead_zone expects torch.float32"):
        dead_zone(x)
        
def test_error_cpu_only():
    """5b. Test that a non-CPU tensor raises RuntimeError via TORCH_CHECK."""
    try:
        x = torch.empty(3, device="meta") 
    except RuntimeError:
        pytest.skip("Meta device is not supported in this PyTorch version")
        
    with pytest.raises(RuntimeError, match="dead_zone expects a CPU tensor"):
        dead_zone(x)
