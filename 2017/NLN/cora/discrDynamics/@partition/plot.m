function plot(Obj)
% Purpose:  plot state space partition
% Pre:      partition object
% Post:     ---
% Tested:   14.09.06,MA

Obj.actualSegmentNr=0;

%subplot(2,1,2)
for iCell=1:prod(Obj.nrOfSegments)
    %generate interval hull out of cell--------------------------
    Obj=nextSegment(Obj);
    intervals=segmentIntervals(Obj);
    IH=interval(intervals(:,1), intervals(:,2));
    %------------------------------------------------------------
    plot(IH,[1 2],'Color',[.8 .8 .8]);
    hold on
end

