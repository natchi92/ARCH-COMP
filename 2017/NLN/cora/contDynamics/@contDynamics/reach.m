function [Rcont,Rcont_tp] = reach(obj,options)
% reach - computes the reachable continuous set for the entire time horizon
% of a continuous system
%
% Syntax:  
%    [Rcont,Rcont_tp] = reach(obj,options)
%
% Inputs:
%    obj - continuous system object
%    options - options for the computation of reachable sets
%
% Outputs:
%    Rcont - reachable set of time intervals for the continuous dynamics 
%    Rcont_tp - reachable set of points in time for the continuous dynamics 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      08-August-2016
% Last update:  22-September-2016
% Last revision:---

%------------- BEGIN CODE --------------


%obtain factors for initial state and input solution
for i=1:(options.taylorTerms+1)
    %time step
    r = options.timeStep;
    %compute initial state factor
    options.factor(i)= r^(i)/factorial(i);    
end
%possibility for updating time step
%options.timeStep = options.timeFactor*norm(A^2,inf)^(-0.5); 


%if a trajectory should be tracked
if isfield(options,'uTransVec')
    options.uTrans = options.uTransVec(:,1);
end

%initialize reachable set computations
[Rnext, options] = initReach(obj, options.R0, options);

%while final time is not reached
t=options.tStart;
iSet=1;

while t<options.tFinal
    
    %save reachable set in cell structure
    Rcont{iSet} = Rnext.ti; 
    Rcont_tp{iSet} = Rnext.tp; 
    
    %increment time and set counter
    t = t+options.timeStep;
    iSet = iSet+1; 
    options.t=t;
    if isfield(options,'verbose') && options.verbose 
        disp(t); %plot time
    end
    
    %if a trajectory should be tracked
    if isfield(options,'uTransVec')
        options.uTrans = options.uTransVec(:,iSet);
    end
    
    %compute next reachable set
    [Rnext,options]=post(obj,Rnext,options);
end


%------------- END OF CODE --------------