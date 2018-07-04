function [cellIndices]=cellCandidates(Obj,contSet)
% Purpose:  finds possible cells that might intersect with a continuous set
%           overapproximated by its bounding box (interval hull);
%           more cell indices are returned than actually intersect.
% Pre:      partition object, continuous set object
% Post:     cell indices
% Tested:   14.09.06,MA
% Modified: 16.08.07,MA
% Modified: 29.10.07,MA
% Modified: 17.09.15,MA

%overapproximate continuous set by its interval hull
if strcmp('zonotope',class(contSet))
    IH=interval(contSet);
elseif strcmp('polytope',class(contSet))
    V=vertices(extreme(contSet)');
    IH=interval(V);    
elseif isa(contSet,'mptPolytope')
    IH=interval(contSet);  
else
    IH=contSet;
end

%find indices of interval hull
[cellIndices]=findSegments(Obj,IH);