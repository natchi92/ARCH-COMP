function res = mrdivide(numerator,denominator)
% mrdivide - Overloaded matrix division '/' operator for intervals
%
% Syntax:  
%    res = mrdivide(numerator, denominator)
%
% Inputs:
%    numerator, denominator - taylexp objects
%
% Outputs:
%    res - a taylexp object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: mtimes

% Author:       Dmitry Grebenyuk
% Written:      21-April-2016
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE ---------------

res = numerator ./ denominator;

%------------- END OF CODE --------------
end

