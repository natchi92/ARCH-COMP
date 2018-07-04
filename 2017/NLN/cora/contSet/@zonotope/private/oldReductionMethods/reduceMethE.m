function [Pred,t]=reduceMethE(Z)
% reduceMethE - Reduce with Girard method and add hyperbox
%
% Syntax:  
%    [Pred]=reduceMethE(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    Pred - polytope of reduced zonotope
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author: Matthias Althoff
% Written: 15-September-2007 
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

tic;

%reduce zonotope to order 2
Zred=reduceGirard(Z,2);

%seperate parallelpiped from hyperbox
Zmatrix=get(Zred,'Z');
%determine dimension of zonotope
[dim,nrOfGen]=size(Zmatrix);
Zparallel=zonotope(Zmatrix(:,1:(dim+1)));
Zbox=zonotope([Zmatrix(:,1),Zmatrix(:,(dim+2):end)]);

%generate polytopes
Pparallel=parallelpiped(Zparallel);
Pbox=parallelpiped(Zbox);
Pred=Pparallel+Pbox;

%time measurement
t=toc;


%------------- END OF CODE --------------
