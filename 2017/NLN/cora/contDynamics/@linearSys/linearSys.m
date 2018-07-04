classdef linearSys < contDynamics
% linearSys class (linSys: linear system)
%
% Syntax:  
%    object constructor: Obj = linearSys(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    name - name of system
%    A - state matrix
%    B - input matrix
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
% Written:      23-January-2007 
% Last update:  30-April-2007
%               04-August-2016 (changed to new OO format)
% Last revision:---

%------------- BEGIN CODE --------------

properties (SetAccess = private, GetAccess = public)
    A = [];
    B = [];
    taylor = [];
end

methods
    %class constructor
    function obj = linearSys(varargin)
        obj@contDynamics(varargin{1},ones(length(varargin{2}),1),1,1); %instantiate parent class
        %3 inputs
        if nargin==3
            obj.A = varargin{2};
            obj.B = varargin{3};
        end
    end
end
end

%------------- END OF CODE --------------