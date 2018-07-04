#!/bin/sh

# make sure to have the following installed:
# - libeigen3-dev
# - libglpk-dev
# - libgmpxx-dev
# - libboost-dev

# download CaRL if not already present
if [ ! -d "carl" ]; then
	git clone https://github.com/smtrat/carl.git
	# build and install CaRL	
	cd carl && mkdir build && cd build
	cmake ..
	make lib_carl
	cd ../../
fi

# download HyPro if not already present
if [ ! -d "hypro" ]; then
	git clone https://github.com/hypro/hypro.git
	# build and install HyPro
	cd hypro && mkdir build && cd build
	cmake ..
	make resources
	make hypro
	cd ../../
fi

# HyDRA is already provided here, so just build it
cd hydra/build
cmake ..
make hydra-cli -j2
