function normdistcontr = NormDistSymb_Contr(A,B,Sigma)
%NormDistSymbContr Creates a symbolic representation of the function x(k+1)=
%A*x(k)+B*u(k)+epsilon. Where epsilon is a normal distributed error term 
%with covariance Sigma.
%   A and Sigma are square matrices of size dim*dim, mu is optional 
%   (default is 0) and is of size (dim,1) 

dim=size(A,1);
dim_u=size(B,2);

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

u='';
for i=1:dim_u
    eval(['syms',' ','u',num2str(i),' ','real'])
    u=[u,'u',num2str(i),' '];
end
if u(end)==' '
    u=u(1:end-1);
end

E_xbar=eval(['A*','[',x,']','''','+B*','[',u,']']);
xbar_mat=eval(['[',xbar,']','''']);
mat=(xbar_mat-E_xbar)'*Sigma^(-1)*(xbar_mat-E_xbar);
normdistcontr=sqrt((2*pi)^dim*det(Sigma))^-1*exp(-0.5*mat);
normdistcontr=eval(['matlabFunction(normdistcontr,''vars'',[',x,' ',xbar,' ',u,'])']);
end

