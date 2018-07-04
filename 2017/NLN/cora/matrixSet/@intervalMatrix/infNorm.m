function n = infNorm(intMat)
% infNorm - returns the maximum of the infinity norm of an interval matrix
%
% Syntax:  
%    n = infNorm(intMat)
%
% Inputs:
%    intMat - interval matrix
%
% Outputs:
%    n - infinity norm of the interval matrix
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author:       Matthias Althoff
% Written:      12-February-2007 
% Last update:  18-June-2010
% Last revision:---

%------------- BEGIN CODE --------------

Minf=infimum(intMat.int);
Msup=supremum(intMat.int);

M=max(abs(Minf), abs(Msup));

n=norm(M,inf);

%------------- END OF CODE --------------