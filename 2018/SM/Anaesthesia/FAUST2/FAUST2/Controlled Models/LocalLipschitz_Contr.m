function [h_ijr] = LocalLipschitz_Contr(KernelFunction,X,xl,xu,U,ul,uu)

%LOCALLIPSCHITZ_CONTR Numerically computes the local Lipschitz constants by
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
    derivative=[derivative,'diff(KernelFunction,x',num2str(i),');'];
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
end
if u(end)==' '
    u=u(1:end-1);
end

derivative=derivative(1:end-1);
seq=seq(1:end-1);

[~,Kernel2]=evalc(['sqrt(sum([',derivative,'].^2))']);
Kernel3=eval(['matlabFunction(Kernel2,''vars'',[',x,' ',xbar,' ',u,'])']);

% Initialization
h_ijr=zeros((xu-xl+1),m,(uu-ul+1));

% Selection matrix for h_ijr
C=unique(nchoosek(repmat([0 1],1,dim*2+dim_u),dim*2+dim_u),'rows')-0.5;

try %This is the fast but memory expensive way

    p=cell(1,2*dim+dim_u);
    % Creation of all the corner points to check
    for i=1:dim
        for k=1:2^(dim*2+dim_u)
            p{i}(:,:,:,k)=repmat(X(xl:xu,i)+X(xl:xu,dim+i)*C(k,i),[1,m,uu-ul+1]);
        end
    end
    for i=dim+1:2*dim
        for k=1:2^(dim*2+dim_u)
            p{i}(:,:,:,k)=repmat(X(:,i-dim)'+X(:,i)'*C(k,i),[(xu-xl+1),1,uu-ul+1]);
        end
    end
    for i=2*dim+1:2*dim+dim_u
        for k=1:2^(dim*2+dim_u)
            p{i}(:,:,:,k)=repmat(reshape(U(ul:uu,i-2*dim)'+U(ul:uu,i-2*dim+dim_u)'*C(k,i),[1 1 uu-ul+1]),[(xu-xl+1),m,1]);
        end
    end
    % Creation of the local minima and maxima
    h=msgbox('Creation of the local Lipschitz constants is in progress');
    h_ijr_aux = Kernel3(p{:});
    close(h);

    % The local Lipschitz constant
    h_ijr = max(h_ijr_aux,[],4);

   
catch %This is the slower but less memory expensive way
    
    % Calculation of the Lipschitz constant for 1 point (for timing
    % puposes)
    tic
    h = waitbar(0,'Derivation of the local Lipschitz constants for 1 point');

    % A single loop for timing (i=1 is preset)

    i=xl;   
    for j=1:m
        waitbar(j/m,h);
        for k=ul:uu 
            p1=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
            p2=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
            p3=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
            p4=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
            p5=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
            p6=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
            p7=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
            p8=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
            p9=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
            p10=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
            p11=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
            p12=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
            h_ij_b1 = Kernel3(p1{:});
            h_ij_b2 = Kernel3(p2{:});
            h_ij_b3 = Kernel3(p3{:});
            h_ij_b4 = Kernel3(p4{:});
            h_ij_b5 = Kernel3(p5{:});
            h_ij_b6 = Kernel3(p6{:});
            h_ij_b7 = Kernel3(p7{:});
            h_ij_b8 = Kernel3(p8{:});
            h_ij_b9 = Kernel3(p9{:});
            h_ij_b10 = Kernel3(p10{:});
            h_ij_b11 = Kernel3(p11{:});
            h_ij_b12 = Kernel3(p12{:});
            h_ijr(i-xl+1,j,k-ul+1) = max([h_ij_b1,h_ij_b2,h_ij_b3,h_ij_b4,h_ij_b5,h_ij_b6,h_ij_b7,h_ij_b8,h_ij_b9,h_ij_b10,h_ij_b11,h_ij_b12]);
        end
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
            for k=ul:uu 
                p1=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
                p2=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
                p3=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
                p4=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
                p5=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
                p6=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]+U(k,dim_u+1:2*dim_u)*0.5]);
                p7=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
                p8=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,X(j,1:dim),[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
                p9=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
                p10=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]+X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
                p11=num2cell([[X(i,1:dim)]+X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
                p12=num2cell([[X(i,1:dim)]-X(i,dim+1:2*dim)*0.5,[X(j,1:dim)]-X(j,dim+1:2*dim)*0.5,[U(k,1:dim_u)]-U(k,dim_u+1:2*dim_u)*0.5]);
                h_ij_b1 = Kernel3(p1{:});
                h_ij_b2 = Kernel3(p2{:});
                h_ij_b3 = Kernel3(p3{:});
                h_ij_b4 = Kernel3(p4{:});
                h_ij_b5 = Kernel3(p5{:});
                h_ij_b6 = Kernel3(p6{:});
                h_ij_b7 = Kernel3(p7{:});
                h_ij_b8 = Kernel3(p8{:});
                h_ij_b9 = Kernel3(p9{:});
                h_ij_b10 = Kernel3(p10{:});
                h_ij_b11 = Kernel3(p11{:});
                h_ij_b12 = Kernel3(p12{:});
                h_ijr(i-xl+1,j,k-ul+1) = max([h_ij_b1,h_ij_b2,h_ij_b3,h_ij_b4,h_ij_b5,h_ij_b6,h_ij_b7,h_ij_b8,h_ij_b9,h_ij_b10,h_ij_b11,h_ij_b12]);
            end
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