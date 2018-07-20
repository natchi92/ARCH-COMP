function [h_ij] = LocalLipschitz_old(KernelFunction,X)

%LOCALLIPSCHITZ Numerically computes the local Lipschitz constants
%   KernelFunctionName is the name of the kernel function. This input must
%   be a string.
%   X is a structure input which consists of cells, delta and m


% Cardinality of the partition of the SafeSet
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;


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

[~,Kernel2]=evalc(['norm([',derivative,'],2)']);
Kernel3=matlabFunction(Kernel2);

% Initialization
h_ij=zeros(m,m);

% Calculation of the Lipschitz constant for 1 point (for timing
% puposes)
tic
h = waitbar(0,'Derivation of the local Lipschitz constants for 1 point');

% A single loop for timing (i=1 is preset)
for j=1:m
    waitbar(j/m,h);
    
    p1=num2cell([[X(1,1:dim)]+X(1,dim+1:2*dim)*0.5,X(j,1:dim)]);
    p2=num2cell([[X(1,1:dim)]-X(1,dim+1:2*dim)*0.5,X(j,1:dim)]);
    p3=num2cell([[X(1,1:dim)]+X(1,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5]);
    p4=num2cell([[X(1,1:dim)]-X(1,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5]);
    p5=num2cell([[X(1,1:dim)]+X(1,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5]);
    p6=num2cell([[X(1,1:dim)]-X(1,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5]);
    h_ij_b1 = Kernel3(p1{:});
    h_ij_b2 = Kernel3(p2{:});
    h_ij_b3 = Kernel3(p3{:});
    h_ij_b4 = Kernel3(p4{:});
    h_ij_b5 = Kernel3(p5{:});
    h_ij_b6 = Kernel3(p6{:});
    h_ij(1,j) = max([h_ij_b1,h_ij_b2,h_ij_b3,h_ij_b4,h_ij_b5,h_ij_b6]);
end


close(h);
Ctime1=toc;


% Time check and notification set for calculations 
Ctime=Ctime1*(m-1);
button='';
sound='';
if Ctime>30
    button = questdlg(['The creation of the semi-local Lipschitz constants will take approximately ',...
        num2str(floor(Ctime/60)),' minutes and ',...
        num2str(mod(round(Ctime),60)),' seconds. Do you wish to continue?'],...
        'Derivation Time Warning!','No');
end
if strcmp(button,'No')
    error('The process has been terminated')
elseif strcmp(button,'Yes')
   sound=questdlg(['Do you wish Matlab to notify you',...
       ' with a sound when the calculations have been finished?'],...
        'Notification','Yes');
elseif strcmp(button,'Cancel')
   sound=display(['The process will continue. This will take approximately ',...
       num2str(round(Ctime)),' seconds.']);
end

% Calculation of the pointwise minima and maxima for the remaining points
h = waitbar(0,'Derivation of the local Lipschitz constants');

for i=2:m
    waitbar((i-1)/(m-1),h);
    for j=1:m
        p1=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,X(j,1:dim)]);
        p2=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,X(j,1:dim)]);
        p3=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5]);
        p4=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5]);
        p5=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5]);
        p6=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5]);
        h_ij_b1 = Kernel3(p1{:});
        h_ij_b2 = Kernel3(p2{:});
        h_ij_b3 = Kernel3(p3{:});
        h_ij_b4 = Kernel3(p4{:});
        h_ij_b5 = Kernel3(p5{:});
        h_ij_b6 = Kernel3(p6{:});
        h_ij(i,j) = max([h_ij_b1,h_ij_b2,h_ij_b3,h_ij_b4,h_ij_b5,h_ij_b6]);
    end
end

close(h);


% Play sound if calculations have finished (optional)
if strcmp(sound,'Yes')
    beep
end


end

