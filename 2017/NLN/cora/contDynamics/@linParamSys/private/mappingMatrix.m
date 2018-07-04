function [obj] = mappingMatrix(obj,options)
% mappingMatrix - computes the set of matrices which map the states for the
% next point in time.
%
% Syntax:  
%    [obj] = mappingMatrix(obj,intermediateOrder)
%
% Inputs:
%    obj - linParamSys object 
%    intermediateOrder - order until which the original matrix set
%    representation is used
%
% Outputs:
%    obj - resulting linParamSys object 
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
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

if isa(obj.A,'matZonotope') && (obj.A.gens==1) && isempty(options.intermediateOrder)
    [eZ,eI,zPow,iPow,E,RconstInput] = expmOneParam(obj.A,obj.stepSize,obj.taylorTerms,options);
    
    %mapping matrices
    obj.mappingMatrixSet.zono = eZ;
    obj.mappingMatrixSet.int = eI;
    
    %constant input solution
    obj.Rtrans = RconstInput;
else
    %multiply system matrix with stepSize
    A = obj.A * obj.stepSize;
    
    %obtain mapping matrix
    %mixed computation: first terms are matrix zonotopes, further terms are
    %interval matrices
    [eZ,eI,zPow,iPow,E]= expmMixed(A,obj.stepSize,options.intermediateOrder,obj.taylorTerms);

    %save results
    eImid=mid(eI.int);
    %mapping matrices
    obj.mappingMatrixSet.zono = eZ + eImid;
    obj.mappingMatrixSet.int = eI + (-eImid);
end

%powers
obj.power.zono = zPow;
obj.power.int = iPow;

%powers for input computation
for i=1:length(obj.power.zono) 
  obj.power.zono_input{i} = obj.power.zono{i}*(obj.stepSize/factorial(i+1)); 
end 
for i=1:length(obj.power.int)  
  obj.power.int_input{i} = obj.power.int{i}*(obj.stepSize/factorial(i+1)); 
end 

%remainder
obj.E = E;



%------------- END OF CODE --------------