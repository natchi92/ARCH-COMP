function [error, errorInt] = linError_thirdOrder(obj, options, R)
% linError - computes the linearization error
%
% Syntax:  
%    [obj] = linError(obj,options)
%
% Inputs:
%    obj - nonlinear DAE system object
%    options - options struct
%    R - actual reachable set
%
% Outputs:
%    error - zonotope overapproximating the linearization error
%    errorInt - interval overapproximating the linearization error
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      21-August-2012
% Last update:  25-July-2016 (intervalhull replaced by interval)
% Last revision:---

%------------- BEGIN CODE --------------

%obtain intervals and combined interval z
dx = interval(R);
du = interval(options.U);
dz = [dx; du];

%compute intervalhull of reachable set
totalInt_x = dx + obj.linError.p.x;

%compute intervals of input
totalInt_u = du + obj.linError.p.u;

%compute zonotope of state and input
Rred = reduce(R,'girard',options.errorOrder);
Z=cartesianProduct(Rred,options.U);

%obtain absolute values
dz_abs = max(abs(infimum(dz)), abs(supremum(dz)));

%obtain hessian tensor and third order tensor
H = hessianTensor(obj.linError.p.x, obj.linError.p.u);
T = thirdOrderTensor(totalInt_x, totalInt_u);

%second order error
error_secondOrder = 0.5*quadraticMultiplication(Z, H);

%interval evaluation
for i=1:length(T(:,1))
    error_sum = interval(0,0);
    for j=1:length(T(1,:))
        error_tmp(i,j) = dz'*T{i,j}*dz;
        error_sum = error_sum + error_tmp(i,j) * dz(j);
    end
    error_thirdOrder_old(i,1) = 1/6*error_sum;
end

error_thirdOrder_old_zono = zonotope(error_thirdOrder_old);

%alternative
%separate evaluation
for i=1:length(T(:,1))
    for j=1:length(T(1,:))
        T_mid{i,j} = sparse(mid(T{i,j}));
        T_rad{i,j} = sparse(rad(T{i,j}));
    end
end

error_mid = 1/6*cubicMultiplication_simple(Z, T_mid);

%interval evaluation
for i=1:length(T(:,1))
    error_sum2 = 0;
    for j=1:length(T(1,:))
        error_tmp2(i,j) = dz_abs'*T_rad{i,j}*dz_abs;
        error_sum2 = error_sum2 + error_tmp2(i,j) * dz_abs(j);
    end
    error_rad(i,1) = 1/6*error_sum2;
end


%combine results
error_rad_zono = zonotope(interval(-error_rad, error_rad));
error_thirdOrder = error_mid + error_rad_zono;

error_thirdOrder = reduce(error_thirdOrder,'girard',options.zonotopeOrder);


%combine results
error = error_secondOrder + error_thirdOrder;

error = reduce(error,'girard',options.zonotopeOrder);

errorIHabs = abs(interval(error));
errorInt = supremum(errorIHabs);

%------------- END OF CODE --------------