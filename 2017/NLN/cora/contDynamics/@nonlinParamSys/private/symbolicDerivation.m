function [obj] = symbolicDerivation(obj,options)
% symbolicDerivation - computes the derivatives of the nonlinear system 
% in a symbolic way; the result is also stored in a m-file and passed by 
% a handle
%
% Syntax:  
%    [obj] = symbolicDerivation(obj)
%
% Inputs:
%    obj - nonlinear parameter system object
%
% Outputs:
%    obj - nonlinear parameter system object
%
% Example: 
%    Text for example...
%
% Other m-files required: ---
% Subfunctions: ---
% MAT-files required: ---
%
% See also: 

% Author:       Matthias Althoff
% Written:      25-May-2011
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%create symbolic variables
[x,u,dx,du,p]=symVariables(obj,'LRbrackets');

%insert symbolic variables into the system equations
t=0;
fLR=obj.mFile(t,x,u,p);

%compute jacobian with respect to the state
Jx=jacobian(fLR,x);
obj.derivative.firstOrder.x=Jx;

%compute jacobian with respect to the input
Ju=jacobian(fLR,u);
obj.derivative.firstOrder.u=Ju;

%store jacobians with respect to parameters (assumption: expressions are linear in parameters)
%init
Jpx=cell(1,obj.nrOfParam+1);
Jpu=cell(1,obj.nrOfParam+1);
%part without parameters
Jpx{1} = subs(Jx,p,zeros(obj.nrOfParam,1));
Jpu{1} = subs(Ju,p,zeros(obj.nrOfParam,1));
%part with parameters
I = eye(obj.nrOfParam); %identity matrix
for i=1:obj.nrOfParam
    Jpx{i+1} = subs(Jx,p,I(i,:)) - Jpx{1};
    Jpu{i+1} = subs(Ju,p,I(i,:)) - Jpu{1};
end

%normalize
pCenter = mid(options.paramInt);
pDelta = rad(options.paramInt);

for i=1:obj.nrOfParam
    %center
    Jpx{1} = Jpx{1} + pCenter(i)*Jpx{i+1};
    Jpu{1} = Jpu{1} + pCenter(i)*Jpu{i+1};
    %generators
    Jpx{i+1} = pDelta*Jpx{i+1};
    Jpu{i+1} = pDelta*Jpu{i+1};
end

obj.derivative.firstOrderParam.x=Jpx;
obj.derivative.firstOrderParam.u=Jpu;


%compute second order jacobians using 'LR' variables
J=jacobian(fLR,[x;u]);
for k=1:length(J(:,1))
    %Calculate 2nd order Jacobians
    Jxu=jacobian(J(k,:),[x;u]);
    %obj.derivative.secondOrder(k,:,:)=simple(Jxu);
    obj.derivative.secondOrder(k,:,:)=Jxu;
end

%group expressions by parameters
%init
Jpxu=cell(1,obj.nrOfParam+1);
JxuAll=obj.derivative.secondOrder;
%part without parameters
Jpxu{1} = subs(JxuAll,p,zeros(obj.nrOfParam,1));
%part with parameters
I = eye(obj.nrOfParam); %identity matrix
for i=1:obj.nrOfParam
    Jpxu{i+1} = subs(JxuAll,p,I(i,:)) - Jpxu{1};
end
obj.derivative.secondOrderParam=Jpxu;

%generate mFile that computes the lagrange remainder and the jacobian
createJacobianFile(obj);
createRemainderFile(obj);
createHessianTensorFile(obj);
createParametricDynamicFile(obj);

% rehash the folder so that new generated files are used
rehash path;

%------------- END OF CODE --------------