#!/usr/bin/env bash

set -u

if [ -z "$VALON_INSTANCE" ]; then
    echo "VALON_INSTANCE environment variable is not set." >&2
    exit 1
fi

export VALON_CURRENT_PV_AREA_PREFIX=VALON_${VALON_INSTANCE}_PV_AREA_PREFIX
export VALON_CURRENT_PV_DEVICE_PREFIX=VALON_${VALON_INSTANCE}_PV_DEVICE_PREFIX
export VALON_CURRENT_SERIAL_PORT=VALON_${VALON_INSTANCE}_SERIAL_PORT
export VALON_CURRENT_TELNET_PORT=VALON_${VALON_INSTANCE}_TELNET_PORT
# Only works with bash
export VALON_PV_AREA_PREFIX=${!VALON_CURRENT_PV_AREA_PREFIX}
export VALON_PV_DEVICE_PREFIX=${!VALON_CURRENT_PV_DEVICE_PREFIX}
export VALON_SERIAL_PORT=${!VALON_CURRENT_SERIAL_PORT}
export VALON_TELNET_PORT=${!VALON_CURRENT_TELNET_PORT}

# Create volume for autosave and ignore errors
/usr/bin/docker create \
    -v /opt/epics/startup/ioc/valon5009-epics-ioc/iocBoot/iocValon5009/autosave \
    --name valon5009-epics-ioc-${VALON_INSTANCE}-volume \
    lnlsdig/valon5009-epics-ioc:${IMAGE_VERSION} \
    2>/dev/null || true

# Remove a possible old and stopped container with
# the same name
/usr/bin/docker rm \
    valon5009-epics-ioc-${VALON_INSTANCE} || true

/usr/bin/docker run \
    --net host \
    -t \
    --rm \
    --volumes-from valon5009-epics-ioc-${VALON_INSTANCE}-volume \
    --name valon5009-epics-ioc-${VALON_INSTANCE} \
    lnlsdig/valon5009-epics-ioc:${IMAGE_VERSION} \
    -t "${VALON_TELNET_PORT}" \
    -p "${VALON_SERIAL_PORT}" \
    -P "${VALON_PV_AREA_PREFIX}" \
    -R "${VALON_PV_DEVICE_PREFIX}"
