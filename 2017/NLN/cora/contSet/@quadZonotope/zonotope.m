function Z = zonotope(qZ)
% zonotope - computes an enclosing zonotope of the quadratic zonotope
%
% Syntax:  
%    Z = zonotope(qZ)
%
% Inputs:
%    qZ - quadZonotope object
%
% Outputs:
%    Z - zonotope object
%
% Example: 
%    ---
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      05-September-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

if isempty(qZ.G) && isempty(qZ.Grest)
    %center
    c = qZ.c;
    %generators
    G = [];
else
    %center
    c = qZ.c + 0.5*sum(qZ.Gsquare,2);
    %generators
    G = [qZ.G, 0.5*qZ.Gsquare, qZ.Gquad, qZ.Grest];
end

%generate zonotope
Z = zonotope([c,G]);

%------------- END OF CODE --------------