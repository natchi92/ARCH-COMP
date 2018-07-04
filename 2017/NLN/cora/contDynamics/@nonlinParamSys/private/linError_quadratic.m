function [error,errorInt] = linError_quadratic(obj,options,R)
% linError - computes the linearization error
%
% Syntax:  
%    [obj] = linError(obj,options)
%
% Inputs:
%    obj - nonlinear system object
%    options - options struct
%    R - actual reachable set
%
% Outputs:
%    obj - nonlinear system object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      29-October-2007 
% Last update:  22-January-2008
%               02-February-2010
%               25-July-2016 (intervalhull replaced by interval)
% Last revision: ---

%------------- BEGIN CODE --------------

%compute interval of reachable set
IH=interval(R);
totalInt=interval(IH) + obj.linError.p.x;

%compute intervals of input
IHinput=interval(options.U);
inputInt=interval(IHinput) + options.uTrans;

%obtain hessian tensor
H = hessianTensor(totalInt,inputInt,options.paramInt);

% %diagonalize
% for i=1:length(H)
%     %get center
%     Hcenter = mid(H{i});
%     %get eigenvectors and eigenvalues
%     [V,W] = eig(Hcenter);
%     Hnew = V'*Hcenter*V;
%     
%     Z=cartesianProduct(R,options.U);
%     Ztrans = V'*Z;
%     
%     %compute zonotope of state and input
%     I=interval(interval(Ztrans));
%     error(i,1)=I'*Hnew*I + I'*(H{i}-Hnew)*I;
% end



%compute zonotope of state and input
Rred = reduce(R,'girard',options.errorOrder);
Z=cartesianProduct(Rred,options.U);

% %split mu as a test
% Zmat = get(Z,'Z');
% [Z1,Z2] = splitOneDim(Zmat(:,1),Zmat(:,2:end),12);

%compute input due to second order evaluation
error=0.5*quadraticMultiplication_interval(Z,H);
% error1=0.5*quadraticMultiplication_interval(Z1,H);
% error2=0.5*quadraticMultiplication_interval(Z2,H);

%[min,max] = quadraticProgramming_interval(Z,H);

error = reduce(error,'girard',options.zonotopeOrder);

errorIHabs = abs(interval(error));
errorInt = supremum(errorIHabs);

% H2 = hessianTensor(mid(totalInt),mid(inputInt));
% error2=0.5*quadraticMultiplication(Z,H2);

function [Z1,Z2]=splitOneDim(c,G,dim)

%compute centers of splitted parallelpiped
c1=c-G(:,dim)/2;
c2=c+G(:,dim)/2;

%compute new set of generators
Gnew=G;
Gnew(:,dim)=Gnew(:,dim)/2;

%generate splitted parallelpipeds
Z1=zonotope([c1,Gnew]);
Z2=zonotope([c2,Gnew]);   

%------------- END OF CODE --------------