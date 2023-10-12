#!/usr/bin/env bash

set -e

DEBIAN_FRONTEND=noninteractive apt-get install -y pdsh libaio-dev
# Triton is needed to build deepspeed's sparse_attn operation.
# python -m pip install triton==1.0.0
# python -m pip install pydantic==1.10.11
# We explicitly build only the async-I/O, fused Adam, and utils extensions in DeepSpeed.
# This avoids depending on `triton` here which interacts badly with PyTorch's dependency on same.
# You can see all the ops here: https://github.com/augmentcode/DeeperSpeed/tree/augment/op_builder
# along with some docs: https://www.deepspeed.ai/tutorials/advanced-install/#pre-install-deepspeed-ops.
# Protobuf to make sure it doesn't get upgraded
DS_BUILD_AIO=1 DS_BUILD_FUSED_ADAM=1 DS_BUILD_UTILS=1 python -m pip install "protobuf==3.20.1" $DEEPSPEED_PIP --no-binary deepspeed
python -m deepspeed.env_report
