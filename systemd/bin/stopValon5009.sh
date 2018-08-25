#!/usr/bin/env bash

set -u

if [ -z "$VALON_INSTANCE" ]; then
    echo "VALON_INSTANCE environment variable is not set." >&2
    exit 1
fi

/usr/bin/docker stop \
    valon5009-epics-ioc-${VALON_INSTANCE}
