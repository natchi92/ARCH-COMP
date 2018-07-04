function res = power(base,exponent)
% power - Overloaded '.^' operator for taylexp (power)
%
% Syntax:  
%    res = power(base,exponent)
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
% Written:      22-July-2016
% Last update:  ---               
% Last revision:---

%------------- BEGIN CODE --------------

res = mpower(base,exponent);

end

