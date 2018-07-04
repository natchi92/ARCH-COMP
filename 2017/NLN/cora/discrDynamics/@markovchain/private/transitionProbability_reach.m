function [tp]=transitionProbability(niP,tranFrac,field)
% Purpose:  Calculate the transition probability from the actual cell to
%           the reachable cells
% Pre:      niP (non intersecting polytopes), field
% Post:     transition vector
% Tested:   15.09.06,MA
% Modified: 09.10.06,MA
%           26.03.08,MA
%           29.09.09,MA


%initialize--------------------------------------------------------
nrOfSegments=get(field,'nrOfSegments');
tp(1:(prod(nrOfSegments)+1),1)=0; %tp: transition probability
%------------------------------------------------------------------

%get total volume of niPs (non intersecting polytopes)-------------
[tv,pv]=totalVolume(niP);
%------------------------------------------------------------------

%get cells that might intersect with the reachable set-------------
for k=1:length(niP)
    for i=1:length(niP{k})
        %polytope conversion if niP{k}{i} is a zonotope
        if strcmp('zonotope',class(niP{k}{i}))
            niP{k}{i}=newPolytope(niP{k}{i});
        end
        %intersection
        [tp_total]=cellIntersection2(field,niP{k}{i});
        tp=tp+tranFrac{k}/length(niP{k})*tp_total;
    end
end