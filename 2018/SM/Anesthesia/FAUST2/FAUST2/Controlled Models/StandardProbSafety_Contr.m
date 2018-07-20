function [V,OptimPol] = StandardProbSafety_Contr(N,Tp)
%StandardProbSafety_Contr: Computes the safety probability given N time steps and
%the transition matrix Tp.
%   The input needs to be: N=number of time steps and Tp the transition
%   probabilities of the markov chain.

% The cardinality of X
m=size(Tp,1);

% The cardinality of U
q=size(Tp,3);


% The solution
V=ones(m,1);

for i=N:-1:1
    V_aux=sum(Tp.*repmat(V',[m,1,q]),2);
    [V,OptimPol(:,i)]=max(V_aux,[],3);
end


end
