function [h_u] = GlobalLipschitzToU_Contr(KernelFunction,SafeSet,InputSet)

%GLOBALLIPSCHITZTOUCONTR Numerically computes the global Lipschitz constant
%   Set = [xl,xu], where xl and xu are vectors containing the upper and
%   lower bounds of the set.
%   KernelFunction is the name of the kernel function. It must be in
%   function format

% Dimension of the SafeSet and thus the State Space
dim=size(SafeSet,1);

% Dimension of the input
dim_u=size(InputSet,1);

% Alternative
options = optimset('Algorithm','trust-region-reflective','GradObj','on','TolFun',1e-20,'TolX',1e-20);

derivative='';
seq='';
x='';
xbar='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real']);
    eval(['syms',' ','x',num2str(i),'bar ','real']);
    x=[x,'x',num2str(i),' '];
    xbar=[xbar,'x',num2str(i),'bar '];
    seq=[seq,'x(',num2str(i*2-1),'),x(',num2str(i*2),'),'];
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
    seq=[seq,'x(',num2str(dim*2+i),'),'];
    u=[u,'u',num2str(i),' '];
    derivative=[derivative,'diff(KernelFunction,u',num2str(i),');'];
end
if u(end)==' '
    u=u(1:end-1);
end

derivative=derivative(1:end-1);
seq=seq(1:end-1);

[~,Kernel2]=evalc(['sqrt(sum([',derivative,'].^2))']);
Kernel3=eval(['matlabFunction(Kernel2,''vars'',[',x,' ',xbar,' ',u,'])']);

% Do a multistart optimization
q=msgbox('The global Lipschitz constant is being calculated with a multistart optimization');

options = optimset('Algorithm','sqp','TolFun',1e-30,'TolX',1e-10);
problem = createOptimProblem('fmincon','objective', ...
eval(['@(x)-(Kernel3(',seq,'))']),'x0',[sum(SafeSet,2)/2;sum(SafeSet,2)/2;sum(InputSet,2)/2],'lb',[SafeSet(:,1);SafeSet(:,1);InputSet(:,1)], ...
'ub',[SafeSet(:,2);SafeSet(:,2);InputSet(:,2)],'options',options);
ms = MultiStart('MaxTime',5);
[~,ms] = evalc(['MultiStart(''MaxTime'',5)']);
[~,~,h_u] = evalc('run(ms,problem,500)');

close(q);
h_u=-h_u;

if h_u<1e-5
    warning('The Lipschitz constant is very small. Please check if this is according to expectations. If not, this can be solved by adjusting the TolFun parameter in line 14 of the GlobalLipschit.m file')
end

end


