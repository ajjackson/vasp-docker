# VASP in Docker

Some hacking to use Vasp in Docker containers. Local builds of DFT
codes are useful, but modern operating systems/compilers may not play
well with old code.

This repo only contains Docker stuff; to use it:

- copy vasp.5.4.4.tar.gz and patch.5.4.4.16052018 into this directory
- delete previous/failed docker image builds with `docker rmi vasp`
- build with `docker build -t vasp .` when running, mount the
  calculation directory to /rundir using something like `docker run
  --rm -v $PWD:/rundir:Z vasp`.

(The `:Z` is necessary on systems with SELinux or write-permission
errors will arise. This can be frustrating to troubleshoot, as there
are plenty of other ways to get write-permission errors when doing
this sort of thing.)

This is absolutely unofficial and has nothing to do with the VASP
developers. Use at your own risk.