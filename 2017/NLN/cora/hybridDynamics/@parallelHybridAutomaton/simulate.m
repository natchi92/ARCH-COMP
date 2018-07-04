function [obj] = simulate(obj,options)
% simulate - simulates a hybrid automaton
%
% Syntax:  
%    [obj] = simulate(obj,tstart,tfinal,startlocation,y0)
%
% Inputs:
%    obj - hybrid automaton object
%    options - simulation options
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

% Author: Victor CHARLENT
% Written: 24-May-2016  
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------


%load data from options
tFinal=options.tFinal; %final time
finalLoc=options.finalLoc; %final location % WARNING !!! Composed location !!! array of location (index in the array is the index of the component)

%initialize variables, intermediate state, 
tInter=options.tStart; %intermediate time at transitions
loc=options.startLoc; %actual location % WARNING !!! Composed location !!! array of location (index in the array is the index of the component)
xInter=options.x0; %intermediate state at transitions % WARNING !!! Composed location !!! array of location (index in the array is the index of the component)
t=[]; %time vector
x=[]; %state vector
count=1; %transition counter

% Get the number of component in the parallel hybrid automaton
nComponents = length(obj.components);

bindsCollection = getBindsSet(obj);

%while final time not reached
while (tInter<tFinal) && (~isempty(loc)) && (~isFinalLocation(loc,finalLoc))  || (count==1)
    
    %store locations
    location(count,1:nComponents)=loc;

    % Merge location
    locationCollection = getLocationSet(obj,loc);
    currentLocation = mergeLocation(locationCollection,loc,bindsCollection,options);
    
    %Merge options ?
    %optionsCollection = getOptionsSet(obj,loc);
    
    %choose input
    %options.u=options.uLoc{loc}; %<--change here!!
    %options.u=randPoint(options.Uloc{loc})+options.uLocTrans{loc}; %<--change here!!

    options.u=randPointExtreme(options.Uloc{1})+options.uLocTrans{1}; %<--change here!!

    %simulate within the actual location
    [tNew,xNew,loc,xInter]=simulate(currentLocation,options,tInter,tFinal,xInter);

    %new intermediate time is last simulation time
    tInter=tNew(end);
    
    %store results
    t{count}=tNew;
    x{count}=xNew;
    
    %increase counter for transitions
    count=count+1;
end

%save results to object structure
obj.result.simulation.t=t;
obj.result.simulation.x=x;
obj.result.simulation.location=location;


%------------- END OF CODE --------------

