function P = polytope(obj,varargin)
% polytope - Converts an interval object to a polytope object
%
% Syntax:  
%    P = polytope(ob,options)
%
% Inputs:
%    obj - interval hull object
%    options - options struct 
%
% Outputs:
%    P - polytope object
%
% Example: 
%    I = interval([1; -1], [2; 1]);
%    P = polytope(I);
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: zonotope, interval

% Author:       Matthias Althoff
% Written:      22-July-2016 
% Last update:  30-July-2016
% Last revision:---

%------------- BEGIN CODE --------------

%obtain zonotope
Z = zonotope(obj);

%instantiate polytope
if isempty(varargin)
    opt.polytopeType = '';
end
P=polytope(Z, opt);

%------------- END OF CODE --------------