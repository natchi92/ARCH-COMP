function [Rnext, options] = yawReach(obj, R, options)
% yawReach - computes the reachable continuous set for one time step of the
% vehicle yaw dynamics
%
% Syntax:  
%    [Rnext, options] = yawReach(obj,R,options)
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
% Written:      23-August-2010
% Last update:  16-June-2016
%               25-July-2016 (intervalhull replaced by interval)
% Last revision:---

%------------- BEGIN CODE --------------


%get uncertain velocity
IH_v = interval(R.tp);
IH_u = interval(options.yawOptions{1}.zU);
delta_v = IH_u(3,1) * options.timeStep;
if obj.dim==4
    int_v = interval(IH_v(3,1)+delta_v, IH_v(3,2));
elseif obj.dim==8
    int_v = interval(IH_v(7,1)+delta_v, IH_v(7,2));
end

%get current location range
vMin=infimum(int_v);
vMax=supremum(int_v);

locMin=floor((vMin-0.1)/10); %<-- specify uncertain switching
locMax=floor(vMax/10);

if locMin<1
    locMin=1;
end
if locMax<1
    locMax=1;
end

%get yaw options 
if options.isCont
    if locMin==locMax
        yawOptions = options.yawOptions{locMax};
    else
        if (locMin==2) && (locMax==3)
            yawOptions = options.yawOptions{4};
        elseif (locMin==1) && (locMax==2)
            yawOptions = options.yawOptions{5};
        else
            disp('this combination is not considered');
        end
    end
else
    yawOptions = options.yawOptions{locMax};
end

%load data
zAcell = yawOptions.zA;
zBcell = yawOptions.zB;

%obtain matrix zonotopes
[zA,zB] = yawMatrixZonotopes(zAcell, zBcell, int_v);

zU = diag([1/int_v, 1, 1]) * yawOptions.zU;

%convert zDelta to the uncertain input
U = zB*zU;

options.uTrans = center(U);
options.U = U + (-options.uTrans); %input for reachability analysis

%update initial set
options.R0 = R.tp;

%instantiate linear dynamics
obj.A = zA;

%initialize reachable set computations
[obj, Rnext, options] = initReach(obj, options);
    


