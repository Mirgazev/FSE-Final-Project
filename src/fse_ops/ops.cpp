#include <torch/extension.h>

torch::Tensor dead_zone(torch::Tensor x) {
    TORCH_CHECK(
        x.device().is_cpu(),
        "dead_zone expects a CPU tensor"
    );

    TORCH_CHECK(
        x.scalar_type() == torch::kFloat32,
        "dead_zone expects torch.float32"
    );

    return torch::where(
        x.abs() < 1,
        torch::zeros_like(x),
        x
    );
}

PYBIND11_MODULE(TORCH_EXTENSION_NAME, m) {
    m.def("dead_zone", &dead_zone, "Dead-zone operation");
}
