classdef partition < handle
% partition class 
%
% Syntax:  
%    object constructor: Obj = linearSys(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    intervals - state space intervals
%    nrOfSegments - number of segments for each dimension
%    actualSegmentNr - current vector of segment numbers
%    mode - cells can be associated to different modes
%
%
% Outputs:
%    Obj - Generated Object
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Matthias Althoff
% Written:      14-September-2006 
% Last update:  07-August-2016 (changed to new OO format)
% Last revision:---

%------------- BEGIN CODE --------------

properties (SetAccess = private, GetAccess = public)
    intervals = [];
    nrOfSegments = [];
    actualSegmentNr = 0;    
    mode = [];  
    segmentLength = []; 
end

methods
    %class constructor
    function obj = partition(varargin)
        %2 inputs
        if nargin==2
            obj.intervals = varargin{1};
            obj.nrOfSegments = varargin{2};
            obj.segmentLength = (obj.intervals(:,2)-obj.intervals(:,1))./obj.nrOfSegments; 
        end
    end
end
end

%------------- END OF CODE --------------