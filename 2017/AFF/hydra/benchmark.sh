#!/bin/sh

echo Starting benchmarks.

echo AFF-benchmark: Building1sec
hydra/build/hydra-cli -t 1 -r support_function -m benchmarks/BLDF01_BDS01_1sec.model
mv *.plt output/
mv *.log logs/

echo AFF-benchmark: BuildingFull
hydra/build/hydra-cli -t 1 -r support_function -m benchmarks/BLDF01_BDS01.model
mv *.plt output/
mv *.log logs/

echo HBMC-benchmark: FisherStar
hydra/build/hydra-cli -t 1 -r support_function -m benchmarks/fisher_star_3u.model
mv *.plt output/
mv *.log logs/

echo HBMC-benchmark: NAV
hydra/build/hydra-cli -t 1 -r support_function -m benchmarks/nav.model
mv *.plt output/
mv *.log logs/

echo HBMC-benchmark: Motorcar
hydra/build/hydra-cli -t 1 -r support_function -m benchmarks/motorcar_5.model
mv *.plt output/
mv *.log logs/

echo Finished benchmarks.