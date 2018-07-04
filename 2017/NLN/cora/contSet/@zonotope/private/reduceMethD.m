function [Zred,t]=reduceMethD(Z,additionalGens,filterLength)
% reduceMethD - similar to methC; does not reduce to parallelotopes, but to 
% zonotopes of order greater than 1
%
% Syntax:  
%    [Zred,t]=reduceMethD(Z,additionalGens)
%
% Inputs:
%    Z - zonotope object
%    additionalGens - number of generators that are not reduced
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
% Written:      01-October-2008 
% Last update:  26-February-2009
%               07-October-2010
% Last revision:---

%------------- BEGIN CODE --------------

tic;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');
dim=length(Zmatrix(:,1));

%extract generator matrix and center
c=Zmatrix(:,1);
G=Zmatrix(:,2:end);


%split generators
[G1,G2]=splitGens(G,additionalGens);

%instantiate zonotopes
o=zeros(dim,1);

Z1=zonotope([c,G1]);
Z2=zonotope([o,G2]);

%reduce zonotopes
Z2red=reduce(Z2,'methC',1,filterLength);

%transform to polytope
Zred=Z1+Z2red;

%time measurement
t=toc;

%------------- END OF CODE --------------
