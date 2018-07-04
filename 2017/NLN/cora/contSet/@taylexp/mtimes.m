function res = mtimes(factor1, factor2)
% mtimes - Overloaded '*' operator for a taylor expression
%
% Syntax:  
%    res = mtimes(factor1, factor2)
%
% Inputs:
%    factor1 and factor2 - a taylor expression objects
%    order  - the cut-off order of the Taylor series. The constat term is
%    the zero order.
%
% Outputs:
%    res - a taylor expression object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: mtimes

% Author:       Dmitry Grebenyuk
% Written:      18-April-2016
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------
res = factor1 .* factor2;

%------------- END OF CODE --------------
