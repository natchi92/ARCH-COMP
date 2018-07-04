function [Rtp,options] = linReach(obj,options,Rinit)
% linReach - computes the reachable set after linearazation and returns if
% the initial set has to be split in order to control the linearization
% error
%
% Syntax:  
%    [Rti,Rtp,perfInd,nr,options] = linReach(obj,options,Rinit,iter)
%
% Inputs:
%    obj - nonlinear DAE system object
%    options - options struct
%    Rinit - initial reachable set
%    iter - flag for activating iteration
%
% Outputs:
%    Rti - reachable set for time interval
%    Rti - reachable set for time point
%    perfInd - performance index
%    nr - number of generator that should be split
%    options - options struct to return f0
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      21-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% linearize nonlinear system
[obj,A_lin,U] = linearize(obj,options,Rinit); 

%translate Rinit by linearization point
Rdelta = Rinit + (-obj.linError.p.x);

% compute reachable set of linearized system
Rtp = A_lin*Rdelta + U;

% obtain linearization error
if options.errorOrder > 2
    [Verror, error] = linError_thirdOrder(obj, options, Rdelta); 
else
    [Verror, error] = linError_mixed_noInt(obj, options, Rdelta);   
end


%compute performance index of linearization error
perfInd = max(error./options.maxError)

%add interval of actual error
Rtp=Rtp+Verror;


%------------- END OF CODE --------------