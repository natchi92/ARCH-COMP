function val = get(obj, propName)
% get - Retrieve object data from obj
%
% Syntax:  
%    val = get(obj, propName)
%
% Properties:
%    lastState - final state after simulation
% Author:       Victor CHARLENT
% Written:      24-May-2016  
% Last update:  ---
% Last revision: ---

%------------- BEGIN CODE --------------

switch propName
    case 'result'
        val=obj.result;
    case 'trajectory'
        x = obj.result.simulation.x;
        loc = obj.result.simulation.location;
        t = obj.result.simulation.t;
        val.x = x;  
        val.loc = loc;   
        val.t = t;
    case 'finalState'
        x = obj.result.simulation.x;
        loc = obj.result.simulation.location;
        val.x = x{length(x)}(end,:);  
        val.loc = loc(end);  
    case 'finalLocation'
        val = obj.result.reachSet.location;
    case 'reachableSet'
        val = obj.result.reachSet.R;    
    case 'continuousReachableSet'
        val = obj.result.reachSet.Rcont; 
    case 'enclosure'
        val = obj.result.reachSet.Rencl;
    case 'transitionFraction'
        val = obj.result.reachSet.tranFrac;  
    case 'timePoints'
        val = obj.result.reachSet.TP;         
otherwise
    error([propName,' is not a valid asset property'])
end

%------------- END OF CODE --------------
