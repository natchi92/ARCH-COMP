function [obj, Rtp, options] = initReach(obj, Rinit, options)
% initReach - computes the reachable continuous set for the first time step
%
% Syntax:  
%    [Rnext] = initReach(obj,R,options)
%
% Inputs:
%    obj - nonlinearSys object
%    Rinit - initial reachable set
%    options - options for the computation of the reachable set
%
% Outputs:
%    obj - nonlinearSys object
%    Rfirst - first reachable set 
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

[Rtp,options] = linReach(obj,options,Rinit);

%------------- END OF CODE --------------