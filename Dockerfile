# Vasp with GNU, openmpi. Use this with podman to avoid file permissions madness
FROM ubuntu:18.04

# Discourage apt from trying to talk to you
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends gosu apt-utils make rsync patch && \
    apt-get install -y --no-install-recommends g++ gfortran\
                       libopenblas-dev \
                       openssh-server \
                       libopenmpi-dev openmpi-common openmpi-bin \
                       libfftw3-dev

### Build Vasp ###
COPY vasp.5.4.4.tar.gz /opt/
WORKDIR /opt
RUN tar -xf vasp.5.4.4.tar.gz
WORKDIR vasp.5.4.4
COPY makefile.include ./

COPY patch.5.4.4.16052018 /opt/vasp.5.4.4/
RUN patch -p0 < patch.5.4.4.16052018
RUN sed -i 's;#include <sys/sem.h>;#include <sys/sem.h>\n#define SHM_NORESERVE 010000;' src/lib/getshmem.c

RUN make all

# Mess around setting up mount points
# DON'T FORGET TO MOUNT THIS WITH :Z IF USING SELINUX
VOLUME ["/rundir"]

#RUN groupadd -r vasp && useradd --no-log-init -r -g vasp vasp
#RUN chown vasp /rundir
#USER vasp

# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]

WORKDIR "/rundir"

CMD ["mpirun", "--allow-run-as-root", "-n", "4", "--mca", "btl_vader_single_copy_mechanism", "none", "/opt/vasp.5.4.4/bin/vasp_std"]