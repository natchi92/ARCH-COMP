
function [V] = StandardProbSafety(N,Tp)
%StandardProbSafety: Computes the safety probability given N time steps and
%the transition matrix Tp.
%   The input needs to be: N=number of time steps and Tp the transition
%   probabilities of the markov chain. Tp should be a (dim by dim)
%   2-dimensional transition matrix.


% The cardinality
m=size(Tp,1);

% The solution
V=ones(m,1);
V=Tp^N*V;

end
