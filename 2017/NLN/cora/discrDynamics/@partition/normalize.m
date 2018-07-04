function [normalizedVector]=normalize(Obj,vector)
% Purpose:  normalize vector to state space field
% Pre:      partition object, vector
% Post:     normalized vector
% Built:    01.11.06,MA

%get intervls
[intervals]=segmentIntervals(Obj);
length=intervals(:,2)-intervals(:,1);

%normalize
normalizedVector=vector./length;