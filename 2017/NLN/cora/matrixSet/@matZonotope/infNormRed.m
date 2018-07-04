function n = infNormRed(matZ)
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
matZred = reduce(matZ,'combastel',1.5);

%split into zonotope and box part
%create zonotope
l = matZred.gens-matZred.dim^2;
newGenerators = matZred.generator(1:l);
matZnew = matZonotope(matZred.center,newGenerators);

%create box
newGenerators = matZred.generator(l+1:end);
matZbox = matZonotope(0*matZred.center,newGenerators);
matI = intervalMatrix(matZbox);

%compute norms separately
nZ = infNorm(matZnew);
nI = infNorm(matI);
n = nZ+nI;


%------------- END OF CODE --------------