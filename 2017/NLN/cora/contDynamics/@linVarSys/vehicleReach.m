function [Rnext, options] = vehicleReach(obj, R, options)
% vehicleReach - computes the reachable continuous set for one time step of 
% the autonomous vehicle dynamics
%
% Syntax:  
%    [Rnext, options] = vehicleReach(obj,R,options)
%
% Inputs:
%    obj - linVarSys object
%    R - reachable set of the previous time step
%    options - options for the computation of the reachable set
%
% Outputs:
%    Rnext - reachable set of the next time step
%    options - options for the computation of the reachable set
%pathdef.m
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      26-April-2011
% Last update:  16-June-2016
%               25-July-2016 (intervalhull replaced by interval)
% Last revision:---

%------------- BEGIN CODE --------------

%obtain center
c = center(R.tp);

%get interval hull of states
IH = interval(R.tp)

%VELOCITY
%get initial uncertain velocity
v = interval(IH(4,1),IH(4,2));

%consider acceleration
delta_v = options.a_x * options.timeStep;
v = v + delta_v;

%consider additional uncertainty
%unc_v = 10*interval(-1,1)*options.timeStep;
unc_v = 0;
v = v + unc_v;
d_v = v - c(4);

%SLIP ANGLE
%get initial uncertain slip angle
beta = interval(IH(1,1),IH(1,2));

%consider additional uncertainty
%unc_beta = 1*interval(-1,1)*options.timeStep;
unc_beta = 0;
beta = beta + unc_beta;
d_beta = beta - c(1);

%YAW ANGLE
%get initial uncertain yaw angle
Psi = interval(IH(2,1),IH(2,2));

%consider additional uncertainty
%unc_Psi = 1*interval(-1,1)*options.timeStep;
unc_Psi = 0;
Psi = Psi + unc_Psi;
d_Psi = Psi - c(2);

%obtain parameter values
mu = 0.7;

p(1) = interval(1,1);
p(2) = mu;
p(3) = mu/v;
p(4) = mu/v^2;
p(5) = -sin(beta+Psi)*d_v - v*cos(beta+Psi)*(d_beta+d_Psi);
p(6) =  cos(beta+Psi)*d_v - v*sin(beta+Psi)*(d_beta+d_Psi);


%load data
zAcell = options.zA;

%obtain matrix zonotopes
zA = vehicleMatrixZonotopes(zAcell, p, options.uTrans, c);

%obtain uncertain constant input
f0 = vehicleDynamics_zeroOrder(1,c,options.uTrans,p);
U = zonotope(interval(infimum(f0),supremum(f0)));

options.uTrans = center(U);
options.U = U + (-options.uTrans); %input for reachability analysis

%update initial set; transform to origin
R0 = R.tp + (-c);

%instantiate linear dynamics
obj.A = zA;

%initialize reachable set computations
[obj, Rnext, options] = initReach(obj, R0, options);

%transform reachable set back
Rnext.tp = Rnext.tp + c;
Rnext.ti = Rnext.ti + c; 


