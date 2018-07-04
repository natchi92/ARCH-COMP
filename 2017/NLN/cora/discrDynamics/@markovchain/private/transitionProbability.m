function [tp]=transitionProbability(finalStateMat,field)
% Purpose:  Calculate the transition probability from the actual cell to
%           the reachable cells
% Pre:      finalStateMat, field
% Post:     transition vector
% Tested:   15.09.06,MA
% Modified: 09.10.06,MA
%           26.03.08,MA
%           16.06.09,MA


%initialize--------------------------------------------------------
nrOfSegments=get(field,'nrOfSegments');
tp(1:(prod(nrOfSegments)+1),1)=0; %tp: transition probability
%------------------------------------------------------------------

%get total number of final states----------------------------------
nrOfFinalStates=length(finalStateMat(:,1));
%------------------------------------------------------------------

%get cell indices of final states----------------------------------
for iPoint=1:nrOfFinalStates
    finalCell(iPoint)=findSegment(field,finalStateMat(iPoint,:));
end
%------------------------------------------------------------------

%calculate probabilities for each cell by: number of trajectories entering
%the goal state devided by the number of all trajectories
while ~isempty(finalCell)
    indices=find(finalCell == finalCell(1));
    tp(finalCell(1)+1,1)=length(indices)/nrOfFinalStates;
    finalCell(indices)=[];
end
%------------------------------------------------------------------