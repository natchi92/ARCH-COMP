function [Zred]=reduceParallelpiped(Z)
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

% Author:       Matthias Althoff
% Written:      04-January-2008
% Last update:  13-September-2016
% Last revision:---

%------------- BEGIN CODE --------------


%initialize Z_red
Zred=Z;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');

%extract generator matrix
G=Zmatrix(:,2:end);

%Delete zero-generators
i=1;
while i<=length(G(1,:))
    if G(:,i)==0*G(:,i)
        G(:,i)=[];
    else
        i=i+1;
    end
end

%determine dimension of zonotope
[dim,nrOfGen]=size(G);


%prefilter generators
for i=1:length(G(1,:))
    %h(i)=norm(G(:,i)'*G,1);
    h(i)=norm(G(:,i)); %<--- changed
end
[value,indexFiltered]=sort(h);

%get length of n longest generator
try
    nLongestLength=0.5*value(end-dim+1); %<--- changed
catch
    nLongestLength=0.5*value(1); %<--- changed
end
    
%number of prefiltered generators
r=2*dim; %<-- important parametrisation
%if enough generators->prefilter
if nrOfGen>r    
    %Gfiltered=G(:,indexFiltered((end-r+1):end));
    Gfiltered=G(:,indexFiltered((end-r):end)); %<--- changed    
else
    Gfiltered=G;
end

%extend Gfiltered by identity matrix of length nLongestLength
Gfiltered=[Gfiltered,nLongestLength*eye(dim)];

%determine generators by volume maximation:
%possible combinations of n=dim generators from all generators
comb = combinator(length(Gfiltered(1,:)),dim,'c');
nrOfComb=length(comb(:,1));

for i=1:nrOfComb
    parallelogramVol(i)=abs(det(Gfiltered(:,comb(i,:))));
end

[val,index]=sort(parallelogramVol);
generatorIndices=comb(index(end),:);
Gpicked=Gfiltered(:,generatorIndices);

%Build transformation matrix P
for i=1:dim
    P(:,i)=Gpicked(:,i)/norm(Gpicked(:,i));
end

%Project Zonotope into new coordinate system
Ztrans=inv(P)*Z;
Zinterval=interval(Ztrans);
Zred=P*zonotope(Zinterval);

%------------- END OF CODE --------------
