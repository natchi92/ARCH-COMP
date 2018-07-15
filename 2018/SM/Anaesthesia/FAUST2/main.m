function main(N,epsilon)
clear;
addContainingDirAndSubDir;


%---------------------------------------------------------
% Define  
%---------------------------------------------------------
norm   = 4.2;

% Anesthesia model dynamics 

sigma(1,1) = (5/norm)*sqrt(20);
sigma(2,2) = (5/norm)*sqrt(20);
sigma(3,3) = (5/norm)*sqrt(20);
A = [0.8192   0.0341   0.0126;
     0.0165   0.9822   0.0001;
     0.0009   1e-4     0.9989];

B = [0.0188;0.0002; 1e-5].*7;

% Decouple noise
L = sqrtm(inv(sigma*sigma'))
B = L*B;
A = L*A/L;

KernelFunction =  eval(['NormDistSymb_Contr(',mat2str(A),',',mat2str(B),',',mat2str(L*sigma),')']);
alpha(1,1) = 1;
alpha(2,2) = 1;
alpha(3,3) = 1;

tic;
%---------------------------------------------------------
% Define Safe & Input Set
%---------------------------------------------------------
SafeSet = [1/norm 6/norm; 0 10/norm; 0 10/norm ];
InputSet = [0 7/7];

%-------------------------------------------------------
% 2. Perform gridding 
%along each dimension and check if
% synthesis can be performed
%---------------------------------------------------------

%%%%% Compute Lipschitz constants
% The dimension of the system 
dim = size(SafeSet,1);

% The length of the edges of the Set
r=SafeSet(:,2)-SafeSet(:,1);

% The Lebesgue measure
L_A=prod(r);
%small L,vary sigma

% The dimension of the system 
dim_u = size(InputSet,1);

% The length of the edges of the Set
u=InputSet(:,2)-InputSet(:,1);

% The Lebesgue measure
L_U=prod(u);

h_a =   (alpha(1,1)*exp(-0.5))/(sqrt(2*pi)*sigma(1,1)^2) + (alpha(2,2)*exp(-0.5))/(sqrt(2*pi)*sigma(2,2)^2) + (alpha(3,3)*exp(-0.5))/(sqrt(2*pi)*sigma(3,3)^2)


h_u = 0;

delta_a = epsilon/h_a
%delta_a=delta_a/sqrt(dim);

delta_u = 1;
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

% The error made 
% The factor 2 comes from the fact that the system is controlled and the
% control based on the abstracted system is applied to the original system
E=(h_u*sqrt(sum(delta_adj_u.^2))+h_a*sqrt(sum(delta_adj_a.^2)))*L_A*N*2

epsilon =epsilon*2;

[X,U,E] = Uniform_grid_Contr(epsilon,KernelFunction,N,SafeSet,InputSet);

E= 0.5*E
size(X,1)
size(U,1)

Tp=MCapprox_Contr(KernelFunction,X,U);
Tp =Tp./(1/norm);
[V,OptimPol] = StandardProbSafety_Contr(N,Tp);
V(find(V>1))= 1;
Solution = V;

X = X./(1/norm);
U = U./(1/7);

FAUST_plot;
save('FAUST_Anes.mat','epsilon','delta_a','h_a','SafeSet','OptimPol','X','U','V','Tp','E');
end
