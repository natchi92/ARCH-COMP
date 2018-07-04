function [R] = potOut(obj,R,options)
% potOut - determines the reachable sets after intersection with the
% invariant and obtains the fraction of the reachable set that must have
% transitioned; the resulting reachable sets are all converted to polytopes
%
% Syntax:  
%    [R,endInd] = potOut(obj,R)
%
% Inputs:
%    obj - location object
%    R - cell array of reachable sets
%
% Outputs:
%    R - cell array of reachable sets
%    endInd - last index for which the reachable set is in the invariant
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      11-May-2007 
% Last update:  18-September-2007
%               26-March-2008
%               02-October-2008
%               21-April-2009
%               24-July-2009
%               21-October-2010
%               30-July-2016
% Last revision:---

%------------- BEGIN CODE --------------

%generate polytope of the invariant
try
    Pinv=polytope(obj.invariant,options);
catch
    Pinv=polytope(obj.invariant);
end

index(length(R))=0;
%parfor (iSet=1:length(R))
for iSet=1:length(R)
    %overapproximate reachable set by a halfspace representation
    R{iSet}=enclosingPolytope(R{iSet},options);
    
    R{iSet}=Pinv&R{iSet};         
end


%------------- END OF CODE --------------