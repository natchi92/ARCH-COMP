#!/bin/bash 
function run {
	echo $2 ":"
	spaceex -g $1$2.cfg -m $1$3.xml -vl | grep 'Forbidden\|Computing reachable states done after'
}
function graphplot {
	echo $2 ":"
	spaceex -g $1$2.cfg -m $1$3.xml -o $1$2.gen -vl | grep 'Forbidden\|Computing reachable states done after'
	graph -Tpng --bitmap-size 1024x1024 -C -B -q0.5 $1$2.gen > $1$2.png
}

echo "Building"
run Building/SpaceEx/ BLDC01-BDS01 BLDC01
run Building/SpaceEx/ BLDF01-BDS01 BLDF01
run Building/SpaceEx/ BLDF01-BDU01 BLDF01
run Building/SpaceEx/ BLDF01-BDU02 BLDF01
run Building/SpaceEx/ BLDC01-BDU02 BLDC01
# Plot
echo "Producing plot for BLDF01-BDS01 over time horizon of 1"
graphplot Building/SpaceEx/ BLDF01-BDS01-plot BLDF01 
echo "Producing plot for BLDF01-BDS01 over time horizon of 20"
graphplot Building/SpaceEx/ BLDF01-BDS01-plot-20 BLDF01 

echo
echo "Platoon"
run Platoon/SpaceEx/ PLAD01-BND42 PLAD01-BND
run Platoon/SpaceEx/ PLAD01-BND30 PLAD01-BND
run Platoon/SpaceEx/ PLAN01-UNB50 PLAN01-UNB

# Plot
echo "Producing plot for PLAD01-BND30 over time horizon of 20"
graphplot Platoon/SpaceEx/ PLAD01-BND30-plot PLAD01-BND 

echo
echo "Gearbox"
run Gear/SpaceEx/ GRBX01-MES01 GRBX01-MES01

# Plot
echo "Producing plot for GRBX01-MES01 over time horizon of 20"
graphplot Gear/SpaceEx/ GRBX01-MES01-plot GRBX01-MES01


