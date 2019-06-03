# Vasp with GNU, openmpi.
# Loosely based on https://github.com/oweidner/docker.openmpi/blob/master/Dockerfile
FROM ubuntu:18.04

# Define user stuff before creating them
ENV USER vasp
ENV HOME /home/${USER}

# Discourage apt from trying to talk to you
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends sudo apt-utils make rsync && \
    apt-get install -y --no-install-recommends g++ gfortran\
                       libopenblas-dev \
                       openssh-server \
                       libopenmpi-dev openmpi-common openmpi-bin \
                       libfftw3-dev


# Build Vasp as users
RUN addgroup --gid 911 vasp
RUN adduser --uid=911 --ingroup=vasp --disabled-password ${USER} && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY vasp.5.4.4.tar.gz /home/${USER}/
RUN chown vasp:vasp /home/${USER}/vasp.5.4.4.tar.gz

USER ${USER}
ENV OMP_NUM_THREADS 1
WORKDIR ${HOME}
RUN tar -xf vasp.5.4.4.tar.gz
WORKDIR vasp.5.4.4
COPY makefile.include ./
RUN make all

# Mess around setting up mount points
USER root
VOLUME ["/rundir"]
WORKDIR /rundir

RUN /bin/bash -c 'chown vasp:vasp /rundir'
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD /bin/bash