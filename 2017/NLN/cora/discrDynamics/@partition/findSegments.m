function [segmentIndex]=findSegments(Obj,IH)
% Purpose:  Find segment indeces for a given interval hull (IH: no interval hull object!)
% Pre:      partition object, interval hull (IH)
% Post:     segmnent indices
% Tested:   14.09.06,MA
% Modified: 20.09.06,MA


%get interval coordinates from IH
intervalCoordinates(:,1)=ceil((infimum(IH)-Obj.intervals(:,1))./Obj.segmentLength);
intervalCoordinates(:,2)=ceil((supremum(IH)-Obj.intervals(:,1))./Obj.segmentLength);

for iDim=1:length(intervalCoordinates(:,1))
    if intervalCoordinates(iDim,1)<0
        intervalCoordinates(iDim,1)=0;
        if intervalCoordinates(iDim,2)<0
            intervalCoordinates(iDim,2)=0;
        end
    end
end

for iDim=1:length(intervalCoordinates(:,2))
    if intervalCoordinates(iDim,2)>Obj.nrOfSegments(iDim)
        intervalCoordinates(iDim,2)=Obj.nrOfSegments(iDim);
        if intervalCoordinates(iDim,1)>Obj.nrOfSegments(iDim)
            intervalCoordinates(iDim,1)=Obj.nrOfSegments(iDim);
        end
    end
end

%generate coordinate arrays out of coordinate intervals-------------
newArray=(intervalCoordinates(1,1):intervalCoordinates(1,2))';
for dim=2:length(intervalCoordinates(:,1))
    arrayLength=length(newArray(:,1));
    oldArray=newArray;
    newArray=[];
    for i=intervalCoordinates(dim,1):intervalCoordinates(dim,2)    
        newArray=[newArray;oldArray,ones(arrayLength,1)*i];
    end
end
%-------------------------------------------------------------------

%get segment indices out of coordinate arrays
segmentIndex=s2i(Obj,newArray); 