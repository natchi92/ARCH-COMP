function [M]=map(Obj,targetField,P)
% Purpose:  Build polytope for the mapping from 1D to 2D movement
% Pre:      road object
% Post:     road object
% Built:    16.11.06,MA


%load--------------------------------
x=Obj.segments.x;
y=Obj.segments.y;
angle=Obj.segments.angle;
%------------------------------------

segmentLength=get(Obj.targetField,'segmentLength');
xLength=segmentLength(1);
yLength=segmentLength(2);

%initialize M------------------------
totalNrofSegments=prod(get(targetField,'nrOfSegments'));
NrofPoints=length(angle);
M(totalNrofSegments,NrofPoints)=0;
M=sparse(M);
%------------------------------------

%field center------------------------
[center]=centerSegment(targetField);
centerIndex=center.ind;
%------------------------------------

for iPoint=1:(length(angle)-1)
    %find segment
    IH=interval([x(iPoint); y(iPoint)], [x(iPoint);y(iPoint)]);
    [segmentIndex]=findSegments(targetField,IH);
    %get relative positions
    [intervals]=segmentIntervals(targetField,segmentIndex);
    delta_x=x(iPoint)-intervals(1,1);
    delta_y=y(iPoint)-intervals(2,1);
    %build M----------------------------------------------
    %get indices for P
    iAngle=ceil(angle(iPoint)/(2*pi/Obj.discretization(1)));
    next_iAngle=ceil((angle(iPoint+1)-angle(iPoint))/(2*pi/Obj.discretization(1)))+6;
    iX=ceil(delta_x/(xLength/Obj.discretization(2)));
    iY=ceil(delta_y/(yLength/Obj.discretization(3)));
    %border cases
    if iAngle==0
        iAngle=1;
    end
    if iX==0
        iX=1;
    end
    if iY==0
        iY=1;
    end    
    if iX==5
        iX=4; %<-- needs adaptation!!
    end
    if iY==5
        iY=4;
    end    
  
    %relative Probabilities
    relProbabilities=P{iAngle,iX,iY,next_iAngle};
    %cancel outside cell
    relProbabilities(1)=[];
    
    relIndices=find(relProbabilities);
    absIndices=(segmentIndex-centerIndex)*ones(length(relIndices),1)+relIndices+1;
    M(absIndices,iPoint)=relProbabilities(relIndices);
    %-----------------------------------------------------
end