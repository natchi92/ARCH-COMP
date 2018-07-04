function display(Obj)
% Purpose:  Display values of partition object
% Pre:      partition Object
% Post:     ---
% Tested:   14.09.06,MA

disp('state space intervals: ');
disp(Obj.intervals);
disp('Number of Segments in each dimension: ');
disp(Obj.nrOfSegments); 
disp('Actual Segment Nr: ');
disp(Obj.actualSegmentNr); 
disp('Segment length: ');
disp(Obj.segmentLength); 
