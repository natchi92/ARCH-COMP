function [c]=centerSegment(field)
% Purpose:  find center for particulate solution
% Pre:      partition object
% Post:     center
% Modified: 13.11.07, 25.11.2016 (MA)

%interval hull and middle of discretized state space----
intervals=get(field,'intervals');
stateSpace_IH=interval(intervals(:,1), intervals(:,2));
middle=center(stateSpace_IH);
%-------------------------------------------------------

%find center of cell that contains state space middle---
index = findSegments(field,[middle,middle]);
sI = segmentIntervals(field,index);
IH = interval(sI(:,1), sI(:,2));
c.val=center(IH);
c.ind=index;
%-------------------------------------------------------