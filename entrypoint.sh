#! /bin/sh

set -x

# Based on https://github.com/AlgoLab/HapCHAT/blob/master/docker/gosu.sh
# With tweaks from https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
ls /rundir

# Create a user matching owner of /workdir
USER_ID=${LOCAL_USER_ID:-9001}

echo "Creating user with UID $USER_ID"

useradd --shell /bin/bash -u "$USER_ID" -o -c "" -m user
export HOME=/home/user
export OMP_NUM_THREADS=1

# Fix permissions for /rundir (location of volume mount for calc directory)
chown --recursive "${USER_ID}":"${USER_ID}" /rundir

# Finally launch using gosu
CMD=${@:-bash}
exec gosu "$USER_ID" $CMD
