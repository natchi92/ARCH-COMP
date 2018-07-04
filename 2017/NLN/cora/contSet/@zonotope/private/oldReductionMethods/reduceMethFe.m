function [Pred,t]=reduceMethFe(Z)
% reduceMethD - like method D, but computes the exact volume directly
%
% Syntax:  
%    [Pred]=reduceMethD(Z)
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
% Written: 11-September-2008
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
origLength=length(Zmatrix(1,:))-1;
filterLength3=dim+3;
filterLength2=dim+8;
filterLength1=filterLength2+floor((origLength-filterLength2)/2);

if filterLength1>origLength
    filterLength1=origLength;
elseif filterLength2>origLength
    filterLength2=origLength;
elseif filterLength3>origLength
    filterLength3=origLength;
end

%length filter
G=lengthFilter(G,filterLength1);

%kmeans filter
G=kmeansFilter(G,filterLength2);

%generator volume filter
Gcells=generatorVolumeFilter(G,filterLength3);

%pick generator with the best volume
Gtemp=volumeFilter(Gcells,Z);
Gpicked=Gtemp{1};

%Build transformation matrix P
for i=1:dim
    P(:,i)=Gpicked(:,i);
end

%Project Zonotope into new coordinate system
Ztrans=inv(P)*Z;
Zinterval=interval(Ztrans);
Zred=P*zonotope(Zinterval);

%generate polytopes
Pred=parallelpiped(Zred);

%time measurement
t=toc;

%------------- END OF CODE --------------
