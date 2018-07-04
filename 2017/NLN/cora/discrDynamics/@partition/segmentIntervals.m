function [intervals]=segmentIntervals(varargin)
% Purpose:  return intervals of actual segment
% Pre:      partition object
% Post:     segmnent intervals
% Tested:   14.09.06,MA
% Modified: 15.09.06,MA

%cases for one or two input arguments------------------
if nargin==1
    Obj=varargin{1};
    cellNr=Obj.actualSegmentNr;
elseif nargin==2
    Obj=varargin{1};
    cellNr=varargin{2};
else
    disp('segmentIntervals: wrong number of inputs');
end
%-------------------------------------------------------

% Get subscripts out of the segment number 
subscripts=i2s(Obj,cellNr);

% Determine segment intervals from segment subscripts and segment lengths
intervals(:,1)=...
    Obj.intervals(:,1)+(subscripts'-1).*Obj.segmentLength;
intervals(:,2)=...
    Obj.intervals(:,1)+subscripts'.*Obj.segmentLength;
