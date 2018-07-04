function [pos,angle]=coordinateTrans(obj,segNumber,dev)
% coordinateTrans - returns the position and angle of a path segment in
% cartesian coordinates when forwarding the segment number and path
% deviation
%
% Syntax:  
%    [pos,angle]=coordinateTrans(obj,segNumber,dev)
%
% Inputs:
%    obj - road object
%    segNumber - number of the segment along the path
%    dev - deviation from path
%
% Outputs:
%    pos - x,y position
%    angle - orientation of the path
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      20-July-2009
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%load data
angle=obj.segments.angle;
x=obj.segments.x;
y=obj.segments.y;


%obtain angles and positions of the path segment
%beginning of path segment:
angleAct=angle(segNumber);
xAct=x(segNumber);
yAct=y(segNumber);

%calculate translation vectors tangential to the path
transLat(1,1)=cos(angleAct-0.5*pi);
transLat(2,1)=sin(angleAct-0.5*pi);

%return position and angle
pos=[xAct; yAct]+dev*transLat;
angle=angleAct;

%------------- END OF CODE --------------