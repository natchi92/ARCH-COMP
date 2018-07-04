function [result] = nrOfStates(obj)
% nrOfStates - returns the number of discrete states of the partition
%
% Syntax:  
%    [result] = nrOfStates(obj)
%
% Inputs:
%    obj - partition object
%
% Outputs:
%    result - number of discrete states
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author: Matthias Althoff
% Written: 17-October-2007 
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

result=prod(obj.nrOfSegments);

%------------- END OF CODE --------------