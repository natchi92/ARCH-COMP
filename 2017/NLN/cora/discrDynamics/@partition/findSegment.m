function [segmentIndex]=findSegment(Obj,coordinates)
% Purpose:  Find segment index for given coordinates
% Pre:      partition object, coordinates
% Post:     segmnent index


%get segment subscripts from coordinates
positionCoordinates=ceil((coordinates-Obj.intervals(:,1)')./Obj.segmentLength');

%outside is true, if subscripts lie outside of the quantized state space
outside=(positionCoordinates<1) | (positionCoordinates>Obj.nrOfSegments');
if ~any(outside)
    segmentIndex=s2i(Obj,positionCoordinates); %segment subscripts are transformed into the segment index
else
    segmentIndex=0; %the outside segment is numbered 0
end