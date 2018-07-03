#!/bin/bash 
function run {
	echo $2 ":"
	spaceex -g $1$2.cfg -m $1$2.xml -vl | grep 'Forbidden\|Computing reachable states done after'
}
run AdaptiveCruiseController/spaceex/ ACCS05-UBD05
run AdaptiveCruiseController/spaceex/ ACCU05-UBD05
run AdaptiveCruiseController/spaceex/ ACCS06-UBD06
run AdaptiveCruiseController/spaceex/ ACCU06-UBD06
run DistributedController/spaceex/ DISC02-UBS02
run DutchRailwayNetwork/spaceex/ DRNW01-BDS01
run DutchRailwayNetwork/spaceex/ DRNW01-BDU01
run Fischer/spaceex/ FISCS04-UBD04
run Fischer/spaceex/ FISCU04-UBD04
run TTEthernet/spaceex/ TTES05-UBD05
run TTEthernet/spaceex/ TTES07-UBD07
