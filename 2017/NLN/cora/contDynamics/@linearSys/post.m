function [Rnext,options] = post(obj,R,options)
% post - computes the reachable continuous set for one time step
%
% Syntax:  
%    [Rnext,options] = post(obj,R,options)
%
% Inputs:
%    obj - linearSys object
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
% Written:      07-May-2007 
% Last update:  27-April-2009
%               29-June-2009
%               08-August-2011
%               25-July-2016 (intervalhull replaced by interval)
% Last revision:---

%------------- BEGIN CODE --------------

%load homogeneous solution from options struct
Rhom=options.Rhom;
Rhom_tp=options.Rhom_tp;
Rpar=options.Rpar;
Raux=options.Raux;

%update 
eAt=obj.taylor.eAt;
if iscell(options.Rtrans)
    Rtrans = options.Rtrans{options.iSet};
else
    Rtrans = options.Rtrans;
end

if (~isfield(options,'linAlg')) || (options.linAlg == 1)
    %option 1 (wrapping free)
    Rhom=eAt*Rhom + center(Rtrans);
    Rhom_tp=eAt*Rhom_tp + center(Rtrans);
    Raux=eAt*Raux;
    Rpar=Rpar + interval(Raux) + interval(Rtrans) + (-center(Rtrans));
else
    %option 2 (not wrapping-free)
    Rhom=eAt*Rhom + Rtrans;
    Rhom_tp=eAt*Rhom_tp + Rtrans;
    Raux=eAt*Raux;
    %Rpar=Rpar + interval(Raux);
    Rpar=reduce(Rpar + Raux,'girard',options.zonotopeOrder);
    Rhom=reduce(Rhom,'girard',options.zonotopeOrder);
    Rhom_tp=reduce(Rhom_tp,'girard',options.zonotopeOrder);
end

%save homogeneous and particulate solution to options struct
options.Rhom=Rhom;
options.Rhom_tp=Rhom_tp;
options.Rpar=Rpar;
options.Raux=Raux;

%write results to reachable set struct Rnext
if isa(Rhom,'mptPolytope')
    Rnext.ti=Rhom+mptPolytope(Rpar);
    Rnext.tp=Rhom_tp+mptPolytope(Rpar);
else
    Rnext.ti=Rhom+zonotope(Rpar);
    Rnext.tp=Rhom_tp+zonotope(Rpar);
end

%------------- END OF CODE --------------