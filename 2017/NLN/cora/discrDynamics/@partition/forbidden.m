function [indices]=forbidden(Obj,translation)
% Purpose:  calculates forbidden area for translated cells
% Pre:      partition object, translation
% Post:     indices of forbidden area


signs=sign(translation./Obj.segmentLength);
absolute=ceil(abs(translation./Obj.segmentLength));
subscripts=signs.*absolute;