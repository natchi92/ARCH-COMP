
function [X,E] = Uniform_grid_ReachAvoid(epsilon,KernelFunction,N,SafeSet,TargetSet)
%UNIFORM_GRID_ReachAvoid This function makes a uniform grid that will produce a
%certain maximal abstraction error defined by E=delta*h*N*L(A). Here L(A)
%denotes the Lebesgue measure of the set A, N the number of time steps, h 
%is the global Lipschitz constant and delta the dimension of the cells.  
%   Input of this function is the desired maxmial error epsilon, the 
%   KernelFunction, the number of time steps N and the upper and
%   lower bounds of the SafeSet and the TargetSet. 
%   The output X is a matrix, which consists of the centres of the cell as well
%   as the length of the edges.


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
%%%%%%%%%%

% The error made 
E=sqrt(sum(delta_adj.^2))*(prod(rS)*h*N); 



end
%=================== End of function implementation =======================