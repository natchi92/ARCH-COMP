function [IHZ]=segmentZonotope(Obj,cellNr)
% Purpose:  return polytope of actual segment
% Pre:      partition object
% Post:     polytope object
% Built:    29.09.06,MA
% Modified: 17.08.07,MA
%           25.07.16,MA

%generate polytope out of cell--------------------------
[intervals]=segmentIntervals(Obj,cellNr);
IH=interval(intervals(:,1), intervals(:,2));
IHZ=zonotope(IH); %IHZ:interval hull zonotope
%-------------------------------------------------------- 
