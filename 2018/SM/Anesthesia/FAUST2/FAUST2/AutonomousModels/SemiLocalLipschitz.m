
function [h_i] = SemiLocalLipschitz(KernelFunction,X,Set,xl,xu)

%SEMILOCALLIPSCHITZ Numerically computes the semi-local Lipschitz constants
%   Set = [xl,xu], where xl and xu are vectors containing the upper and
%   lower bounds of the set.
%   KernelFunctionName is the name of the kernel function. This input must
%   be a string.
%   X is a matrix input which consists of the centres of the cell as well
%   as the length of the edges.

% Cardinality of the partition of the SafeSet
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Adapt if only two inputs are given
if nargin == 3
    xl=1;
    xu=m;
end

% Creating the symbolic functions to derive the derivative of the kernel
derivative='';
seq='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real'])
    eval(['syms',' ','x',num2str(i),'bar ','real'])
    derivative=[derivative,'diff(KernelFunction,x',num2str(i),');'];
    seq=[seq,'x(',num2str(i*2-1),'),x(',num2str(i*2),'),'];
end
derivative=derivative(1:end-1);
seq=seq(1:end-1);

[~,Kernel2]=evalc(['sqrt(sum([',derivative,'].^2))']);
Kernel3=matlabFunction(Kernel2);

% Initialization
h_i=zeros((xu-xl+1),1);
options = optimset('Algorithm','sqp','TolFun',1e-20,'TolX',1e-6);

% Calculation of the Lipschitz Constants
h = waitbar(0,'Derivation of the semi-local Lipschitz constants');
for i=xl:xu
    waitbar((i-xl)/(xu-xl),h);
    [~,~,h_i(i-xl+1)] =  evalc(['fmincon(@(x)-(Kernel3(',seq,')),[X(i,1:dim)'';(Set(:,2)+Set(:,1))/2],[],[],[],[],[X(i,1:dim)''-0.5*X(i,dim+1:2*dim)'';Set(:,1)],[X(i,1:dim)''+0.5*X(i,dim+1:2*dim)'',Set(:,2)],[],options)']);
end
h_i=-h_i;
close(h);

% catch singular points where h_i=0
zz=find(h_i<0.00001);
if sum(zz(:))>0
    for i=1:numel(zz)
        i2=i+xl-1;
        [~,~,h_i(zz(i))] =  evalc(['fmincon(@(x)-(Kernel3(',seq,')),[X(i2,1:dim)''-0.3*X(i2,dim+1:2*dim)'';(Set(:,2)+Set(:,1))/2],[],[],[],[],[X(i2,1:dim)''-0.5*X(i2,dim+1:2*dim)'';Set(:,1)],[X(i2,1:dim)''+0.5*X(i2,dim+1:2*dim)'',Set(:,2)],[],options)']);
        h_i(zz(i))=-h_i(zz(i));
    end
end


end


