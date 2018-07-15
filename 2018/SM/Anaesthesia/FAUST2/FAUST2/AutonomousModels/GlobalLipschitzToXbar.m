function [hbar] = GlobalLipschitzToXbar(KernelFunction,SafeSet)

%GLOBALLIPSCHITZTOXBAR Numerically computes the global Lipschitz constant
%   SafeSet = [xl,xu], where xl and xu are vectors containing the upper and
%   lower bounds of the set.
%   KernelFunction is the name of the kernel function. It must be in
%   function format

% Dimension of the Set and thus the system
dim=size(SafeSet,1);

% Alternative
options = optimset('Algorithm','trust-region-reflective','GradObj','on','TolFun',1e-20,'TolX',1e-6);

derivative='';
seq='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real'])
    eval(['syms',' ','x',num2str(i),'bar ','real'])
    derivative=[derivative,'diff(KernelFunction,x',num2str(i),'bar);'];
    seq=[seq,'x(',num2str(i*2-1),'),x(',num2str(i*2),'),'];
end
derivative=derivative(1:end-1);
seq=seq(1:end-1);

[~,Kernel2]=evalc(['sqrt(sum([',derivative,'].^2))']);
Kernel3=matlabFunction(Kernel2);

% Do a multistart optimization
q=msgbox('The global Lipschitz constant to xbar is being calculated with a multistart optimization');

options = optimset('Algorithm','sqp','TolFun',1e-20,'TolX',1e-6);
problem = createOptimProblem('fmincon','objective', ...
eval(['@(x)-(Kernel3(',seq,'))']),'x0',[sum(SafeSet,2)/2;sum(SafeSet,2)/2],'lb',[SafeSet(:,1);SafeSet(:,1)], ...
'ub',[SafeSet(:,2);SafeSet(:,2)],'options',options);
ms = MultiStart('MaxTime',5);
[~,ms] = evalc(['MultiStart(''MaxTime'',5)']);
[~,~,hbar] = evalc('run(ms,problem,100)');

close(q);
hbar=-hbar;

if hbar<1e-5
    warning('The Lipschitz constant is very small. Please check if this is according to expectations. If not, this can be solved by adjusting the TolFun parameter in line 14 of the GlobalLipschit.m file')
end

end


