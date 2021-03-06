function [Gcells]=reorderingFilter(G)
% reorderingFilter - saves combinations of generators to matrix cells
%
% Syntax:  
%    [Gred]=volumeFilter(G)
%
% Inputs:
%    G - generator matrix
%
% Outputs:
%    Gcells - cells of generator matrices
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      12-September-2008
% Last update:  20-July-2010
%               28-September-2010
% Last revision:---

%------------- BEGIN CODE --------------

%obtain combinations
[rows,cols]=size(G);
comb = combinator(cols,rows,'c');
nrOfComb=length(comb(:,1));

Gcells=[];
for i=1:nrOfComb
    try
        Gcells{end+1}=G(:,comb(i,:));
    catch
        disp('bad indices');
    end
end

%------------- END OF CODE --------------
