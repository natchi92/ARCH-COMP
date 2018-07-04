HyDRA Dependencies: 
 - libeigen3-dev
 - libglpk-dev
 - libgmpxx-dev
 - libboost-dev

After having installed the required dependencies, execute

	install.sh

which will download CaRL and HyPro from GitHub and install both before installing HyDRA.

After installing, in the folder hydra/build there should be an executable hydra-cli.
We provide an automated script which executes all benchmarks and organises the output

	benchmark.sh

For manual execution use:

	./hydra-cli -t <numThreads> -r support_function -m <modelFile>

Note: The usage of more than one thread can be tried, although this is a very recent change, so no guarantees given.


In case anything crashes, or does not work properly, please contact 
	stefan.schupp@cs.rwth-aachen.de
