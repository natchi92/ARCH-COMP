function [Zred]=reduceParallelpipedDimensionwise(Z)
% reduceMethB - Reduce zonotope using generators
% that span the paralellpiped with the biggest volume
%
% Syntax:  
%    [Zred]=reduceParallelpiped(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    Zred - reduced zonotope
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author: Matthias Althoff
% Written: 17-January-2008
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

%in a first step only for zonotopes of even dimension (2,4,6,...)

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');

dim=length(Zmatrix(:,1));
steps=dim/2;

for i=1:steps
    pos=(2*i-1):2*i;
    Z2dim=zonotope(Zmatrix(pos,:));
    Zred=reduceParallelpiped(Z2dim);
    
    %get Z-matrix
    Z=get(Zred,'Z');
    
    %insert center
    Znew(pos,1)=Z(:,1);
    %insert generators
    Znew(pos,1+pos)=Z(:,2:3);
end
Zred=zonotope(Znew);

%------------- END OF CODE --------------
