#!/bin/bash
#********************************************************************************
# Copyright (c) 2022 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Apache License 2.0 which is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0
#*******************************************************************************/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup
python3 -m venv .venv
source .venv/bin/activate
pip install -r "${SCRIPT_DIR}"/requirements.txt


DATABROKER_IMAGE=${DATABROKER_IMAGE:-"kuksadatabroker"}
DATABROKER_ADDRESS=${DATABROKER_ADDRESS:-"127.0.0.1:55556"}
CONTAINER_PLATFORM=${CONTAINER_PLATFORM:-"linux/amd64"}

VSS_DATA_DIR="$SCRIPT_DIR/../data"

echo "Starting databroker container (\"${DATABROKER_IMAGE}\") in insecure mode, requesting platform (\"${CONTAINER_PLATFORM}\")"
RUNNING_IMAGE=$(
    docker run -d -v ${VSS_DATA_DIR}:/data -p 55556:55556 --rm  --platform ${CONTAINER_PLATFORM} ${DATABROKER_IMAGE} --metadata data/vss-core/vss_release_4.0.json --insecure --enable-databroker-v1
)

python3 -m pytest -v "${SCRIPT_DIR}/test_databroker.py"

RESULT=$?

echo "Stopping databroker container"

docker stop ${RUNNING_IMAGE}

exit $RESULT
