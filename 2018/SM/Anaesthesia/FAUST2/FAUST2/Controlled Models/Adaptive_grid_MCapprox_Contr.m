
function [X,U,E] = Adaptive_grid_MCapprox_Contr(epsilon,KernelFunction,N,SafeSet,InputSet)
%Adaptive_grid_MCapprox_Contr This function makes an adaptive grid that will
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

% The Lebesgue measure
L_A=prod(r);

% The dimension of the system 
dim_u = size(InputSet,1);

% The length of the edges of the Set
u=InputSet(:,2)-InputSet(:,1);

% The Lebesgue measure
L_U=prod(u);

% Derivation of the global Lipschitz constant
h_s = GlobalLipschitzToXbar_Contr(KernelFunction,SafeSet,InputSet);

% Derivation of the global Lipschitz constant towards the input
h_u = GlobalLipschitzToU_Contr(KernelFunction,SafeSet,InputSet);

% Derivation of the global Lipschitz constant towards X
% This factor is used for the calculation of the variable optimratio
h_a = GlobalLipschitz_Contr(KernelFunction,SafeSet,InputSet);


options = optimset('Algorithm','sqp','TolFun',1e-25,'TolX',1e-10,'MaxFunEvals',2e7);
[~,solution,~,exitflag] = evalc('fmincon(@(x) -x(1)^(2*dim)*x(2)^dim_u,[0.5*epsilon/(h_s*2*L_A*N);0.5*epsilon/(h_u*2*L_A*N)],[-eye(2);2*N*L_A*h_s,2*N*L_A*h_u],[zeros(2,1);epsilon],[],[],[],[],[],options)');

% If there is no solution found, take the simple solution of splitting the
% error in two equal parts
if ~ (exitflag==1 | exitflag==2)
    solution=[L_A/((0.5*epsilon/h_s)/dim)^dim;L_U/((0.5*epsilon/h_u)/dim_u)^dim_u;0.5*epsilon/h_s;0.5*epsilon/h_u];
end

% Translate the solution to the length of the edges and define optimratio
delta_a=solution(1);
delta_u=solution(2);

factor=h_a/(h_a+h_s); % This factor acounts for the MC error in the optimal ratio
optimratio=factor*delta_a/delta_u;

delta_u=delta_u/sqrt(dim_u);
delta_a=delta_a/sqrt(dim);

% Create the location of the representative points
% delta_a is adjusted so that the edges of the set are part of the partitions
C=cell(dim,1);
for i = 1:dim
    delta_adj_a(i)=(SafeSet(i,2)-SafeSet(i,1))/ceil((SafeSet(i,2)-SafeSet(i,1))/delta_a);
    C{i}=(SafeSet(i,1)+0.5*delta_adj_a(i)):delta_adj_a(i):(SafeSet(i,2)-0.499*delta_adj_a(i));
    % 0.499 adjusts for rounding errors; it has no influence on the 
    % position of the representative points
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

X(1:m,dim+1:2*dim)=kron(delta_adj_a,ones(m,1));


% Create the location of the representative points
% delta_u is adjusted so that the edges of the set are part of the partitions
C=cell(dim_u,1);
for i = 1:dim_u
    delta_adj_u(i)=(InputSet(i,2)-InputSet(i,1))/ceil((InputSet(i,2)-InputSet(i,1))/delta_u);
    C{i}=(InputSet(i,1)+0.5*delta_adj_u(i)):delta_adj_u(i):(InputSet(i,2)-0.499*delta_adj_u(i));
    % 0.499 adjusts for rounding errors; it has no influence on the
    % position of the representative points
end

% Construct the grid
[C{1:(dim_u)}]=ndgrid(C{:});

% Cardinality
m=numel(C{1});

% Make the output

U=zeros(m,dim_u);
for i=1:m
    for j=1:dim_u
    U(i,j)=[C{j}(i)];
    end
end

U(1:m,dim_u+1:2*dim_u)=kron(delta_adj_u,ones(m,1));

clearvars C

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Cardinality
m=size(X,1);

