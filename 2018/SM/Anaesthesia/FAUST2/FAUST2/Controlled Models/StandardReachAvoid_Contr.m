function [W,OptimPol] = StandardReachAvoid_Contr(N,Tp,X,TargetSet)
%STANDARDREACHAVOID_CONTR: Computes the reach avoid probability given N time steps and
%the transition matrix Tp.
%   The input needs to be: N=number of time steps and Tp the transition
%   probabilities of the markov chain.

% The cardinality
m=size(X,1);

% The cardinality of U
q=size(Tp,3);

% Dimension of the system
dim=size(X,2)/2;

% Initialization of value function W

W=prod((X(:,1:dim)<repmat(TargetSet(:,2),1,m)').*(X(:,1:dim)>repmat(TargetSet(:,1),1,m)'),2);

% Matrices used for the calculation of W
W_help1=1-W;
W_help2=W;

% The solution
for i=N:-1:1
    W_aux=sum(Tp.*repmat(W',[m,1,q]),2);
    [W,OptimPol(:,i)]=max(W_aux,[],3);
    W=W.*W_help1+W_help2;
end


