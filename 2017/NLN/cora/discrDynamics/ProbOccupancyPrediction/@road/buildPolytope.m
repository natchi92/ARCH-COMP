function [P]=buildPolytope(Obj,angle,xOffset,yOffset,iAngle)
% Purpose:  Build polytope for the mapping from 1D to 2D movement
% Pre:      road object
% Post:     road object
% Built:    16.11.06,MA

%transition to field center
[center]=centerSegment(Obj.targetField);
centerLoc=center.val;
segmentLength=get(Obj.targetField,'segmentLength');
t2=centerLoc-0.5*segmentLength;

for iVertices=1:length(Obj.prototypeVertices(1,:))
    %translate and rotate prototype V-Polytope
    V=Obj.prototypeVertices{iAngle,iVertices};

    %build rotation matrix
    R(1,1)=cos(angle);
    R(1,2)=-sin(angle);
    R(2,1)=sin(angle);
    R(2,2)=cos(angle);

    %rotate vertices
    V=R*V;

    %perform translation
    t=[xOffset;yOffset]+t2;
    [rows,columns]=size(V);
    T=t*ones(1,columns);
    V=V+T;

    %build polytope
    P{iVertices}=polytope(V');
end