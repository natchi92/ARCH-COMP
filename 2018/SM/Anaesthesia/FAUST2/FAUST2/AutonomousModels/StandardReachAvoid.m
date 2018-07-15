function [W] = StandardReachAvoid(N,Tp,X,TargetSet)
%STANDARDREACHAVOID: Computes the reach avoid probability given N time steps and
%the transition matrix Tp.
%   The input needs to be: N=number of time steps and Tp the transition
%   probabilities of the markov chain. Tp should be a (m by m)
%   transition matrix. With m the cardinality of the partition
%   defined in X

% The cardinality
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% Initialization of value function W
W=prod((X(:,1:dim)<repmat(TargetSet(:,2),1,m)').*(X(:,1:dim)>repmat(TargetSet(:,1),1,m)'),2);

% Matrices used for the calculation of W
W_help1=1-W;
W_help2=W;

% The solution
for i=1:N
  W=(Tp*W).*W_help1+W_help2;
end


