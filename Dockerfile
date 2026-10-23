FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install -y --no-install-recommends python3 \
    python3-dev python3-pip build-essential ca-certificates && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install --break-system-packages --no-cache-dir setuptools wheel \
    && python3 -m pip install --break-system-packages --no-cache-dir --index-url https://download.pytorch.org/whl/cpu
WORKDIR /src
COPY . .
RUN python3 -m pip wheel . --no-deps --no-build-isolation -w /wheels

FROM ubuntu:24.04 AS test
RUN apt-get update && apt-get install -y --no-install-recommends python3 \
    python3-pip ca-certificates \
    # libstdc++6 libgomp1 \
    && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install --break-system-packages --no-cache-dir --index-url https://download.pytorch.org/whl/cpu
COPY --from=build /wheels /wheels
RUN python3 -m pip install --break-system-packages --no-cache-dir /wheels/*.whl \
    && python3 -m pip install --break-system-packages --no-cache-dir pytest
COPY tests /opt/tests
WORKDIR /tmp
CMD ["python3", "-m", "pytest", "-q", "/opt/tests"]