
function [X,E] = Adaptive_grid_multicell(epsilon,KernelFunction,N,X)
%Adaptive_grid_multicell This function makes an adaptive grid that will
%produce a certain maximal abstraction error defined by epsilon. 
%   Input of this function is the desired maximal error epsilon, the kernel
%   function, the number of time steps N and the upper and an initial
%   partition X.
%   The output is a new partition X and a maximum error

% Dimension of the system
dim=size(X,2)/2;

% The initial Lipschitz constants
[h_ij] = LocalLipschitz(KernelFunction,X);

% definition of gamma_i
gamma_i=N*h_ij*prod(X(:,dim+1:2*dim)',1)';

% The resulting local errors
E_i = gamma_i.*(sum((X(:,dim+1:2*dim)).^2',1)).^0.5';

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
                
                if(size(X,1) == 31)
                    q
                end
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
        if isequal(size(E_i),[2,0]) % adjust structure if E_i is empty. This avoids errors
            E_i=E_i(1,:);
        end
        E_i = [E_i;gamma_i.*(sum((X(q:size(X,1),dim+1:2*dim)).^2',1)).^0.5'];
        
       
    end 
    
    E=max(E_i);

end
%=================== End of function implementation =======================