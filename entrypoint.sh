#! /bin/sh

set -x

# Based on https://github.com/AlgoLab/HapCHAT/blob/master/docker/gosu.sh
ls /rundir

# Create a user matching owner of /workdir
USER_ID=$(stat -c %u /rundir)
GROUP_ID=$(stat -c %g /rundir)

echo "Creating user with UID:GID $USER_ID:$GROUP_ID"
groupadd -g "$GROUP_ID" group
useradd --shell /bin/bash -u "$USER_ID" -g group -o -c "" -m user
export HOME=/
export OMP_NUM_THREADS=1

chown --recursive "${TARGET_USERNAME}":"${TARGET_USERNAME}" /rundir

# Finally launch using gosu
CMD=${@:-bash}
exec gosu user $CMD
