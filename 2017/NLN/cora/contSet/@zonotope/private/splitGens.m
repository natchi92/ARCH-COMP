function [G1,G2]=splitGens(G,additionalGens)
% splitGens - splits generators into a group with long and short generators
%
% Syntax:  
%    [Gred]=splitGens(G)
%
% Inputs:
%    G - matrix of generators
%
% Outputs:
%    Gred - reduced matrix of generators
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author: Matthias Althoff
% Written: 01-October-2008
% Last update: 26-February-2008
% Last revision: ---

%------------- BEGIN CODE --------------

%prefilter generators
for i=1:length(G(1,:))
    h(i)=norm(G(:,i));
end
[value,index]=sort(h,'descend');

G1=G(:,index(1:(additionalGens)));
G2=G(:,index((1+additionalGens):end));

%------------- END OF CODE --------------
