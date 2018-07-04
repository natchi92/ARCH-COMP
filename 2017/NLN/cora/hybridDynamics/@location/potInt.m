function [guards,setIndices,box] = potInt(obj,R)
% potInt - determines which reachable sets potentially intersect with guard
% sets of a location
%
% Syntax:  
%    [guards] = potInt(obj,R)
%
% Inputs:
%    obj - location object
%    R - cell array of reachable sets
%
% Outputs:
%    guards - guards that are potentially intersected
%    sets - reachable sets that are potentially intersected
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      08-May-2007 
% Last update:  26-October-2007
%               20-October-2010
%               27-July-2016
% Last revision:---

%------------- BEGIN CODE --------------

%Initialize guards and setIndices
guards=[]; setIndices=[];

%check if guard sets exist
if ~isempty(obj.transition)
    
    %generate enclosing boxes of the guard sets
    for iTransition=1:length(obj.transition)
        guardSet=get(obj.transition{iTransition},'guard');
        guardIH{iTransition}=interval(guardSet);
    end

    %do the reachable sets potentially intersect one of the
    %overapproximated guards?
    
    for iSet=1:length(R);
        box{iSet}=interval(R{iSet});
        for iTransition=1:length(obj.transition)
            int(iTransition,iSet)=isIntersecting(guardIH{iTransition},box{iSet});
        end
    end

    if exist('int')
        [guards,setIndices]=find(int);
    end
end

%------------- END OF CODE --------------