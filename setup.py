from setuptools import setup
from torch.utils.cpp_extension import BuildExtension, CppExtension

setup(
    ext_modules=[
        CppExtension(
            "fse_ops._C",
            ["src/fse_ops/ops.cpp"],
        )
    ],
    cmdclass={
        "build_ext": BuildExtension,
    },
)
