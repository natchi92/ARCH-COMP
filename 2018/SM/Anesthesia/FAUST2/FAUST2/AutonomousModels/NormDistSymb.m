function [ normdist ] = NormDistSymb(A,Sigma,drift)
%NormDistSymb Creates a symbolic representation of the function x(k+1)=
%A*x(k)+mu+epsilon. Where mu is the drift term and epsilon a normal
%distributed error term with covariance Sigma
%   A and Sigma are square matrices of size dim*dim, mu is optional 
%   (default is 0) and is of size (dim,1) 

dim=size(A,1);

if nargin==2
    drift=zeros(dim,1);
end

x='';
xbar='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real']);
    eval(['syms',' ','x',num2str(i),'bar ','real']);
    x=[x,'x',num2str(i),' '];
    xbar=[xbar,'x',num2str(i),'bar '];
end
if x(end)==' '
    x=x(1:end-1);
end
if xbar(end)==' '
    xbar=xbar(1:end-1);
end

E_xbar=eval(['A*','[',x,']','''','+drift']);
xbar_mat=eval(['[',xbar,']','''']);
mat=(xbar_mat-E_xbar)'*Sigma^(-1)*(xbar_mat-E_xbar);
normdist=sqrt((2*pi)^dim*det(Sigma))^-1*exp(-0.5*mat);
normdist=matlabFunction(normdist);
normdist=eval(['matlabFunction(normdist,''vars'',[',x,' ',xbar,'])']);
end

