function n = infNorm(matZ)
% infNorm - returns the maximum of the infinity norm of a matrix zonotope
%
% Syntax:  
%    n = infNorm(matZ)
%
% Inputs:
%    matZ - matrix zonotope
%
% Outputs:
%    n - infinity norm of the matrix zonotope
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author:       Matthias Althoff
% Written:      20-July-2010
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%compute the norm of the center and generator matrices separately
nPartial(1) = norm(matZ.center,inf);

for i=1:matZ.gens
    nPartial(i+1) = norm(matZ.generator{i},inf);
end

%sum partial norms
n = sum(nPartial);

%------------- END OF CODE --------------