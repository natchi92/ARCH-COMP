function [IH]=allSegmentIntervalHulls(obj)
% allSegmentIntervalHulls - Generates all interval hulls of the partitioned
% space
%
% Syntax:  
%   [IH]=allSegmentIntervalHulls(obj)
%
% Inputs:
%    obj - partition object
%
% Outputs:
%    IH - cell array of interval hull objects
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author: Matthias Althoff
% Written: 03-December-2008
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

%obtain number of cells
nrOfCells=prod(obj.nrOfSegments);

%generate an interval hull for each cell
for i=1:nrOfCells
    %get intervals
    intervals=segmentIntervals(obj,i);
    %write result into cell array
    IH{i}=interval(intervals);
end


%------------- END OF CODE --------------