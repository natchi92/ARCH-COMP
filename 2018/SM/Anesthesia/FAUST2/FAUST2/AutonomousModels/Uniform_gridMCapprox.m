
function [X,E] = Uniform_gridMCapprox(epsilon,KernelFunction,N,Set)
%UNIFORM_GRIDMCAPPROX This function makes a uniform grid that will produce a
%certain maximal abstraction error defined by E=delta*(h+hbar)*N*L(A). Here L(A)
%denotes the Lebesgue measure of the set A, N the number of time steps, h 
%is the global Lipschitz constant with respect to x, while hbar is the 
%global Lipschitz constant with respect to xbar.
%delta is measure of the dimension of the cells.  
%   Input of this function is the desired maxmial error epsilon, the 
%   KernelFunction, the number of time steps N and the upper and
%   lower bounds of the (Safe)Set. 
%   The output X is a matrix, which consists of the centres of the cell as well
%   as the length of the edges.


% The dimension of the system 
dim = size(Set,1);

% The length of the edges of the Set
r=Set(:,2)-Set(:,1);

% Derivation of the global Lipschitz constants
h = GlobalLipschitz(KernelFunction,Set);
hbar = GlobalLipschitzToXbar(KernelFunction,Set);

% The length of the edges of the partitions
delta=(epsilon/(prod(r)*(h+hbar)*N))/sqrt(dim);

% Adjust delta if it is very large compared to r
while prod(ceil(r/delta))< (2^dim+10) % appr number of bins
    delta=delta/(2^(1/dim)); % This will cause the number of cells to double
end
    

% Warn if a dimension of the set has not been partitioned.
% This implies that in this direction no gradient will be found
if sum((r-delta)<0)>0
    warning('A dimension of the set has not been partitioned, reshaping the set might solve this issue')
end


% Create the location of the representative points
% delta is adjusted so that the edges of the set are part of the partitions
C=cell(dim,1);
for i = 1:dim
    delta_adj(i)=(Set(i,2)-Set(i,1))/ceil((Set(i,2)-Set(i,1))/delta);
    C{i}=(Set(i,1)+0.5*delta_adj(i)):delta_adj(i):(Set(i,2)-0.5*delta_adj(i));
end

% Construct the grid
[C{1:(dim)}]=ndgrid(C{:});

% Cardinality
m=numel(C{1});

% Make the output

X=zeros(m,dim);
for i=1:m
    for j=1:dim
    X(i,j)=[C{j}(i)];
    end
end

X(1:m,dim+1:2*dim)=kron(delta_adj,ones(m,1));


% The error made 
E=sqrt(sum(delta_adj.^2))*(prod(r)*(h+hbar)*N);

end
%=================== End of function implementation =======================