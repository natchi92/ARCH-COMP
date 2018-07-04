function [mode]=findMode(Obj)
% Purpose:  Find mode of actual cell (only simple HSCC-case)
% Pre:      partition object
% Post:     mode number
% Tested:   28.09.06,MA


%get cell zonotope
[intervals]=segmentIntervals(Obj);

%if intervals(1,2)<=0
    mode=1;
%else
%    mode=2;
%end