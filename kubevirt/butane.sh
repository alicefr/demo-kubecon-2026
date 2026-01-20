#!/bin/bash

BUTANE=$1
IGNITION="${BUTANE%.bu}.ign"

podman run --interactive --rm --security-opt label=disable \
	--volume "$(pwd):/pwd" \
	--workdir /pwd \
	quay.io/trusted-execution-clusters/butane:2026-01-20 \
	--pretty --strict /pwd/$BUTANE --output "/pwd/$IGNITION"
echo "$IGNITION"
