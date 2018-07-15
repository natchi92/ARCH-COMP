function [Tp] = MCapprox(KernelFunction,X)
%MCAPPROX Creates the Markov Chain that corresponds to the representative
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

% Calculation of the pointwise transition probabilities
try %This is the fast but memory expensive way
    p=cell(1,2*dim);
    for i=1:dim
        p{i}=kron(X(:,i),ones(1,m));
    end
    for i=dim+1:2*dim
        p{i}=kron(X(:,i-dim)',ones(m,1));
    end
    h = msgbox('Creation of the Markov Chain in Progress');
    Tp=KernelFunction(p{:});
    close(h);
catch %This is the slower but less memory expensive way
    clearvars p
    Tp=zeros(m,m);
    h = waitbar(0,'Creation of the Markov Chain');
    for i=1:m
        waitbar(i/m,h);
        for j=1:m
            p1=num2cell(X(i,1:dim));
            p2=num2cell(X(j,1:dim));
            Tp(i,j)=KernelFunction(p1{:},p2{:});
        end
    end
    close(h);
end

% Make Tp transition probabilities by multiplying with the Lebesque measure 
Tp=Tp.*kron(prod(X(:,dim+1:2*dim)',1),ones(m,1));

end
%=================== End of function implementation =======================

