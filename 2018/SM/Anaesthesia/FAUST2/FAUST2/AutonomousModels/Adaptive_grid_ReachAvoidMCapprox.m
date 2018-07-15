
function [X,E] = Adaptive_grid_ReachAvoidMCapprox(epsilon,KernelFunction,N,SafeSet,TargetSet)
%Adaptive_grid_ReachAvoidMCapprox This function makes an adaptive grid that will
%produce a certain maximal abstraction error defined by epsilon. 
%   Input of this function is the desired maximal error epsilon, the kernel
%   function, the number of time steps N and the upper and an initial
%   partition X.
%   The output is a new partition X and a maximum error

% The dimension of the system 
dim = size(SafeSet,1);

% The length of the edges of the Set
r=SafeSet(:,2)-SafeSet(:,1);


%%%%%%%%%%%%%%%%%%% uniform grid part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The dimension of the system 
dim = size(SafeSet,1);

% The length of the edges of the Target Set
rT=TargetSet(:,2)-TargetSet(:,1);

% The length of the edges of the Safe Set
rS=SafeSet(:,2)-SafeSet(:,1);

% Derivation of the global Lipschitz constant
h = GlobalLipschitz(KernelFunction,SafeSet); % over approximation

% The length of the edges of the partitions
delta=(epsilon/(prod(rS)*h*N))/sqrt(dim);

% Adjust delta if it is very large compared to r
while prod(ceil(rS/delta))< (2^dim+10) % appr number of bins
    delta=delta/(2^(1/dim)); % This will cause the number of cells to double
end
    
% delta is adjusted so that the edges of the TargetSet are part of the partitions
for i = 1:dim
    delta_adj(i)=(TargetSet(i,2)-TargetSet(i,1))/ceil((TargetSet(i,2)-TargetSet(i,1))/delta);
end

% The adjusted SafeSet to fit with delta_adj
Residuals=mod((SafeSet-TargetSet),repmat(delta_adj',1,2))+[-delta_adj',0*delta_adj'];
SafeSet_adj=SafeSet-Residuals;

%%%%%%%%%%

% Partition (Safe-Target) into 3^dim-1 separate parts
for i = 1:dim
    D{i}=unique([SafeSet(i,1),SafeSet_adj(i,:),SafeSet(i,2)]);
    Dt{i}=D{i}(1:end-1);
end

% Construct the grid
[F{1:(dim)}]=ndgrid(Dt{:});

% Cardinality
n=numel(F{1});

% Make the output
X=zeros(0,dim*2); % Initialization of X with an empty matrix
for i=1:n
    Set=zeros(dim,2);
    C=cell(dim,1);
    delta_adj_local=zeros(1,dim);
    for j=1:dim
        Set(j,:)=[F{j}(i),D{j}(find(D{j}==F{j}(i))+1)];
        % The ndiv variable eliminates rounding errors
        ndiv=round((Set(j,2)-Set(j,1))/delta_adj(j)); 
        if ndiv==0
            ndiv=1; 
        end
        delta_adj_local(j)=(Set(j,2)-Set(j,1))/ndiv;
        C{j}=(Set(j,1)+0.5*delta_adj_local(j)):delta_adj_local(j):(Set(j,2)-0.499*delta_adj_local(j));
        % 0.499 adjusts for rounding errors; it has no influence on the
        % position of the representative points
    end
    
    % Construct the grid
    [C{1:(dim)}]=ndgrid(C{:});

    % Cardinality
    m=numel(C{1});

    % Make the output
    Y=zeros(m,dim);
    for j=1:m
        for k=1:dim
        Y(j,k)=[C{k}(j)];
        end
    end

    Y(1:m,dim+1:2*dim)=kron(delta_adj_local,ones(m,1));
    X=[X;Y];

end

clearvars C Y F D

%%%%%%%%% end of uniform grid part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cardinality
m=size(X,1);

% Extract the Target Set (creation of SafeSet minus TargetSet)
% Indexing the target set
TargetIndex=prod((X(:,1:dim)<repmat(TargetSet(:,2),1,m)').*(X(:,1:dim)>repmat(TargetSet(:,1),1,m)'),2);

% Reshape X so that the first entries are the target set
X=[X(find(TargetIndex==1),:);X(find(TargetIndex~=1),:)];

% The initial Lipschitz constants
[h_ij] = LocalLipschitz(KernelFunction,X,sum(TargetIndex)+1,m);

% The initial Lipschitz constants
[h_ij_bar] = LocalLipschitzToXbar(KernelFunction,X,sum(TargetIndex)+1,m);

% definition of h_tot
h_tot=h_ij.*repmat((sum((X(sum(TargetIndex)+1:end,dim+1:2*dim)).^2',1)).^0.5',[1,m])+h_ij_bar.*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5,[m-sum(TargetIndex),1]);

% definition of K_i
K_i=h_tot*prod(X(:,dim+1:2*dim)',1)';

% The resulting local errors
E_i = [zeros(sum(TargetIndex),1);N*K_i];

q = 1+sum(TargetIndex);
    while(sum(E_i>=epsilon)>0)
        t = length(E_i);
        for i=1:(t-q+1)
            if (E_i(q) > epsilon)
                % finding the index related to maximum dimension
                [~,m0] = max(X(q,dim+1:2*dim));
                
                % splitting the cell into two cells along its largest edge
                Y=repmat(X(q,:),2,1);
                
                % the first smaller cell
                Y(1,dim+m0) = X(q,dim+m0)/2;
                Y(1,m0) = X(q,m0) - Y(1,dim+m0)/2;
                
                % the second smaller cell
                Y(2,dim+m0) = X(q,dim+m0)/2;
                Y(2,m0) = X(q,m0) + Y(2,dim+m0)/2;
                
                % Update X
                X=[X(1:(q-1),:);X((q+1):end,:);Y];
                
                % Update E_i
                E_i=[E_i(1:(q-1));E_i((q+1):end)];
                               
            else
                q = q + 1;
            end
        end
          
        % Update local error
       
        % The updated Lipschitz constants
        [h_ij] = LocalLipschitz(KernelFunction,X,q,size(X,1));
        
        % The initial Lipschitz constants
        [h_ij_bar] = LocalLipschitzToXbar(KernelFunction,X,q,size(X,1));

        % definition of h_tot
        h_tot=h_ij.*repmat((sum((X(q:end,dim+1:2*dim)).^2',1)).^0.5',[1,size(X,1)])+h_ij_bar.*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5,[size(X,1)-q+1,1]);

        % definition of K_i
        K_i=h_tot*prod(X(:,dim+1:2*dim)',1)';

        % The resulting local errors
        if isequal(size(E_i),[2,0]) % adjust structure if E_i is empty. This avoids errors
            E_i=E_i(1,:);
        end
        E_i = [E_i;N*K_i];
        
       
    end 
    
    E=max(E_i);

end
%=================== End of function implementation =======================