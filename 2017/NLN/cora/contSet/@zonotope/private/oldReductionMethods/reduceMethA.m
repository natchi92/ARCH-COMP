function [Pred,t]=reduceMethA(Z)
% reduceMethA - Reduce zonotope and convert to zonotope using longest
% generators and a bounding box
%
% Syntax:  
%    [Pred]=reduceMethA(Z)
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

%initialize Z_red
Zred=Z;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');

%extract generator matrix
G=Zmatrix(:,2:end);

%determine dimension of zonotope
dim=length(G(:,1));

%Delete zero-generators
i=1;
while i<=length(G(1,:))
    if G(:,i)==0*G(:,i)
        G(:,i)=[];
    else
        i=i+1;
    end
end

%determine generators
for i=1:length(G(1,:))
    h(i)=norm(G(:,i)'*G,1);
end
[value,index]=sort(h);
Gpicked=G(:,index((end-dim+1):end));

%Build transformation matrix P
for i=1:dim
    P(:,i)=Gpicked(:,i)/norm(Gpicked(:,i));
end

%Project Zonotope into new coordinate system
Ztrans=inv(P)*Z;
Zinterval=interval(Ztrans);
Zred=P*zonotope(Zinterval);

%determine bounding box
Zbound=reduceGirard(Z,1);

%generate polytopes
Pred=parallelpiped(Zred);
Pbound=parallelpiped(Zbound);

%intersect both solutions
Pred=Pred&Pbound;

%time measurement
t=toc;

%------------- END OF CODE --------------
