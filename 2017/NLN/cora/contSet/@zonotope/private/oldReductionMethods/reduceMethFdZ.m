function [Zred,t]=reduceMethFdZ(Z)
% reduceMethFd - like method F, but with filters
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
filterLength1=dim+8;
if filterLength1>length(G(1,:))
    filterLength1=length(G(1,:));
end
filterLength2=dim+3;
if filterLength2>length(G(1,:))
    filterLength2=length(G(1,:));
end

%length filter
G=lengthFilter(G,filterLength1);

%apply generator volume filter
Gcells=generatorVolumeFilter(G,filterLength2);

%pick generator with the best volume
Gtemp=volumeFilter(Gcells,Z);
Gpicked=Gtemp{1};

%Build transformation matrix P
for i=1:dim
    P(:,i)=Gpicked(:,i);
end

%check rank of P
if rank(P)<dim
    P=P+1e-6*eye(dim);
end   

%Project Zonotope into new coordinate system
Ztrans=inv(P)*Z;
Zinterval=interval(Ztrans);
Zred=P*zonotope(Zinterval);

%time measurement
t=toc;

%------------- END OF CODE --------------
