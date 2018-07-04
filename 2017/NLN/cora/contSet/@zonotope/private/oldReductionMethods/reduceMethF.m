function [Pred,t]=reduceMethF(Z)
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

% Author:       Matthias Althoff
% Written:      11-September-2008
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

%prefilter generators
for i=1:length(G(1,:))
    h(i)=norm(G(:,i)'*G,1);
end
[value,indexFiltered]=sort(h);
Gfiltered=G(:,indexFiltered((end-2*dim+1):end));

%determine generators by volume maximation:
%possible combinations of n=dim generators from all generators
comb = combinator(length(Gfiltered(1,:)),dim,'c');
nrOfComb=length(comb(:,1));

for i=1:nrOfComb
    
    %Build transformation matrix P
    Gpicked=Gfiltered(:,comb(i,:));
    for j=1:dim
        P(:,j)=Gpicked(:,j)/norm(Gpicked(:,j));
    end    
    %compute reduced zonotope
    Ztrans=inv(P)*Z;
    Zinterval=interval(Ztrans);
    Zred=P*zonotope(Zinterval);
    %compute volume
    parallelogramVol(i)=volume(Zred);
end

[val,index]=sort(parallelogramVol);
generatorIndices=comb(index(1),:);
Gpicked=Gfiltered(:,generatorIndices);

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
