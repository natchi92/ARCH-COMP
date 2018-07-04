function [Pred,t]=reduceMethM(Z,additionalGens)
% reduceMethM - similar to methL; does not reduce to parallelotopes, but to zonotopes of
% lower order
%
% Syntax:  
%    [Pred,t]=reduceMethK(Z,order)
%
% Inputs:
%    Z - zonotope object
%    order - order of the reduced zonotope
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
% Written: 01-October-2008 
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

tic;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');
dim=length(Zmatrix(:,1));

%extract generator matrix
G=Zmatrix(:,2:end);

%Delete zero-generators
G=nonzeroFilter(G);

%split generators
[G1,G2]=splitGens(G,additionalGens);

%instantiate zonotopes
c=zeros(dim,1);

Z1=zonotope([c,G1]);
Z2=zonotope([c,G2]);

%reduce zonotopes
Z2red=reduce(Z2,'methFdZ');

%transform to polytope
Pred=polytope(Z1+Z2red);

%time measurement
t=toc;

%t=Z1+Z2red; %<-- change here!

%------------- END OF CODE --------------
