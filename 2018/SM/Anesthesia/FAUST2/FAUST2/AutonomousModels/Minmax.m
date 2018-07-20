function k_ij = Minmax(KernelFunction,X,xl,xu)
%MINMAX Calculates the difference between the minima and the maxima of the
%transition kernel
%   X is a matrix input which consists of the centres of the cell as well
%   as the length of the edges.
%   KernelFunction is the name of the Kernel. The output is
%   a 2*dim dimensional matrix containing al the local differences between
%   the minima and the maxima. Where dim is the dimension of the system of
%   the kernel.
%   xl and xu denote the lower and upper bound from which cells the
%   min-max constant is derived. This means that the output k_ij will
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

% Selection matrix for k_ij
C=unique(nchoosek(repmat([0 1],1,dim*2),dim*2),'rows')-0.5;

% Initialization
k_ij=zeros((xu-xl+1),m);

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
    
    h=msgbox('Creation of the local minima and maxima is in progress');
    k_ij_aux = KernelFunction(p{:});
    close(h);

    % The difference calculated
    k_max = max(k_ij_aux,[],3);
    k_min = min(k_ij_aux,[],3);
    k_ij=k_max-k_min;

    
catch %This is the slower but less memory expensive way
    
    % Calculation of the Lipschitz constant for 1 point (for timing
    % puposes)
    tic
    h = waitbar(0,'Derivation of the local Lipschitz constants for 1 point');

    % A single loop for timing (i=1 is preset)
    for j=1:m
        waitbar(j/m,h);
        for k=1:2^(dim*2)
            p=num2cell([[X(1,1:dim),X(j,1:dim)]-[X(1,dim+1:2*dim),X(j,dim+1:2*dim)].*C(k,:)]);
            k_ij_aux(k)=KernelFunction(p{:});
        end
        k_ij(1,j)=max(k_ij_aux)-min(k_ij_aux);
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
    h = waitbar(0,'Derivation of the local minima and maxima constants');

    for i=(xl+1):xu
        waitbar((i-xl)/(xu-xl),h);
        for j=1:m
            for k=1:2^(dim*2)
                p=num2cell([[X(i,1:dim),X(j,1:dim)]-[X(i,dim+1:2*dim),X(j,dim+1:2*dim)].*C(k,:)]);
                k_ij_aux(k)=KernelFunction(p{:});
            end
        k_ij(i-xl+1,j)=max(k_ij_aux)-min(k_ij_aux);
        end
    end

    close(h);


    % Play sound if calculations have finished (optional)
    if strcmp(sound,'Yes')
        beep
    end

end % This ends the try and catch algorithm

end

