function [h_ij] = LocalLipschitz(KernelFunction,X,xl,xu)

%LOCALLIPSCHITZ Numerically computes the local Lipschitz constants by
%taking the maximum local derivative over six different points. 
%   KernelFunctionName is the name of the kernel function.
%   X is a matrix input which consists of the centers of the cell as well
%   as the length of the edges.
%   xl and xu denote the lower and upper bound from which cells the
%   Lipschitz constant is derived. This means that the output h_ij will
%   have dimensions [(xu-xl),m]. With m the cardinality of the partition
%   defined in X

% Cardinality of the partition of the SafeSet
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Adapt if only two inputs are given
if nargin == 2
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

% Selection matrix for k_ij
C=unique(nchoosek(repmat([0 1],1,dim*2),dim*2),'rows')-0.5;

% Initialization
h_ij=zeros((xu-xl+1),m);

try %This is the fast but memory expensive way

    p=cell(1,2*dim);
    % Creation of all the corner points to check
    for i=1:dim
        for k=1:2^(dim*2)
            p{i}(:,:,k)=kron(X(xl:xu,i)+C(k,i)*X(xl:xu,dim+i),ones(1,m));
        end
    end
    for i=dim+1:2*dim
        for k=1:2^(dim*2)
            p{i}(:,:,k)=kron(X(:,i-dim)'+X(:,i)'*C(k,i),ones((xu-xl+1),1));
        end
    end

    % Creation of the local minima and maxima
    
    h=msgbox('Creation of the local Lipschitz constants is in progress');
    h_ij_aux = Kernel3(p{:});
    close(h);

    h_ij=max(h_ij_aux,[],3);


    
catch %This is the slower but less memory expensive way
    
    % Calculation of the Lipschitz constant for 1 point (for timing
    % puposes)
    tic
    h = waitbar(0,'Derivation of the local Lipschitz constants for 1 point');

    % A single loop for timing (i=1 is preset)
    for j=1:m
        waitbar(j/m,h);

        p1=num2cell([[X(xl,1:dim)]+X(xl,dim+1:2*dim)*0.5,X(j,1:dim)]);
        p2=num2cell([[X(xl,1:dim)]-X(xl,dim+1:2*dim)*0.5,X(j,1:dim)]);
        p3=num2cell([[X(xl,1:dim)]+X(xl,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5]);
        p4=num2cell([[X(xl,1:dim)]-X(xl,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5]);
        p5=num2cell([[X(xl,1:dim)]+X(xl,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5]);
        p6=num2cell([[X(xl,1:dim)]-X(xl,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5]);
        h_ij_b1 =Kernel3(p1{:});
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
    Ctime=Ctime1*((xu-xl));
    button='';
    sound='';
    if Ctime>30
        button = questdlg(['The creation of the local Lipschitz constants will take approximately ',...
            num2str(floor(Ctime/60)),' minutes and ',...
            num2str(mod(round(Ctime),60)),' seconds. Do you wish to continue?'],...
            'Derivation Time Warning!','No');
    end
    if strcmp(button,'No')
        return
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

    for i=(xl+1):xu
        waitbar((i-xl)/(xu-xl),h);
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
            h_ij(i-xl+1,j) = max([h_ij_b1,h_ij_b2,h_ij_b3,h_ij_b4,h_ij_b5,h_ij_b6]);
        end
    end

    close(h);


    % Play sound if calculations have finished (optional)
    if strcmp(sound,'Yes')
        beep
    end

end % This ends the try and catch algorithm

end
%=================== End of function implementation =======================
