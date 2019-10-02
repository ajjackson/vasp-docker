# VASP in Docker

Some hacking to use Vasp in Docker containers. Local builds of DFT
codes are useful, but modern operating systems/compilers may not play
well with old code.

This repo only contains Docker stuff and no Vasp code. To use it:

- Copy vasp.5.4.4.tar.gz and patch.5.4.4.16052018 into this directory
- Delete previous image builds with `docker rmi vasp`
- Edit mpi command in Dockerfile to suit available core count. (Should
  probably tweak this setup to work with an environment variable...)
- Build with `docker build -t vasp .`
- Run with the *run_vasp.sh* script. This mounts $PWD to the /rundir
  directory on the virtual machine, where the calculation will be
  performed.

At the end of the run, the container will be deleted but the image is
retained, so you don't need to `docker build` again unless you changed something.

This is absolutely unofficial and has nothing to do with the VASP
developers. Use at your own risk.