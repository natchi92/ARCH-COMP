
function [X,E] = Adaptive_grid_MCapprox(epsilon,KernelFunction,N,SafeSet)
%Adaptive_grid_MCapprox This function makes an adaptive grid that will
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

% Derivation of the global Lipschitz constant
h = GlobalLipschitzToXbar(KernelFunction,SafeSet);

% The length of the edges of the partitions
delta=(epsilon/(prod(r)*h*N))/sqrt(dim);

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

%%%%%%%%% end of uniform grid part %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The initial Lipschitz constants
[h_ij] = LocalLipschitz(KernelFunction,X);

% The initial Lipschitz constants
[h_ij_bar] = LocalLipschitzToXbar(KernelFunction,X);

% definition of h_tot
h_tot=h_ij.*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5',[1,m])+h_ij_bar.*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5,[m,1]);

% definition of K_i
K_i=h_tot*prod(X(:,dim+1:2*dim)',1)';

% The resulting local errors
E_i = N*K_i;

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