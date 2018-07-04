function [Obj]=nextSegment(Obj)
% Purpose:  Increment SegmentNr by 1
% Pre:      partition object
% Post:     partition object
% Tested:   14.09.06,MA

% Raise segment number
Obj.actualSegmentNr=Obj.actualSegmentNr+1;
Obj.mode=findMode(Obj);