% Cardinality of the input
q=size(U,1);

% The initial Lipschitz constants to x
[h_ijr] = LocalLipschitz_Contr(KernelFunction,X,1,m,U,1,q);

% The initial Lipschitz constants to u
[h_ijr_u] = LocalLipschitzToU_Contr(KernelFunction,X,1,m,U,1,q);

% The initial Lipschitz constants to x_bar
[h_ijr_s] = LocalLipschitzToXbar_Contr(KernelFunction,X,1,m,U,1,q);

% The local Lipschitz constants multiplied by their respective delta's
h1=[h_ijr].*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5',[1,m,q]);
h2=[h_ijr_s].*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5,[m,1,q]);
h3=[h_ijr_u].*repmat(reshape((sum((U(:,dim_u+1:2*dim_u)).^2',1)).^0.5,[1,1,q]),[m,m,1]);

% The initial error
E_ij=2*N*reshape(sum((h1+h2+h3).*repmat(prod(X(:,dim+1:2*dim)',1),[m,1,q]),2),[m,q]);

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
        
        % The Lipschitz constants to x
        [h_ijr] = LocalLipschitz_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1));

        % The Lipschitz constants to u
        [h_ijr_u] = LocalLipschitzToU_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1));

        % The Lipschitz constants to x_bar
        [h_ijr_s] = LocalLipschitzToXbar_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1));

        % The local Lipschitz constants multiplied by their respective delta's
        h1=[h_ijr].*repmat((sum((X(count_x:end,dim+1:2*dim)).^2',1)).^0.5',[1,size(X,1),size(U,1)-count_u+1]);
        h2=[h_ijr_s].*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5,[size(X,1)-count_x+1,1,size(U,1)-count_u+1]);
        h3=[h_ijr_u].*repmat(reshape((sum((U(count_u:end,dim_u+1:2*dim_u)).^2',1)).^0.5,[1,1,size(U,1)-count_u+1]),[size(X,1)-count_x+1,size(X,1),1]);

        % The new errors
        K_ij=reshape(sum((h1+h2+h3).*repmat(prod(X(:,dim+1:2*dim)',1),[size(X,1)-count_x+1,1,size(U,1)-count_u+1]),2),[size(X,1)-count_x+1,size(U,1)-count_u+1]);

        % The resulting local errors
        E_ij_aux = 2*N*(K_ij);

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
        
        % Update local error
        
        % The Lipschitz constants to x
        [h_ijr] = LocalLipschitz_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1));

        % The Lipschitz constants to u
        [h_ijr_u] = LocalLipschitzToU_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1));

        % The Lipschitz constants to x_bar
        [h_ijr_s] = LocalLipschitzToXbar_Contr(KernelFunction,X,count_x,size(X,1),U,count_u,size(U,1));

        % The local Lipschitz constants multiplied by their respective delta's
        h1=[h_ijr].*repmat((sum((X(count_x:end,dim+1:2*dim)).^2',1)).^0.5',[1,size(X,1),size(U,1)-count_u+1]);
        h2=[h_ijr_s].*repmat((sum((X(:,dim+1:2*dim)).^2',1)).^0.5,[size(X,1)-count_x+1,1,size(U,1)-count_u+1]);
        h3=[h_ijr_u].*repmat(reshape((sum((U(count_u:end,dim_u+1:2*dim_u)).^2',1)).^0.5,[1,1,size(U,1)-count_u+1]),[size(X,1)-count_x+1,size(X,1),1]);

        % The new errors
        K_ij=reshape(sum((h1+h2+h3).*repmat(prod(X(:,dim+1:2*dim)',1),[size(X,1)-count_x+1,1,size(U,1)-count_u+1]),2),[size(X,1)-count_x+1,size(U,1)-count_u+1]);

        % The resulting local errors
        E_ij_aux = 2*N*(K_ij);

        % The resulting local errors
        E_ij(count_x:size(X,1),count_u:size(U,1))=E_ij_aux;
    end
end

E=max(E_ij(:));



end
%=================== End of function implementation =======================

    
