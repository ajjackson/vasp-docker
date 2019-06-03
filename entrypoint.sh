#! /bin/sh

set -x

TARGET_USERNAME="vasp"

PUID=${PUID:-911}
PGID=${PGID:-911}

# Set target user's IDs to match that of the "external"/"host" user
groupmod --non-unique --gid ${PGID} ${TARGET_USERNAME}
usermod --non-unique --uid ${PUID} ${TARGET_USERNAME}

chown ${TARGET_USERNAME}:${TARGET_USERNAME} /rundir

CMD=${@:-bash}
runuser --user ${TARGET_USERNAME} -- ${CMD}
