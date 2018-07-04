function [vol] = volume(Z)
% volume - Computes the volume of a zonotope
%
% Syntax:  
%    [vol] = volume(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    vol - volume
%
% Example: 
%    Z=zonotope([1 -1 0; 0 0 -1]);
%    vol=volume(Z)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      24-August-2007 
% Last update:  19-July-2010
% Last revision:---

%------------- BEGIN CODE --------------

%dimension and nrOfGenerators
G=Z.Z(:,2:end);
[dim,nrOfGen]=size(G);

%possible combinations of n=dim generators from all generators
comb = combinator(nrOfGen,dim,'c');
nrOfComb=length(comb(:,1));

for i=1:nrOfComb
    try
        parallelogramVol(i)=abs(det(G(:,comb(i,:))));
    catch
        parallelogramVol(i)=0;
        disp('parallelogram volume could not be computed');
    end
end

vol=2^dim*sum(parallelogramVol);


%------------- END OF CODE --------------