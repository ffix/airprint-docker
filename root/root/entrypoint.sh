#!/bin/sh
set -e
set -x

ln -sf /services/ /etc/avahi/services/
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start

exec "$@"
