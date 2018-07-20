function [h_ir_u] = SemiLocalLipschitzToU_Contr(KernelFunction,X,xl,xu,U,ul,uu,SafeSet)

%SEMILOCALLIPSCHITZTOU_CONTR Numerically computes the semi-local Lipschitz constants by
%taking the maximum local derivative over six different points. 
%   KernelFunctionName is the name of the kernel function. 
%   X is a matrix input which consists of the centers of the cell as well
%   as the length of the edges.
%   xl and xu denote the lower and upper bound from which cells the
%   Lipschitz constant is derived. This means that the output h_ij will
%   have dimensions [(xu-xl),m]. With m the cardinality of the partition
%   defined in X

% Cardinality
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Cardinality of the input
q=size(U,1);

% Dimension of the input
dim_u=size(U,2)/2;

% Creating the symbolic functions to derive the derivative of the kernel
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

% Initialization
h_ir_u=zeros((xu-xl+1),(uu-ul+1));
options = optimset('Algorithm','sqp','TolFun',1e-25,'TolX',1e-10,'MaxFunEvals',2e7);


semiloc=tic;

% Calculation of the Lipschitz Constants
h = waitbar(0,'Derivation of one point of the semi-local Lipschitz constants');
for i=xl
    for r=ul:uu
        waitbar((r-ul)/(uu-ul),h);
        [~,~,h_ir(i-xl+1,r-ul+1)] =  evalc(['fmincon(@(x)-(Kernel3(',seq,')),[X(i,1:dim)'';(SafeSet(:,2)+SafeSet(:,1))/2;U(r,1:dim_u)''],[],[],[],[],[X(i,1:dim)''-0.5*X(i,dim+1:2*dim)'';SafeSet(:,1);U(r,1:dim_u)''-0.5*U(r,dim_u+1:2*dim_u)''],[X(i,1:dim)''+0.5*X(i,dim+1:2*dim)'';SafeSet(:,2);U(r,1:dim_u)''+0.5*U(r,dim_u+1:2*dim_u)''],[],options)']);
    end
end
h_ir=-h_ir;
close(h);

Ktime=toc(semiloc);



% Time check and notification set for calculations 
Ctime=Ktime*((xu-xl));
button='';
sound='';
if Ctime>30
    button = questdlg(['The creation of the semi-local Lipschitz constants will take approximately ',...
        num2str(floor(Ctime/60)),' minutes and ',...
        num2str(mod(round(Ctime),60)),' seconds. Do you wish to continue?'],...
        'Derivation Time Warning!','No');
end
if strcmp(button,'No')
    h_ir=zeros((xu-xl+1),(uu-ul+1));
    return
elseif strcmp(button,'Yes')
   sound=questdlg(['Do you wish Matlab to notify you',...
       ' with a sound when the calculations have been finished?'],...
        'Notification','Yes');
elseif strcmp(button,'Cancel')
   sound=display(['The process will continue. This will take approximately ',...
       num2str(round(Ctime)),' seconds.']);
end


% Calculation of the Lipschitz Constants
h = waitbar(0,'Derivation of the semi-local Lipschitz constants');
for i=xl:xu
    waitbar((i-xl)/(xu-xl),h);
    for r=ul:uu
        [~,~,h_ir_u(i-xl+1,r-ul+1)] =  evalc(['fmincon(@(x)-(Kernel3(',seq,')),[X(i,1:dim)'';(SafeSet(:,2)+SafeSet(:,1))/2;U(r,1:dim_u)''],[],[],[],[],[X(i,1:dim)''-0.5*X(i,dim+1:2*dim)'';SafeSet(:,1);U(r,1:dim_u)''-0.5*U(r,dim_u+1:2*dim_u)''],[X(i,1:dim)''+0.5*X(i,dim+1:2*dim)'';SafeSet(:,2);U(r,1:dim_u)''+0.5*U(r,dim_u+1:2*dim_u)''],[],options)']);
    end
end
h_ir_u=-h_ir_u;
close(h);



% Play sound if calculations have finished (optional)
if strcmp(sound,'Yes')
    beep
end


end
%=================== End of function implementation =======================