function a = set(a,varargin)
% Purpose:  Set asset properties from the specified object
% Pre:      partition object
% Post:     property value
% Tested:   21.04.09,MA

propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
    case 'actualSegmentNr'
        a.actualSegmentNr = val;        
    otherwise
        error('partition object values not set correctly');
    end
end