function res = mpower(base,exponent)
% mpower - Overloaded '^' operator for taylexp (power)
%
% Syntax:  
%    res = mpower(base,exponent)
%
% Inputs:
%    base - taylexp object
%    exponent - taylexp object
%
% Outputs:
%    res - taylexp
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: mtimes

% Author:       Dmitry Grebenyuk
% Written:      06-May-2016
% Last update:  ---               
% Last revision:---

%------------- BEGIN CODE --------------
res = base;

for i = 1:(exponent-1)
    res = res .* base;
end

end

