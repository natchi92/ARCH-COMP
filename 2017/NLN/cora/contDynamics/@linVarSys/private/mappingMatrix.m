function [obj] = mappingMatrix(obj,intermediateOrder)
% mappingMatrix - computes the set of matrices which map the states for the
% next point in time.
%
% Syntax:  
%    [obj] = mappingMatrix(obj,intermediateOrder)
%
% Inputs:
%    obj - linVarSys object 
%    intermediateOrder - order until which the original matrix set
%    representation is used
%
% Outputs:
%    obj - resulting linVarSys object 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: plus

% Author:       Matthias Althoff
% Written:      05-August-2010
% Last update:  04-April-2017
% Last revision:---

%------------- BEGIN CODE --------------

%multiply system matrix with stepSize
A = obj.A * obj.stepSize;

%obtain mapping matrix
%mixed computation: first terms are matrix zonotopes, further terms are
%interval matrices
if (A.gens == 1) && intermediateOrder == -1
    [eZ,eI,zPow,iPow,E] = expmOneParam(obj.A,obj.stepSize,obj.taylorTerms);
else
    [eZ,eI,zPow,iPow,E]= expmIndMixed(A,intermediateOrder,obj.taylorTerms);
end

%save results
%mapping matrices
obj.mappingMatrixSet.zono = eZ;
obj.mappingMatrixSet.int = eI;

%powers
obj.power.zono = zPow;
obj.power.int = iPow;

%remainder
obj.E = E;



%------------- END OF CODE --------------