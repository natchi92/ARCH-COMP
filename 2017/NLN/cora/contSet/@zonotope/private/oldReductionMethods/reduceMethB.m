function [Pred,t]=reduceMethB(Z)
% reduceMethB - Reduce zonotope and convert to polytope using generators
% that span the paralellpiped with the biggest volume
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

% Author:       Matthias Althoff
% Written:      15-September-2007 
% Last update:  13-September-2016
% Last revision:---

%------------- BEGIN CODE --------------

tic;

%initialize Z_red
Zred=Z;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');

%extract generator matrix
G=Zmatrix(:,2:end);

%determine dimension of zonotope
[dim,nrOfGen]=size(G);

%Delete zero-generators
i=1;
while i<=length(G(1,:))
    if G(:,i)==0*G(:,i)
        G(:,i)=[];
    else
        i=i+1;
    end
end

%determine generators by volume maximation:
%possible combinations of n=dim generators from all generators
comb = combinator(nrOfGen,dim,'c');
nrOfComb=length(comb(:,1));

for i=1:nrOfComb
    parallelogramVol(i)=abs(det(G(:,comb(i,:))));
end

[val,index]=sort(parallelogramVol);
generatorIndices=comb(index(end),:);
Gpicked=G(:,generatorIndices);

%Build transformation matrix P
for i=1:dim
    P(:,i)=Gpicked(:,i)/norm(Gpicked(:,i));
end

%Project Zonotope into new coordinate system
Ztrans=inv(P)*Z;
Zinterval=interval(Ztrans);
Zred=P*zonotope(Zinterval);

%generate polytope
Pred=parallelpiped(Zred);

%time measurement
t=toc;


%------------- END OF CODE --------------
