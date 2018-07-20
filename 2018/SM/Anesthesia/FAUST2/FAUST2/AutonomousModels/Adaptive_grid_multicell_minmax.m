
function [X,E] = Adaptive_grid_multicell_minmax(epsilon,KernelFunction,N,SafeSet)
%Adaptive_grid_multicell_minmax This function makes an adaptive grid that will
%produce a certain maximal abstraction error defined by epsilon. 
%   Input of this function is the desired maximal error epsilon, the kernel
%   function, the number of time steps N and the upper and an initial
%   partition X (which is a structure).
%   The output is a cell structure and a maximum error

%%%%%%%%%%%%%%%%%%%%%%%%%%% Uniform part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The dimension of the system 
dim = size(SafeSet,1);

% The length of the edges of the Set
r=SafeSet(:,2)-SafeSet(:,1);

% Derivation of the global Lipschitz constant
hbar = GlobalLipschitzToXbar(KernelFunction,SafeSet);

% The length of the edges of the partitions
delta=(epsilon/(prod(r)*hbar*N))/sqrt(dim);

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
    delta_adj(i)=(SafeSet(i,2)-SafeSet(i,1))/ceil((SafeSet(i,2)-SafeSet(i,1))/delta);
    C{i}=(SafeSet(i,1)+0.5*delta_adj(i)):delta_adj(i):(SafeSet(i,2)-0.5*delta_adj(i));
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

clearvars C

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The initial Lipschitz constants (from X(n).cell to all X.cell)
[k_ij] = Minmax(KernelFunction,X);

% The resulting local errors
E_i=N*k_ij*prod(X(:,dim+1:2*dim)',1)';

q = 1;
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
        [k_ij] = Minmax(KernelFunction,X,q,size(X,1));

        % The resulting local errors
        if isequal(size(E_i),[2,0]) % adjust structure if E_i is empty. This avoids errors
            E_i=E_i(1,:);
        end
        E_i = [E_i;N*k_ij*prod(X(:,dim+1:2*dim)',1)'];
      
    end 
    
    E=max(E_i);

end
%=================== End of function implementation =======================