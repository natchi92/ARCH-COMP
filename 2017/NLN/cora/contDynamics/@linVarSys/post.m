function [Rnext,options] = post(obj,R,options)
% post - computes the reachable continuous set for one time step of a
% linear interval system
%
% Syntax:  
%    [Rnext] = post(obj,R,options)
%
% Inputs:
%    obj - linIntSys object
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
% Written:      15-May-2007 
% Last update:  07-January-2009
%               22-June-2009
%               29-June-2009
%               06-August-2010
%               02-April-2017
% Last revision: ---

%------------- BEGIN CODE --------------

%next set (no input)
R.ti = obj.mappingMatrixSet.zono*R.ti + obj.mappingMatrixSet.int*R.ti; 

%bloating due to input
R.ti = R.ti + obj.Rinput;

%reduce zonotope
Rred=reduce(R.ti,options.reductionTechnique,options.zonotopeOrder);

%write results to reachable set struct Rnext
Rnext.tp=[];
Rnext.ti=Rred;

%------------- END OF CODE --------------