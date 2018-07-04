function [Pred,t]=reduceMethI(Z)
% reduceMethI - similar to method H, but with coordinate transformation
% motivated from method F
%
% Syntax:  
%    [Pred,t]=reduceMethH(Z)
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
% Written: 15-September-2008 
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
filterLength2=dim+3;

%length filter
G=lengthFilter(G,filterLength1);

%apply generator volume filter
Gcells=generatorVolumeFilter(G,filterLength2);

%pick generator with the best volume
Gtemp=volumeFilter(Gcells,Z);
Gpicked=Gtemp{1};

%Build transformation matrix P
for i=1:dim
    P(:,i)=Gpicked(:,i)/norm(Gpicked(:,i));
end

%Project Zonotope into new coordinate system
Ztrans=inv(P)*Z;

%apply method H
Pred=reduceMethH(Ztrans);

%transform result back to the original coordinate system
Pred=range(Pred,P);

%time measurement
t=toc;


%------------- END OF CODE --------------
