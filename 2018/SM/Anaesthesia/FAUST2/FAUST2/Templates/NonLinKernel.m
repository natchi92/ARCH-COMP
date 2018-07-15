function [NonLinMean,NonLinSigma,dimension] = NonLinKernel()
% This is the set up for a non-linear Gaussian kernel
% If the user fills in the three blue dotted areas, the function generates
% a drift and covariance of the dynamical model and can be loaded into FAUST2
% Please refer to the m-file "NonLinKernelExample.m" for an explicit example

% Please fill in the dimension of the model and the dimension of the input
% in the next two lines:

dim = ...     % Write here the dimension of the model
dim_u = ...   % Write here the dimension of the input

% if the model is autonomous put dim_u = 0

% Please continue now to the last part of the code, titled:
% "Creation of the user defined function" %


%%%%%%%%%%% Creation of the symbolic variables %%%%%%%%%%
% The following lines create the symbolic variables.
% It is not necessary to change anything in these lines.
x='';
xbar='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real']);
    x=[x,'x',num2str(i),' '];
end
if x(end)==' '
    x=x(1:end-1);
end

u='';
for i=1:dim_u
    eval(['syms',' ','u',num2str(i),' ','real'])
    u=[u,'u',num2str(i),' '];
end
if u(end)==' '
    u=u(1:end-1);
end

% Creation of the matrices of symbolic variables
% These are vectors of the variables x, xbar and u
x_vec = eval(['[',x,']','''']);
u_vec = eval(['[',u,']','''']);




%%%%%%%%% Creation of the user defined function %%%%%%%%%%%%%
% The user can now use the following variables to create a conditional density function:
% x1, x2, ....
% u1, u2, ....
% Adding to that the user can use the vectors of symbolic variables:
% x_vec and u_vec.

% User input
NonLinMean=...      % Implement your function mean here
NonLinSigma=...     % Implement your function covariance matrix here


%%%%%%%%% Finalization of the non linear kernel %%%%%%%%%%%%
% Finally the next line ensures the correct order of variables and makes
% it applicable to FAUST2.

NonLinMean=eval(['matlabFunction(NonLinMean,''vars'',[',x,' ',u,'])']);
NonLinSigma=eval(['matlabFunction(NonLinSigma,''vars'',[',x,' ',u,'])']);

dimension=[dim,dim_u];

end % End of the function