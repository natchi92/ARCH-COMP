function [obj,x] = simulate(obj,options,kstart,kfinal,x0)
% simulate - simulates the system within a location
%
% Syntax:  
%    [t,x,index] = simulate(obj,tstart,tfinal,x0,options)
%
% Inputs:
%    obj - linearSys object
%    tstart - start time
%    tfinal - final time
%    x0 - initial state 
%    options - contains, e.g. the events when a guard is hit
%
% Outputs:
%    obj - linearSys object
%    t - time vector
%    x - state vector
%    index - returns the event which has been detected
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      22-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%set initial state
x(:,1) = x0;

%loop
for i = kstart:kfinal
    x(:,i+1) = obj.dynFile(0,x(:,i),options.uTransVec(:,i)+options.uDelta);
end
    
%------------- END OF CODE --------------