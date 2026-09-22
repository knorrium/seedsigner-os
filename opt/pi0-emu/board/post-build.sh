#!/bin/sh

set -eu

# Remove services that are not part of this offline appliance.
rm -f "${TARGET_DIR}"/etc/init.d/S01syslogd
rm -f "${TARGET_DIR}"/etc/init.d/S02klogd
rm -f "${TARGET_DIR}"/etc/init.d/S02sysctl
rm -f "${TARGET_DIR}"/etc/init.d/S02mdev
rm -f "${TARGET_DIR}"/etc/init.d/S20seedrng
rm -f "${TARGET_DIR}"/etc/init.d/S40network
rm -f "${TARGET_DIR}"/etc/init.d/S50pigpio

# The emulation image must never contain signing software or wallet libraries.
if [ -e "${TARGET_DIR}/opt/src/seedsigner" ]; then
	echo "ERROR: SeedSigner application leaked into emulation image" >&2
	exit 1
fi
