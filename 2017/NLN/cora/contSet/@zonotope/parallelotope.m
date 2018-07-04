function [P] = parallelotope(Z, options)
% parallelotope - Takes the first n generators of a zonotope to construct a 
% parallelotope in H-representation
%
% Syntax:  
%    [P] = parallelotope(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    P - polytope object
%
% Example: 
%
% Other m-files required: vertices, polytope
% Subfunctions: none
% MAT-files required: none
%
% See also: intervalhull,  vertices

% Author:       Matthias Althoff
% Written:      15-September-2007 
% Last update:  30-September-2008
%               19-October-2010
%               12-February-2012
%               12-August-2016
%               17-March-2017
% Last revision:---

%------------- BEGIN CODE --------------

%retrieve dimension
dim=length(Z.Z(:,1));
%retrieve center of the zonotope
c=Z.Z(:,1);
%retrieve generator matrix G
G=Z.Z(:,2:end);
%Delete zero-generators
G=nonzeroFilter(G);
%make full dimensional
zeroInd = find(sum(abs(G),2)==0);
for i = 1:length(zeroInd)
    G(zeroInd(i),end+1) = eps;
end

%build C matrix
for i=1:dim
    Q=G(:,1:dim);
    Q(:,i)=[];
    v=ndimCross(Q);
    C(i,:)=v'/norm(v);
end

%build d vector
for i=1:dim
    %determine delta d
    deltaD=abs(C(i,:)*G(:,i));

    %compute dPos, dNeg
    dPos(i,1)=C(i,:)*c+deltaD;
    dNeg(i,1)=-C(i,:)*c+deltaD;
end

%convert to mpt or ppl Polytope
if isfield(options,'polytopeType') && strcmp(options.polytopeType,'ppl')
    P=pplPolytope([C;-C],[dPos;dNeg]);
else
    P=mptPolytope([C;-C],[dPos;dNeg]);
end


%------------- END OF CODE --------------