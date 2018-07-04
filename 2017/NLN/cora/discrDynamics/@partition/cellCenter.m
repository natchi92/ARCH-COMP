function [c]=cellCenter(Obj,cellNr)
% Purpose:  return center of actual cell
% Pre:      partition object
% Post:     center point
% Tested:   29.09.06,MA
% Modified: 27.06.08,MA


%Get intervals from segment object------------------------------------
intervals=segmentIntervals(Obj,cellNr);
%---------------------------------------------------------------------

%Generate interval of cell----------------------------------------
IH=interval(intervals);
c=center(IH);
%---------------------------------------------------------------------