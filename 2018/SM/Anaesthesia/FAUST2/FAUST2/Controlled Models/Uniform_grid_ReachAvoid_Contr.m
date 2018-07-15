function [X,U,E] = Uniform_grid_ReachAvoid_Contr(epsilon,KernelFunction,N,SafeSet,TargetSet,InputSet)
%UNIFORM_GRID_REACHAVOID_CONTR This function makes a uniform grid that will produce a
%certain maximal abstraction error defined by E=delta*h*N*L(A). Here L(A)
%denotes the Lebesgue measure of the set A, N the number of time steps, h 
%is the global Lipschitz constant and delta the dimension of the cells.
%   Input of this function is the desired maxmial error epsilon, the 
%   KernelFunction, the number of time steps N and the upper and
%   lower bounds of the (Safe)Set. 
%   The output X is a matrix, which consists of the centres of the cell as well
%   as the length of the edges.

% The dimension of the system 
dim = size(SafeSet,1);

% The length of the edges of the Safe Set
rS=SafeSet(:,2)-SafeSet(:,1);

% The length of the edges of the Target Set
rT=TargetSet(:,2)-TargetSet(:,1);

% The Lebesgue measure
L_A=prod(rS);

% The dimension of the system 
dim_u = size(InputSet,1);

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
    solution=[L_A/((0.5*epsilon/h_a)/dim)^dim;L_U/((0.5*epsilon/h_u)/dim_u)^dim_u;0.5*epsilon/h_a;0.5*epsilon/h_u];
end

% Translate the solution to the length of the edges
delta_a=solution(1);
delta_a=delta_a/sqrt(dim);
delta_u=solution(2);
delta_u=delta_u/sqrt(dim_u);


% delta is adjusted so that the edges of the TargetSet are part of the partitions
for i = 1:dim
    delta_adj_a(i)=(TargetSet(i,2)-TargetSet(i,1))/ceil((TargetSet(i,2)-TargetSet(i,1))/delta_a);
end


% The adjusted SafeSet to fit with delta_adj
Residuals=mod((SafeSet-TargetSet),repmat(delta_adj_a',1,2))+[-delta_adj_a',0*delta_adj_a'];
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
        ndiv=round((Set(j,2)-Set(j,1))/delta_adj_a(j)); 
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




% The error made 
% The factor 2 comes from the fact that the system is controlled and the
% control based on the abstracted system is applied to the original system
E=(h_u*sqrt(sum(delta_adj_u.^2))+h_a*sqrt(sum(delta_adj_a.^2)))*L_A*N*2;

end


