function [TP,R,nextLoc,blockedLoc,Rjump,Rcont] = reach(obj,tStart,R0,blockedLoc,options)
% reach - computes the reachable set of the system within a location, 
% detects the guard set that is hit and computes the reset
%
% Syntax:  
%    [TP,R,nextLoc,Rjump,Rcont] = reach(obj,tStart,R0,options)
%
% Inputs:
%    obj - location object
%    tStart - start time
%    R0 - initial reachable set
%    options - options struct
%
% Outputs:
%    TP - time point struct; e.g. contains time vector of minimum times for reaching guard sets
%    R - cell array of reachable sets
%    nextLoc - next location
%    Rjump - reachable set after jump according to the reset map
%    Rcont - reachable set due to continuous evolution
%
% Example: 
%
% Other m-files required: initReach, reach, potOut, potInt, guardIntersect,
% reset
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      07-May-2007 
% Last update:  17-August-2007
%               26-March-2008
%               21-April-2009
%               06-July-2009
%               24-July-2009
%               31-July-2009
%               11-August-2010
%               22-October-2010
%               25-October-2010
%               08-August-2011
%               11-September-2013
%               31-July-2016
%               19-August-2016
% Last revision: ---

%------------- BEGIN CODE --------------


%set up TPtmp
TP.tMin = [];
TP.tMax = [];

%set up variables
nextLoc = [];
Rjump = [];
Rguard_noInt = [];

%obtain factors for initial state and input solution
for i=1:(options.taylorTerms+1)
    r = options.timeStepLoc{1};
    options.factor(i)= r^(i)/factorial(i);    
end


if options.isHyperplaneMap
    % get results from hyperplane mapping
    %[TP,R,activeGuards,Rguard,Rguard_noInt,Rcont] = hyperplaneMap(obj,tStart,R0,blockedLoc,options);
    [TP,R,activeGuards,Rguard,Rguard_noInt,Rcont] = hyperplaneMap_noInv(obj,tStart,R0,blockedLoc,options);
else

    %get results from reachability analysis
    [TP,R,activeGuards,Rint,Rcont] = singleSetReach(obj,tStart,R0,options);

    %compute enclosing zonotopes
    for i=1:length(activeGuards)

        %obtain guard number
        iGuard = activeGuards(i);

        Rguard{iGuard}{1} = enclosePolytopes(obj,Rint{iGuard},options);
    end
%         %test
%         for i=1:length(Rcont.OT)
%             plot(Rcont.OT{i});
%         end
%         for i=1:length(Rguard)
%             if ~isempty(Rguard{i})
%                 plot(Rguard{i}{1});
%             end
%         end
end

%compute jumps, next locations
counter = 1;
TPsaved = TP;

for i=1:length(activeGuards)

    %obtain guard number
    iGuard = activeGuards(i);

    %does no intersection set exist?
    if ~isempty(Rguard_noInt)
        for iSet = 1:length(Rguard_noInt{iGuard})
            if ~isempty(Rguard_noInt{iGuard}{iSet})
                Rjump{counter} = reset(obj.transition{iGuard},Rguard_noInt{iGuard}{iSet});  
                nextLoc(counter) = obj.id;
                blockedLoc(counter) = get(obj.transition{iGuard},'target');
                TP.tMin(counter) = TPsaved.tMin(i);

                %update counter
                counter = counter + 1;
            end
        end
    end

    %compute reset and new locations of active guards
    for iSet = 1:length(Rguard{iGuard})
        Rjump{counter} = reset(obj.transition{iGuard},Rguard{iGuard}{iSet});  
        nextLoc(counter)=get(obj.transition{iGuard},'target');
        blockedLoc(counter) = 0;
        TP.tMin(counter) = TPsaved.tMin(i);

        %update counter
        counter = counter + 1;
    end
end


%------------- END OF CODE --------------