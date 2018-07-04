function val = get(a, propName)
% Purpose:  Get asset properties from the specified object
% Pre:      partition Object
% Post:     property value
% Tested:   14.09.06,MA
% Modified: 28.09.06,MA

switch propName
    case 'intervals'
        val = a.intervals;     
    case 'nrOfSegments'
        val = a.nrOfSegments;      
    case 'actualSegmentNr'
        val = a.actualSegmentNr; 
    case 'mode'
        val = a.mode;         
    case 'segmentLength'
        val = a.segmentLength;
otherwise
    error([propName,' Is not a valid asset property'])
end