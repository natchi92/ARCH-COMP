
function [X,U,E] = Adaptive_grid_multicell_semilocal_Contr(epsilon,KernelFunction,N,X,U,SafeSet,InputSet)
%Adaptive_grid_multicell_semilocal_Contr This function makes an adaptive grid that will
%produce a certain maximal abstraction error defined by epsilon. 
%   Input of this function is the desired maximal error epsilon, the kernel
%   function, the number of time steps N and the upper and an initial
%   partition X
%   The output is a new partition X, a new partition U and a maximum error

% The dimension of the system 
dim = size(SafeSet,1);

% The dimension of the system 
dim_u = size(InputSet,1);

% Cardinality
m=size(X,1);

% Cardinality of the input
q=size(U,1);



%%%%%%% part to find the optimal ratio between delta_a and delta_u %%%%%%%

% The length of the edges of the Set
r=SafeSet(:,2)-SafeSet(:,1);

% The Lebesgue measure
L_A=prod(r);

% The length of the edges of the Set
u=InputSet(:,2)-InputSet(:,1);

% The Lebesgue measure
L_U=prod(u);

% Derivation of the global Lipschitz constant
h_a = GlobalLipschitz_Contr(KernelFunction,SafeSet,InputSet);

% Derivation of the global Lipschitz constant towards the input
h_u = GlobalLipschitzToU_Contr(KernelFunction,SafeSet,InputSet);


options = optimset('Algorithm','sqp','TolFun',1e-25,'TolX',1e-10,'MaxFunEvals',2e7);
[~,solution,~,exitflag] = evalc('fmincon(@(x) -x(1)^(2*dim)*x(2)^dim_u,[0.5*epsilon/(h_a*2*L_A*N);0.5*epsilon/(h_u*2*L_A*N)],[-eye(2);2*N*L_A*h_a,2*N*L_A*h_u],[zeros(2,1);epsilon],[],[],[],[],[],options)');

% If there is no solution found, take the simple solution of splitting the
% error in two equal parts
if ~ (exitflag==1 | exitflag==2)
    solution=[0.5*epsilon/(h_a*2*L_A*N);0.5*epsilon/(h_u*2*L_A*N)];
end

% Translate the solution to the optimal ratio
delta_a=solution(1);
delta_u=solution(2);
optimratio=delta_a/delta_u;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% The initial Lipschitz constants to x
[h_ir] = SemiLocalLipschitz_Contr(KernelFunction,X,1,m,U,1,q,SafeSet);

% The initial Lipschitz constants to u
[h_ir_u] = SemiLocalLipschitzToU_Contr(KernelFunction,X,1,m,U,1,q,SafeSet);

% definition of K_ij
K_ij=h_ir*L_A;

% definition of K_ij_u
K_ij_u=h_ir_u*L_A;

% The resulting local errors
E_ij = 2*N*(K_ij.*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5',[1,q])+K_ij_u.*repmat((sum((U(:,dim_u+1:2*dim_u)).^2',1)).^0.5,[m,1]));

% Initalization counters
count_x = 1;
count_u = 1;

while(sum(sum(E_ij>=epsilon)>0))
    ratio=(min((sum((X(:,dim+1:2*dim)).^2',1)).^0.5))/(min((sum((U(:,dim_u+1:2*dim_u)).^2',1)).^0.5));
    if ratio>optimratio % Chooses to split either U or X
        t = size(E_ij,1);
        for i=1:(t-count_x+1)
            if sum(E_ij(count_x,:) > epsilon)
                % finding the index related to maximum dimension
                [~,m0] = max(X(count_x,dim+1:2*dim));

                % splitting the cell into two cells along its largest edge
                Y=repmat(X(count_x,:),2,1);

                % the first smaller cell
                Y(1,dim+m0) = X(count_x,dim+m0)/2;
                Y(1,m0) = X(count_x,m0) - Y(1,dim+m0)/2;

                % the second smaller cell
                Y(2,dim+m0) = X(count_x,dim+m0)/2;
                Y(2,m0) = X(count_x,m0) + Y(2,dim+m0)/2;

                % Update X
                X=[X(1:(count_x-1),:);X((count_x+1):end,:);Y];

                % Update E_i
                E_ij=[E_ij(1:(count_x-1),:);E_ij((count_x+1):end,:)];

            else
                count_x = count_x + 1;
            end
        end

        % Update local error

        % The initial Lipschitz constants to x
        [h_ir] = SemiLocalLipschitz_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1),SafeSet);

        % The initial Lipschitz constants to u
        [h_ir_u] = SemiLocalLipschitzToU_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1),SafeSet);

        % definition of K_ij
        K_ij=h_ir*L_A;

        % definition of K_ij_u
        K_ij_u=h_ir_u*L_A;
        
        % The resulting local errors
        E_ij_aux = 2*N*(K_ij.*repmat((sum((X(count_x:size(X,1),dim+1:2*dim)).^2',1)).^0.5',[1,size(U,1)-count_u+1])+K_ij_u.*repmat((sum((U(count_u:size(U,1),dim_u+1:2*dim_u)).^2',1)).^0.5,[size(X,1)-count_x+1,1]));

        % The resulting local errors
        E_ij(count_x:size(X,1),count_u:size(U,1))=E_ij_aux;


    %%%%%%%%%%%%%%%%%%%%%%%%%
    else
        t = size(E_ij,2);
        for i=1:(t-count_u+1)
            if sum(E_ij(:,count_u) > epsilon)
                % finding the index related to maximum dimension
                [~,m0] = max(U(count_u,dim_u+1:2*dim_u));

                % splitting the cell into two cells along its largest edge
                Z=repmat(U(count_u,:),2,1);

                % the first smaller cell
                Z(1,dim_u+m0) = U(count_u,dim_u+m0)/2;
                Z(1,m0) = U(count_u,m0) - Z(1,dim_u+m0)/2;

                % the second smaller cell
                Z(2,dim_u+m0) = U(count_u,dim_u+m0)/2;
                Z(2,m0) = U(count_u,m0) + Z(2,dim_u+m0)/2;

                % Update U
                U=[U(1:(count_u-1),:);U((count_u+1):end,:);Z];

                % Update E_i
                E_ij=[E_ij(:,1:(count_u-1)),E_ij(:,(count_u+1):end)];

            else
                count_u = count_u + 1;
            end
        end

        % The initial Lipschitz constants to x
        [h_ir] = SemiLocalLipschitz_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1),SafeSet);

        % The initial Lipschitz constants to u
        [h_ir_u] = SemiLocalLipschitzToU_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1),SafeSet);

        % definition of K_ij
        K_ij=h_ir*L_A;

        % definition of K_ij_u
        K_ij_u=h_ir_u*L_A;
        
        % The resulting local errors
        E_ij_aux = 2*N*(K_ij.*repmat((sum((X(count_x:size(X,1),dim+1:2*dim)).^2',1)).^0.5',[1,size(U,1)-count_u+1])+K_ij_u.*repmat((sum((U(count_u:end,dim_u+1:2*dim_u)).^2',1)).^0.5,[size(X,1)-count_x+1,1]));

        % The resulting local errors
        E_ij(count_x:size(X,1),count_u:size(U,1))=E_ij_aux;

    end
end

E=max(E_ij(:));



end
%=================== End of function implementation =======================

    
