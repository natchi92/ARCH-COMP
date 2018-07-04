function [obj,A_lin,U] = linearize(obj,options,R)
% linearize - linearizes the nonlinear DAE system; linearization error is not
% included yet
%
% Syntax:  
%    [obj,linSys,options,linOptions] = linearize(obj,options,R)
%
% Inputs:
%    obj - nonlinear DAE system object
%    options - options struct
%
% Outputs:
%    obj - linear system object
%    linSys - linear system object
%    options - options struct
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
% Written:      21-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%linearization point p.u of the input is the center of the input u
p.u = center(options.U) + options.uTrans;

%linearization point p.x and p.y
x0 = center(R);
p.x = x0;

%substitute p into the system equation in order to obtain the constant
%input
f0 = obj.dynFile(0, p.x, p.u);

%get jacobian matrices
[A_lin,B_lin] = jacobian(p.x, p.u);


uTrans = f0; %B*Ucenter from linOptions.U not added as the system is linearized around center(U)
Udelta = B_lin*(options.U+(-center(options.U)));
U = Udelta + uTrans;

%save linearization point
obj.linError.p=p;



%------------- END OF CODE --------------