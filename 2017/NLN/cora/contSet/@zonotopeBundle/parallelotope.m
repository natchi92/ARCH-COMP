function [P] = parallelotope(varargin)
% parallelotope - dummy; calls polytope()
%
% Syntax:  
%    [P] = parallelotope(Zbundle)
%
% Inputs:
%    Zbundle - zonotope bundle
%
% Outputs:
%    P - polytope object
%
% Example: 
%    ---
%
% Other m-files required: vertices, polytope
% Subfunctions: none
% MAT-files required: none
%
% See also: intervalhull,  vertices

% Author:       Matthias Althoff
% Written:      03-February-2011
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%dummy; forwarded to polytope function
[P] = polytope(varargin{:});

%------------- END OF CODE --------------