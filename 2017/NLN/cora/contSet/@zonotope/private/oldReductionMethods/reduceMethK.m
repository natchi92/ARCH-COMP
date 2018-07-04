function [Pred,t]=reduceMethK(Z,additionalGens)
% reduceMethK - does not reduce to parallelotopes, but to zonotopes of
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

%determine filter length
filterLength1=dim+8;
if filterLength1>length(G(1,:))
    filterLength1=length(G(1,:));
end
filterLength2=dim+3;
if filterLength2>length(G(1,:))
    filterLength2=length(G(1,:));
end

%length filter
[G,Zlength]=lengthFilterN(G,filterLength1,additionalGens);

%apply generator volume filter
[Gred,Zrem]=generatorVolumeFilterN(G,filterLength2,additionalGens);
for i=1:length(Zrem)
    Ztotal{i}=Zlength+Zrem{i};
end

%pick generator with the best volume
Zred=volumeFilterN(Gred,Ztotal); 

%transform to polytope
Pred=polytope(Zred);

%time measurement
t=toc;


%------------- END OF CODE --------------
