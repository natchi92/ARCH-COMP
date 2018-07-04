function [P] = newPolytopeMPT(Z,options)
% newPolytopeMPT - Converts a zonotope from a G- to a H-representation
%
% Syntax:  
%    [P] = newPolytopeMPT(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    P - polytope object
%
% Example: 
%    Z=zonotope(rand(2,5));
%    P=polytope(Z);
%    plot(P);
%    hold on
%    plot(Z);
%
% Other m-files required: vertices, polytope
% Subfunctions: none
% MAT-files required: none
%
% See also: intervalhull,  vertices

% Author:       Matthias Althoff
% Written:      02-February-2011
% Last update:  13-October-2014
% Last revision:---

%------------- BEGIN CODE --------------

%obtain pplPolytope
P = polytope(Z,options);

% %convert to MPT polytope
% P = mptPolytope(pplPolytope.C, pplPolytope.d);


%------------- END OF CODE --------------