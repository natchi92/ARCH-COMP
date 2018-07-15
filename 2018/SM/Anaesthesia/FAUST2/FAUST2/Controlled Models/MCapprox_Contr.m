function [Tp] = MCapprox_Contr(KernelFunction,X,U)
%MCAPPROX_CONTR Creates the Markov Chain that corresponds to the representative
%points contained in X. 
%   KernelFunction is the name of the kernel function. This input must
%   be a string.
%   X is a matrix input which consists of the centres of the cell as well
%   as the length of the edges.
%   The output Tp is a m by m matrix, where m equals the cardinality of the
%   partition defined in X.


% Cardinality
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Cardinality of the input
q=size(U,1);

% Dimension of the input
dim_u=size(U,2)/2;

% Calculation of the pointwise transition probabilities
try %This is the fast but memory expensive way
    p=cell(1,2*dim+dim_u);
    for i=1:dim
        p{i}=ndgrid(X(:,i),ones(1,m),ones(1,q));
    end
    for i=dim+1:2*dim
        [~,p{i},~]=ndgrid(ones(1,m),X(:,i-dim)',ones(1,q));
    end
    for i=2*dim+1:2*dim+dim_u
        [~,~,p{i}]=ndgrid(ones(1,m),ones(1,m),U(:,i-2*dim));
    end
    h = msgbox('Creation of the Markov Chain in Progress');
    Tp=KernelFunction(p{:});
    close(h);
catch %This is the slower but less memory expensive way
    clearvars p
    Tp=zeros(m,m,q);
    h = waitbar(0,'Creation of the Markov Chain');
    for i=1:m
        waitbar(i/m,h);
        for j=1:m
            for k=1:q
                p1=num2cell(X(i,1:dim));
                p2=num2cell(X(j,1:dim));
                p3=num2cell(U(k,1:dim_u));
                Tp(i,j,k)=KernelFunction(p1{:},p2{:},p3{:});
            end
        end
    end
    close(h);
end

% Make Tp transition probabilities by multiplying with the Lebesque measure 
[~,L_A,~]=ndgrid(ones(m,1),prod(X(:,dim+1:2*dim)',1),ones(q,1));
Tp=Tp.*L_A;

end
%=================== End of function implementation =======================

