function [NonLinMean,NonLinSigma,dimension] = NonLinKernelExample()
%%%%% Example of a user defined non-linear Gaussian model %%%%%
% The following code construct the density function for the dynamical model
% x1(k+1) = x1(k)[0.5 x1(k) + 0.3 x2(k) + u(k)] + eta1(k),
% x2(k+1) = x1(k) + 0.2 x2(k) + 2 u(k) + eta2(k);
% where eta1 and eta2 are defined by a multi-variate normal distribution
% with state and input dependent covariance matrix:
% Cov(eta1(k),eta2(k))=[0.5 0; 0 0.5]+u(k)*x(k)'*[0.5 0.3; 1 0.2]*x(k),
% with x(k)=[x1(k) x2(k)]'.


dim=2;     % The dimension of the model
dim_u=1;   % The dimension of the input

%%%%%%%%%%% Creation of the symbolic variables %%%%%%%%%%
% The following lines create the symbolic variables.
% It is not necessary to change anything in these lines.
x='';
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
x_vec=eval(['[',x,']','''']);
u_vec=eval(['[',u,']','''']);

%%%%%%%%%%% Defining mean and covariance matrix %%%%%%%%%%
A = [0.5 0.3; 1 0.2];
B = [1; 2];
Sigma = 0.5*eye(2);
% vectorized manipulation
NonLinMean = A*x_vec+B*u_vec;
% element-wise manipulation
NonLinMean(1) = NonLinMean(1)*x1;

% Non-linear covariance matrix
NonLinSigma=Sigma+u1*x_vec'*A*x_vec;


%%%%%%%%% Finalization of the non linear kernel %%%%%%%%%%%%
% Finally the next line ensures the correct order of variables and makes
% it applicable to FAUST2.

NonLinMean=eval(['matlabFunction(NonLinMean,''vars'',[',x,' ',u,'])']);
NonLinSigma=eval(['matlabFunction(NonLinSigma,''vars'',[',x,' ',u,'])']);

dimension=[dim,dim_u];

end % End of the function