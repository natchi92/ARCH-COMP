function symbolicDerivation(obj,options)
% symbolicDerivation - computes the derivatives of the nonlinear DA system 
% in a symbolic way; the result is also stored in a m-file and passed by 
% a handle
%
% Syntax:  
%    [obj] = symbolicDerivation(obj,options)
%
% Inputs:
%    obj - nonlinear DA system object
%
% Outputs:
%    obj - nonlinear DA system object
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
% Written:      27-October-2011
% Last update:  04-August-2016
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

%compute jacobian with respect to the constraint state
Jdyn.y = jacobian(fdyn,y);
Jcon.y = jacobian(fcon,y);

%compute jacobian with respect to the input
Jdyn.u = jacobian(fdyn,u);
Jcon.u = jacobian(fcon,u);

disp('create 2nd order Jacobians');

%compute second order jacobians using 'LR' variables
Jdyn_comb = jacobian(fdyn,[x;y;u]);
Jcon_comb = jacobian(fcon,[x;y;u]);

%init (in case there is no Jdyn_comb or Jcon_comb)
J2dyn = sym([]);
J2con = sym([]);

%dynamic jacobians
for k=1:length(Jdyn_comb(:,1))
    %Calculate 2nd order Jacobians
    J2dyn(k,:,:)=jacobian(Jdyn_comb(k,:),[x;y;u]);
    %obj.derivative.secondOrder.dyn(k,:,:)=Jdyn_xyu;
end
%constraint jacobians
for k=1:length(Jcon_comb(:,1))
    %Calculate 2nd order Jacobians
    J2con(k,:,:)=jacobian(Jcon_comb(k,:),[x;y;u]);
    %obj.derivative.secondOrder.con(k,:,:)=Jcon_xyu;
end

if options.tensorOrder>2
    disp('create 3rd order Jacobians');
    
    %dynamic part
    dim = length(J2dyn(:,1,1));
    vars = length(J2dyn(1,:,1));
    J3dyn = sym(zeros(dim,vars,vars,vars));

    %compute third order jacobians using 'LR' variables
    for k=1:length(J2dyn(:,1,1))
        for l=1:length(J2dyn(1,:,1))
            %Calculate 3rd order Jacobians
            J3dyn(k,l,:,:)=jacobian(J2dyn(k,l,:),[x;y;u]);
        end
    end
    
    %algebraic part
    dim = length(J2con(:,1,1));
    vars = length(J2con(1,:,1));
    J3con = sym(zeros(dim,vars,vars,vars));

    %compute third order jacobians using 'LR' variables
    for k=1:length(J2con(:,1,1))
        for l=1:length(J2con(1,:,1))
            %Calculate 3rd order Jacobians
            J3con(k,l,:,:)=jacobian(J2con(k,l,:),[x;y;u]);
        end
    end
end

disp('create mFiles')

%generate mFile that computes the Lagrange remainder and the jacobian
createJacobianFile(Jdyn,Jcon,options.path,func2str(obj.dynFile));
%createRemainderFile(J2dyn,J2con,options.path);
createHessianTensorFile(J2dyn,J2con,options.path,func2str(obj.dynFile));
% create 3rd order file
if options.tensorOrder>2
    create3rdOrderTensorFile(J3dyn,J3con,options.path,func2str(obj.dynFile));
end

% rehash the folder so that new generated files are used
rehash path;


%------------- END OF CODE --------------