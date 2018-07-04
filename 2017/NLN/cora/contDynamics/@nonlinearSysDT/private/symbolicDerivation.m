function symbolicDerivation(obj,options)
% symbolicDerivation - computes the derivatives of the nonlinear system 
% in a symbolic way; the result is also stored in a m-file and passed by 
% a handle
%
% Syntax:  
%    [obj] = symbolicDerivation(obj,options)
%
% Inputs:
%    obj - nonlinear DT system object
%
% Outputs:
%    obj - nonlinear DT system object
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
% Written:      21-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%create symbolic variables
[x,u] = symVariables(obj,'LRbrackets');

%insert symbolic variables into the system equations
t = 0;
fdyn = obj.dynFile(t,x,u);

disp('create Jacobians');

%compute jacobian with respect to the state
Jdyn.x = jacobian(fdyn,x);

%compute jacobian with respect to the input
Jdyn.u = jacobian(fdyn,u);

disp('create 2nd order Jacobians');

%compute second order jacobians using 'LR' variables
Jdyn_comb = jacobian(fdyn,[x;u]);
%dynamic jacobians
for k=1:length(Jdyn_comb(:,1))
    %Calculate 2nd order Jacobians
    J2dyn(k,:,:)=jacobian(Jdyn_comb(k,:),[x;u]);
end

if options.tensorOrder>2

    disp('create 3rd order Jacobians');

    %compute third order jacobians using 'LR' variables
    for k=1:length(J2dyn(:,1,1))
        for l=1:length(J2dyn(1,:,1))
            %Calculate 2nd order Jacobians
            J3dyn(k,l,:,:)=jacobian(J2dyn(k,l,:),[x;u]);
        end
    end
end

disp('create mFiles')

%generate mFile that computes the Lagrange remainder and the jacobian
createJacobianFile(Jdyn,options.path);
%createRemainderFile(J2dyn,J2con,options.path);

if options.tensorOrder>2
    createHessianTensorFile(J2dyn,options.path,0);
    create3rdOrderTensorFile(J3dyn,options.path);
else
    createHessianTensorFile(J2dyn,options.path,1);
end

% rehash the folder so that new generated files are used
rehash path;

%------------- END OF CODE --------------