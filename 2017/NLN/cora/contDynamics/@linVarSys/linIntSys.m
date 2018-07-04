function Obj = linIntSys(varargin)
% linIntSys - Object and Copy Constructor (linIntSys: linear interval system)
%
% Syntax:  
%    object constructor: Obj = class_name(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    input1 - name
%    input2 - A-matrix
%    input3 - B-matrix
%
% Outputs:
%    Obj - Generated Object
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: linearSys

% Author: Matthias Althoff
% Written: 23-January-2007 
% Last update: 15-May-2007
% Last revision: ---

%------------- BEGIN CODE --------------

% If no argument is passed
if nargin == 0
    disp('This class needs more input values');
    Obj=[];
    
% If 3 arguments are passed
elseif nargin == 3
    %List elements of the class
    Obj.A=varargin{2};  
    Obj.B=varargin{3};
    Obj.taylor=[];
    Obj.sample=[];
    
    %Generate parent object
    cDyn=contDynamics(varargin{1},ones(length(varargin{2}{1}),1),1,1);
    %...dimesnion is set according first cell matrix

    % Register the variable as an child object of contSet
    Obj = class(Obj, 'linIntSys', cDyn); 
    
    %create sample of object
    Obj=sample(Obj);
    
% If 4 arguments are passed
elseif nargin == 4
    %List elements of the class
    Obj.A=varargin{2};  
    Obj.B=varargin{3};
    Obj.sample=varargin{4}; %determines if samples should be created
    Obj.taylor=[];
    Obj.sample=[];
    
    %Generate parent object
    cDyn=contDynamics(varargin{1},ones(length(varargin{2}),1),1,1);

    % Register the variable as an child object of contSet
    Obj = class(Obj, 'linIntSys', cDyn); 
    
    if Obj.sample
        %create sample of object
        Obj=sample(Obj);   
    end
        
% Else if the parameter is an identical object, copy object    
elseif isa(varargin{1}, 'linIntSys')
    Obj = varargin{1};
    
% Else if not enough or too many inputs are passed    
else
    disp('This class needs more/less input values');
    Obj=[];
end

%------------- END OF CODE --------------