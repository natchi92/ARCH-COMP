function V = vertices(obj)
% vertices - computes the vertices of a mptPolytope
%
% Syntax:  
%    V = vertices(obj)
%
% Inputs:
%    obj - mptPolytope object
%
% Outputs:
%   V - vertices object
%
% Example: 
%    ---
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Matthias Althoff
% Written:      01-February-2011
% Last update:  12-June-2015
%               12-August-2016
% Last revision:---

%------------- BEGIN CODE --------------

try %MPT V3
    %obj.P.minVRep(); %compute vertex representation
    obj.P.computeVRep(); %compute vertex representation
    %workaround
    if length(obj.P(1).V(:,1))==1
        V = [];
    else
        if length(obj.P) == 1
            V = vertices(obj.P.V');
        else
            for i=1:length(obj.P)
                V{i} = vertices(obj.P(i).V');
            end
        end
    end
    
    
catch %MPT V2

    %compute vertices
    V = extreme(obj.P);

    %convert to vertices object
    V = vertices(V');
end

%------------- END OF CODE --------------