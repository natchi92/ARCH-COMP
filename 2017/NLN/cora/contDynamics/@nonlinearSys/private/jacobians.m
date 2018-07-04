function [obj] = jacobians(varargin)
% jacobians - computes the jacobians of the nonlinear system in a symbolic
% way; the result is stored in a m-file and passed by a handle
%
% Syntax:  
%    [obj] = jacobians(obj)
%
% Inputs:
%    obj - nonlinear system object
%
% Outputs:
%    obj - nonlinear system object
%
% Example: 
%    ---
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      29-October-2007 
% Last update:  07-September-2012
%               12-October-2015
%               08-April-2016
% Last revision:---

%------------- BEGIN CODE --------------

% obtain object and options
obj = varargin{1};
options = varargin{2};

path = [coraroot '/contDynamics/stateSpaceModels'];


%create symbolic variables
[x,u] = symVariables(obj,'LRbrackets');

%insert symbolic variables into the system equations
t = 0;
fdyn = obj.mFile(t,x,u);

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
    dim = length(J2dyn(:,1,1));
    vars = length(J2dyn(1,:,1));
    %J3dyn = sym(zeros(dim,vars,vars,vars));

    %compute third order jacobians using 'LR' variables
    for k=1:length(J2dyn(:,1,1))
        for l=1:length(J2dyn(1,:,1))
            %Calculate 3rd order Jacobians
            if ~isempty(find(J2dyn(k,l,:), 1))
                J3dyn(k,l,:,:)=jacobian(reshape(J2dyn(k,l,:),[vars,1]),[x;u]);
            end
        end
    end
end

disp('create mFiles')

%generate mFile that computes the Lagrange remainder and the jacobian
createJacobianFile(Jdyn,path,obj.name);
createRemainderFile(obj,J2dyn,path,obj.name);

if options.tensorOrder>2
    createHessianTensorFile(J2dyn,path,obj.name,0);
    create3rdOrderTensorFile(J3dyn,path,obj.name);
    %create3rdOrderTensorFile_wReplacements(J3dyn,path,options.replacements);
else
    createHessianTensorFile(J2dyn,path,obj.name,1);
end

% rehash the folder so that new generated files are used
rehash path;

%------------- END OF CODE --------------