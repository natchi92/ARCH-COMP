function [Obj,tp]=build_reach(Obj,HA,iInput,tranFrac)
% Purpose:  builds the transition matrices of the markov chains
% Pre:      Markov Chain object, reachset object R
% Post:     Markov Chain object
% Tested:   15.09.06,MA
% Modified: 28.09.06,MA
%           16.08.07,MA
%           23.11.07,MA
%           21.04.09,MA

%get results saved in the hybrid automaton
R=get(HA,'reachableSet');

%get probabilities from actual segment to all segments
[tp.T]=transitionProbability_reach(R.T,tranFrac.TP,Obj.field);
[tp.OT]=transitionProbability_reach(R.OT,tranFrac.TI,Obj.field);

%load transition probability from actual segment to reachable segments in
%Transition Matrix T
actualSegmentNr=get(Obj.field,'actualSegmentNr');
Obj.T.T{iInput}(:,actualSegmentNr+1)=sparse(tp.T);
Obj.T.OT{iInput}(:,actualSegmentNr+1)=sparse(tp.OT);

%outside probabilities should stay outside
Obj.T.T{iInput}(1,1)=1;
Obj.T.OT{iInput}(1,1)=1;