function symbolicDerivation_powSys(obj,options)
% symbolicDerivation_powSys - computes the derivatives of the nonlinear DA system 
% in a symbolic way; the result is also stored in a m-file and passed by 
% a handle; this function is specifically designed for power systems
%
% Syntax:  
%    symbolicDerivation_powSys(obj,options)
%
% Inputs:
%    obj - nonlinear DA system object
%    options - options struct
%
% Outputs:
%    ---
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
% Written:      17-May-2013
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%create symbolic variables
[x,y,u] = symVariables(obj,'LRbrackets');

%insert symbolic variables into the system equations
t = 0;
fdyn = obj.dynFile(t,x,y,u);
fcon = obj.conFile(t,x,y,u);

disp('create Jacobians');

%compute jacobian with respect to the state
Jdyn.x = jacobian(fdyn,x);
Jcon.x = jacobian(fcon,x);
% obj.derivative.firstOrder.dyn.x = Jdyn_x;
% obj.derivative.firstOrder.con.x = Jcon_x;

%compute jacobian with respect to the constraint state
Jdyn.y = jacobian(fdyn,y);
Jcon.y = jacobian(fcon,y);
% obj.derivative.firstOrder.dyn.y = Jdyn_y;
% obj.derivative.firstOrder.con.y = Jcon_y;

%compute jacobian with respect to the input
Jdyn.u = jacobian(fdyn,u);
Jcon.u = jacobian(fcon,u);
% obj.derivative.firstOrder.dyn.u = Jdyn_u;
% obj.derivative.firstOrder.con.u = Jcon_u;

disp('create 2nd order Jacobians');

%compute second order jacobians using 'LR' variables
Jdyn_comb = jacobian(fdyn,[x;y;u]);
Jcon_comb = jacobian(fcon,[x;y;u]);
%dynamic jacobians
for k=1:length(Jdyn_comb(:,1))
    %Calculate 2nd order Jacobians
    J2dyn(k,:,:)=jacobian(Jdyn_comb(k,:),[x;y;u]);
    %obj.derivative.secondOrder.dyn(k,:,:)=Jdyn_xyu;
end

disp('create mFiles')

%generate mFile that computes the Lagrange remainder and the jacobian
createJacobianFile(Jdyn,Jcon,options.path,func2str(obj.dynFile));
%createRemainderFile(J2dyn,J2con,options.path);
createHessianTensorFile_powSys(J2dyn,options.path,func2str(obj.dynFile),options.Ybus);


%------------- END OF CODE --------------