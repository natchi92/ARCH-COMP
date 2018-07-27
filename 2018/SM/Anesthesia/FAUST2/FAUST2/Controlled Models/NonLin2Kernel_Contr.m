function [SymbolicKernel] = NonLin2Kernel_Contr(NonLinMean,NonLinSigma,dimension)
% This is the set up for a user defined kernel
% If the user fills in the three blue dotted areas, the function generates
% a kernel and can be loaded into FAUST2

dim=dimension(1);     % The dimension of the model
dim_u=dimension(2);   % The dimension of the input

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

u='';
u_comma='';
for i=1:dim_u
    eval(['syms',' ','u',num2str(i),' ','real'])
    u=[u,'u',num2str(i),' '];
    u_comma=[u_comma,'u',num2str(i),','];
end
if u(end)==' '
    u=u(1:end-1);
end
if u_comma(end)==','
    u_comma=u_comma(1:end-1);
end

% Creation of the matrices of symbolic variables
% These are vectors of the variables x, xbar and u
x_vec=eval(['[',x,']','''']);
xbar_vec=eval(['[',xbar,']','''']);
u_vec=eval(['[',u,']','''']);

E_xbar=eval(['NonLinMean(',x_comma,',',u_comma,')']);
Sigma=eval(['NonLinSigma(',x_comma,',',u_comma,')']);

%%%%% Example of a user defined kernel (normal distribution) %%%%%

mat=-0.5*(xbar_vec-E_xbar)'*Sigma^(-1)*(xbar_vec-E_xbar); 
SymbolicKernel=sqrt((2*pi)^dim*det(Sigma))^-1*exp(mat);



%%%%%%%%% Finalization of the kernel %%%%%%%%%%%%
% Finally the next line ensures the correct order of variables and makes
% it applicable to FAUST2.

SymbolicKernel=eval(['matlabFunction(SymbolicKernel,''vars'',[',x,' ',xbar,' ',u,'])']);

end % End of the function