function [tp]=cellIntersection(Obj,center)
% Purpose:  calculates relative volume of cell with center intersected with
%           neighbors
% Pre:      partition object
% Post:     relative volume p, cell indices of relative volume


%initialize--------------------------------------------------------
tp=zeros(prod(Obj.nrOfSegments)+1,1); %tp: transition probability
%------------------------------------------------------------------

%corner with minimum values
c=center-0.5*Obj.segmentLength;

%subscripts of c
sub=ceil((c-Obj.intervals(:,1))./Obj.segmentLength);

%relative distance to next higher cell in each dimension
d=mod(c,Obj.segmentLength);
d_rel=d./Obj.segmentLength;

%p: probability vector
%S: subscript matrix
p=1;
S=sub';

for iDim=1:length(center)
    p1=p*(1-d_rel(iDim));
    p2=p*d_rel(iDim);
    p=[p1;p2];
    
    S_new=S;
    S_new(:,iDim)=S(:,iDim)+1;
    S=[S;S_new];
end

%index vector--------------------
indices=s2i(Obj,S);
%--------------------------------

tp(indices+1,1)=p;

tp=sparse(tp);