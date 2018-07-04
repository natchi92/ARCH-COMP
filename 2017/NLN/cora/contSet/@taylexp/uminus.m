function obj = uminus(obj)
% uminus - Overloaded '-' operator for single operand
%
% Syntax:  
%    res = uplus(obj)
%
% Inputs:
%    obj - a taylexp object
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

%------------- BEGIN CODE --------------

%obj.coefficients = -obj.coefficients;
for j = 1:obj.numberOfCells_j
    for i = 1:obj.numberOfCells_i
        obj.pol_syms{i,j} = -obj.pol_syms{i,j};
    end
end

obj.remainder = -obj.remainder;

%------------- END OF CODE --------------