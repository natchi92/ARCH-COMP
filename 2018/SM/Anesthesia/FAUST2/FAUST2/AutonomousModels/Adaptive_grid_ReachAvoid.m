
function [X,E] = Adaptive_grid_ReachAvoid(epsilon,KernelFunction,N,X,TargetSet)
%Adaptive_GRID_ReachAvoid This function makes an adaptive grid that will produce a
%certain maximal abstraction error defined by epsilon. Here L(A)
%denotes the Lebesgue measure of the set A, N the number of time steps, h 
%is the global Lipschitz constant and delta the dimension of the cells.  
%   Input of this function is the desired maxmial error epsilon, the global
%   Lipschitz constant h, the number of time steps N, the upper and
%   lower bounds of the Set and an initial partition X.
%   The output is X, which is a matrix which consists of the centres of the cell as well
%   as the length of the edges. Also the maximum error E is a possible
%   output.

% Cardinality
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Extract the Target Set (creation of SafeSet minus TargetSet)
% Indexing the target set
TargetIndex=prod((X(:,1:dim)<repmat(TargetSet(:,2),1,m)').*(X(:,1:dim)>repmat(TargetSet(:,1),1,m)'),2);

% Reshape X so that the first entries are the target set
X=[X(find(TargetIndex==1),:);X(find(TargetIndex~=1),:)];

% The initial Lipschitz constants
[h_ij] = LocalLipschitz(KernelFunction,X,sum(TargetIndex)+1,m);

% definition of gamma_i
gamma_i=N*h_ij*prod(X(:,dim+1:2*dim)',1)';

% The resulting local errors
E_i = [zeros(sum(TargetIndex),1);gamma_i.*(sum((X((sum(TargetIndex)+1):m,dim+1:2*dim)).^2')).^0.5'];

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

        % definition of gamma_i
        gamma_i=N*h_ij*prod(X(:,dim+1:2*dim)',1)';

        % The resulting local errors
        E_i = [E_i;gamma_i.*(sum((X(q:size(X,1),dim+1:2*dim)).^2',1)).^0.5'];
        
       
    end 
    
    E=max(E_i);


end
%=================== End of function implementation =======================