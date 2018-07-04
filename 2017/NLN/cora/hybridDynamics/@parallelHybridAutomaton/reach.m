function [obj,Rtotal,location] = reach(obj,options)
% reach - computes the reachable set of a hybrid automaton
%
% Syntax:  
%    [obj] = reach(obj,options)
%
% Inputs:
%    obj - hybrid automaton object
%    options - options for simulation, reachability analysis of systems
%
% Outputs:
%    obj - hybrid automaton object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      07-May-2007 
% Last update:  16-August-2007
%               26-March-2008
%               07-October-2008
%               21-April-2009
%               20-August-2013
%               30-October-2015
% Last revision: ---

%------------- BEGIN CODE --------------


%obtain factors for initial state and input solution
for i=1:(options.taylorTerms+1)
    r = options.timeStepLoc{1}; % why 1 ???
    options.factor(i)= r^(i)/factorial(i);    
end

%load data from options
tFinal = options.tFinal; %final time

%initialize variables
tInter = options.tStart; %intermediate time at transitions
nextLoc = options.startLoc; %next location
nextBlockedLoc = [];
Rinter = options.R0; %intermediate reachable set at transitions
openIndices = []; %contains indices of unfinished reachable sets
tRemain = []; %contains indices of unfinished reachable sets
location = nextLoc; %location history vector

% Get the number of component in the parallel hybrid automaton
nComponents = length(obj.components);

bindsCollection = getBindsSet(obj);

count=1; %transition counter

%while there exists a next reachable set
while ~isempty(Rinter)
    %specify new input
%     options.U=options.Uloc{nextLoc};
%     options.u=options.uLoc{nextLoc};
%     options.uTrans=options.uLocTrans{nextLoc};
%     options.timeStep=options.timeStepLoc{nextLoc};

    options.U=options.Uloc{1};
    options.u=options.uLoc{1};
    options.uTrans=options.uLocTrans{1};
    options.timeStep=options.timeStepLoc{1};
    
    % Merge location
    locationCollection = getLocationSet(obj,nextLoc);
    currentLocation = mergeLocation(locationCollection,nextLoc, bindsCollection, options);

    %compute reachable set within a location
    [TP,R,loc,blockedLoc,Rjump,Rcont]=reach(currentLocation,tInter,Rinter,nextBlockedLoc,options);
    %obtain vector of minimal times for reachin the guard sets
    tMin=TP.tMin;
    
    if ~isempty(loc) && (tMin(1)<(tFinal*(1-1e-6))) 
        %determine variables of first path
        Rinter=Rjump{1};
        tInter=tMin(1);
        nextLoc=loc(1);
        nextBlockedLoc=blockedLoc(1);
        
        %in case there are further paths ???
        for i=2:length(loc)
            %add open index
            openIndices(end+1)=length(tRemain)+1;

            %save variables of remaining paths
            ind=openIndices(end);
            Rremain{ind}=Rjump{i};
            tRemain(ind)=tMin(i); 
            locRemain(ind)=loc(i);
            locBlockedRemain(ind)=blockedLoc(i);
        end

    %if previous path is finished
    else
        %if there are still open indices
        if ~isempty(openIndices)
            %load variables of unsolved path
            ind=openIndices(1);
            Rinter=Rremain{ind};
            tInter=tRemain(ind);
            nextLoc=locRemain(ind);
            nextBlockedLoc=locBlockedRemain(ind);
            %delete first open index
            openIndices(1)=[]
        else
            %no further open reachable sets
            Rinter=[];
        end
%         %save final set
%         for i=1:length(R)
%             if i==1
%                 Rfinal=R{i}{end};
%             else
%                 Rfinal=Rfinal & R{i}{end};
%             end
%         end
%         obj.result.final.R{finalIndex}=Rfinal;
%         obj.result.final.location(finalIndex)=nextLoc;
%         finalIndex = finalIndex+1;
    end
    
    
    %store results
    location(count,1:nComponents)=nextLoc;

    try
        Rtotal.OT{count}=R.OT;
        Rtotal.T{count}{1}=R.T{end}; %overapproximate time point polytope by last time interval polytope
    catch
        Rtotal.OT{count}=R; 
        Rtotal.T{count}{1}=R{end}; 
    end
    TPtotal{count}=TP;
    RcontTotal.OT{count}=Rcont.OT;
    RcontTotal.T{count}=Rcont.T;
    Rencl{count}=Rjump;
    
    count = count + 1;
end

%save results to object structure
obj.result.reachSet.R=Rtotal;
obj.result.reachSet.location=location;
obj.result.reachSet.TP=TPtotal;
obj.result.reachSet.Rcont=RcontTotal;
obj.result.reachSet.Rencl=Rencl;

% zon2bRed=RcontTotal.OT; %<--store to assess halfspace conversion methods 
% save zon2bRed zon2bRed;

%------------- END OF CODE --------------