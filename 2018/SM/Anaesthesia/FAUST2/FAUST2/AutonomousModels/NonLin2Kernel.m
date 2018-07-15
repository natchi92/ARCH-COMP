function [SymbolicKernel] = NonLin2Kernel(NonLinMean,NonLinSigma)
% This is the set up for a user defined kernel
% If the user fills in the three blue dotted areas, the function generates
% a kernel and can be loaded into FAUST2

dim=nargin(NonLinMean);     % The dimension of the model

%%%%%%%%%%% Creation of the symbolic variables %%%%%%%%%%
% The following lines create the symbolic variables.
% It is not necessary to change anything in these lines.
x='';
x_comma='';
xbar='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real']);
    eval(['syms',' ','x',num2str(i),'bar ','real']);
    x=[x,'x',num2str(i),' '];
    x_comma=[x_comma,'x',num2str(i),','];
    xbar=[xbar,'x',num2str(i),'bar '];
end
if x(end)==' '
    x=x(1:end-1);
end
if x_comma(end)==','
    x_comma=x_comma(1:end-1);
end
if xbar(end)==' '
    xbar=xbar(1:end-1);
end

% Creation of the matrices of symbolic variables
% These are vectors of the variables x, xbar and u
x_vec=eval(['[',x,']','''']);
xbar_vec=eval(['[',xbar,']','''']);

E_xbar=eval(['NonLinMean(',x_comma,')']);
Sigma=eval(['NonLinSigma(',x_comma,')']);

%%%%% Example of a user defined kernel (normal distribution) %%%%%

mat=-0.5*(xbar_vec-E_xbar)'*Sigma^(-1)*(xbar_vec-E_xbar); 
SymbolicKernel=sqrt((2*pi)^dim*det(Sigma))^-1*exp(mat);



%%%%%%%%% Finalization of the kernel %%%%%%%%%%%%
% Finally the next line ensures the correct order of variables and makes
% it applicable to FAUST2.

SymbolicKernel=eval(['matlabFunction(SymbolicKernel,''vars'',[',x,' ',xbar,'])']);

end % End of the function