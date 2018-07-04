function plotReach(obj,options)
% plot - plots reachable sets of a hybrid automaton
%
% Syntax:  
%    plotReach(obj)
%
% Inputs:
%    obj - hybrid automaton object
%
% Outputs:
%    none
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author: Matthias Althoff
% Written: 11-May-2007 
% Last update: 28-September-2007
%              26-March-2008
%              23-June-2009
%              10-November-2010
% Last revision: ---

%------------- BEGIN CODE --------------


%load data from object structure
R=obj.result.reachSet.Rcont.OT; %<-- change back
%R=obj.result.reachSet.R.OT;
%R=obj.result.reachSet.R.OT{1};
loc=obj.result.reachSet.location;
dim=options.projectedDimensions;


for i=1:(length(R))
    disp(['next plot: ',num2str(i)]);
    for j=1:length(R{i})
        %plot reachable set
        Rproj = project(R{i}{j},dim);
        Rred = reduce(Rproj,'girard',options.polytopeOrder);
        plot(Rred,[1 2],options.plotType);
    end
end


%------------- END OF CODE --------------