function [Obj,tp]=build(Obj,finalStateMat,iInput)
% Purpose:  builds the transition matrices of the markov chains
% Pre:      Markov Chain object, final state matrix, input index
% Post:     Markov Chain object
% Tested:   15.09.06,MA
% Modified: 28.09.06,MA
%           16.08.07,MA
%           23.11.07,MA
%           21.04.09,MA
%           16.06.09,MA


%compute transition probabilities
[tp.T]=transitionProbability(finalStateMat.T,Obj.field);
[tp.OT]=transitionProbability(finalStateMat.OT,Obj.field);

%load transition probability from actual segment to reachable segments in
%Transition Matrix T
actualSegmentNr=get(Obj.field,'actualSegmentNr');
Obj.T.T{iInput}(:,actualSegmentNr+1)=sparse(tp.T);
Obj.T.OT{iInput}(:,actualSegmentNr+1)=sparse(tp.OT);

%outside probabilities should stay outside
Obj.T.T{iInput}(1,1)=1;
Obj.T.OT{iInput}(1,1)=1;