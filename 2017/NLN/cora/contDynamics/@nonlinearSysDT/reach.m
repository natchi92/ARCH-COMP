function [Rnext,options] = reach(obj,R,options)
% reach - computes the reachable continuous set for one time step of a
% nonlinear system by overapproximative linearization
%
% Syntax:  
%    [Rnext] = reach(obj,R,options)
%
% Inputs:
%    obj - nonlinearSys object
%    R - reachable set of the previous time step
%    options - options for the computation of the reachable set
%
% Outputs:
%    Rnext - reachable set of the next time step
%    options - options for the computation of the reachable set
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      21-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%despite the linear system: the nonlinear system has to be constantly
%initialized due to the linearization procedure
[obj,Rnext,options] = initReach(obj,R,options);

%reduce zonotopes
Rnext=reduce(Rnext,'girard',options.zonotopeOrder);


%------------- END OF CODE --------------