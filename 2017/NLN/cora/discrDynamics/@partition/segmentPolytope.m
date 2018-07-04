function [IHP]=segmentPolytope(Obj,cellNr)
% Purpose:  return polytope of actual segment
% Pre:      partition object
% Post:     polytope object
% Tested:   14.09.06,MA
% Modified: 16.08.07,MA
%           25.07.16,MA

%generate polytope out of cell--------------------------
[intervals]=segmentIntervals(Obj,cellNr);
IH=interval(intervals(:,1), intervals(:,2));
IHP=polytope(IH); %IHP:interval hull polytope
%-------------------------------------------------------- 