function [obj,linearSys,linOptions] = linearize(obj,options,R)
% linearize - linearizes the nonlinear system with uncertain parameters;
% linearization error is not included yet
%
% Syntax:  
%    [obj,linearIntSys,linOptions] = linearize(obj,options,R)
%
% Inputs:
%    obj - nonlinear interval system object
%    options - options struct
%    R - actual reachable set
%
% Outputs:
%    obj - nonlinear interval system object
%    linearIntSys - linear interval system object
%    linOptions - options for the linearized system
%
% Example: 
%    Text for example...
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      18-January-2008 
% Last update:  30-June-2009
%               27-May-2011
% Last revision:---

%------------- BEGIN CODE --------------


%linearization point p.u of the input is the center of the input u
p.u=center(options.U) + options.uTrans;

%linearization point p.x of the state is the center of the last reachable 
%set R translated by f0*delta_t
t=0; %time invariant system
f0prev=obj.mFile(t,center(R),p.u,mid(options.paramInt));
p.x=center(R)+f0prev*0.5*options.timeStep;


%substitute p into the system equation in order to obtain the constant
%input
f0cell=parametricDynamicFile(p.x,p.u);
%f0test=obj.mFile(t,p.x,p.u,options.paramInt);

%normalize cells
for i=2:length(f0cell)
    f0cell{1} = f0cell{1} + mid(options.paramInt(i-1))*f0cell{i};
    f0cell{i} = rad(options.paramInt(i-1))*f0cell{i};
end

%create constant input zonotope
f0Mat(length(f0cell{1}(:,1)),length(f0cell)) = 0; %init
for i=1:length(f0cell)
    f0Mat(:,i) = f0cell{i};
end
zf = zonotope(f0Mat);

%substitute p into the Jacobian with respect to x and u to obtain the
%system matrix A and the input matrix B
[A,B]=jacobian(p.x,p.u);

%create matrix zonotopes
zA = matZonotope(A{1},A(2:end));
zB = matZonotope(B{1},B(2:end));

%set up otions for linearized system
linOptions = options;

U = zB*(options.U + options.uTrans + (-p.u));
Ucenter = center(U);
linOptions.U = U + (-Ucenter);
linOptions.Uconst = zf + Ucenter;
linOptions.originContained = 0;

%set up linearized system
if ~obj.constParam
    %time-variant linear parametric system
    linearSys = linVarSys(zA,1,options.timeStep,options.taylorTerms); %B=1 as input matrix encountered in uncertain inputs
else
    %time-invariant linear parametric system
    linearSys = linParamSys(zA,1,options.timeStep,options.taylorTerms); %B=1 as input matrix encountered in uncertain inputs
end

%save constant input
obj.linError.f0=[]; %<-- old; to be removed later

%save linearization point
obj.linError.p=p;


%------------- END OF CODE --------------