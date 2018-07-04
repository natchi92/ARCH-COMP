function Obj = parallelHybridAutomaton(varargin)
% hybridAutomaton - Object and Copy Constructor 
%
% Syntax:  
%    object constructor: Obj = class_name(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    input1 - component array
%
% Outputs:
%    Obj - Generated Object
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author: Victor CHARLENT
% Written: 24-May-2016  
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------


% If no argument is passed (default constructor)
if nargin == 0
    disp('ParallelHybridAutomaton needs more input values');
    Obj=[];
    % Register the variable as an object
    Obj = class(Obj, 'parallelHybridAutomaton');    
    
% If 1 argument is passed
elseif nargin == 1
    %List elements of the class
    Obj.components=varargin{1};
    Obj.result=[];

    % Register the variable as an object
    Obj = class(Obj, 'parallelHybridAutomaton');
        
% Else if the parameter is an identical object, copy object    
elseif isa(varargin{1}, 'parallelHybridAutomaton')
    Obj = varargin{1};
    
% Else if not enough or too many inputs are passed    
else
    disp('This class needs more/less input values');
    Obj=[];
end

%------------- END OF CODE --------------