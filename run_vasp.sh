#! /bin/bash
docker run -it --rm -e LOCAL_USER_ID=`id -u $USER` -v $PWD:/rundir vasp
