function p0=initialProbability(obj)
% initialProbability - Calculate probability vector out of the 
% state space partition and the initial state set
%
% Syntax:  
%    p0=initialProbability(obj)
%
% Inputs:
%    obj - simulation object
%
% Outputs:
%    p0 - initial probability vector
%
% Example: 
%    ---
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author: Matthias Althoff
% Written: 09-October-2006
% Last update: 17-June-2008 
% Last revision: ---

%------------- BEGIN CODE --------------

field=obj.simOptions.stateField;
initialSet=obj.simOptions.initialStateSet;

%select algorithm based on the class of the initial set:
%interval hull/ polytope
if strcmp('interval',class(initialSet))
    p0=cellIntersection3(field,initialSet);
elseif ~strcmp('polytope',class(initialSet))
    Obj.initialSet=polytope(initialSet);
    p0=cellIntersection2(field,initialSet);
else
    p0=cellIntersection2(field,initialSet);
end    
%------------- END OF CODE --------------