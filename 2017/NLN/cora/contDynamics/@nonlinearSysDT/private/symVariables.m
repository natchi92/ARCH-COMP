function [x,u,dx,du] = symVariables(varargin)
% symVariables - generates symbolic variables of the nonlinDA system
%
% Syntax:  
%    [x,y,u,dx,dy,du] = symVariables(obj)
%
% Inputs:
%    obj - nonlinear DA system object
%    type - defines if 'LR' brackets should be used
%
% Outputs:
%    x - symbolic state variables
%    y - symbolic constraint variables
%    u - symbolic input variables
%    dx - symbolic state deviation form linearization point
%    dx - symbolic constraint deviation form linearization point
%    du - symbolic input deviation form linearization point
%
% Example: 
%    Text for example...
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      21-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

if nargin==1
    obj=varargin{1};
    type=[];
elseif nargin==2
    obj=varargin{1};
    type=varargin{2};
end


if strcmp(type,'LRbrackets')
    %generate symbolic states
    for i=1:obj.dim
        command=['x(',num2str(i),',1)=sym(''xL',num2str(i),'R'');'];
        eval(command);
    end

    %generate symbolic inputs
    for i=1:obj.nrOfInputs
        command=['u(',num2str(i),',1)=sym(''uL',num2str(i),'R'');'];
        eval(command);
    end    
    
    %generate linearization point of the state
    for i=1:obj.dim
        command=['dx(',num2str(i),',1)=sym(''dxL',num2str(i),'R'');'];
        eval(command);
    end  

    %generate linearization point of the input
    for i=1:obj.nrOfInputs
        command=['du(',num2str(i),',1)=sym(''duL',num2str(i),'R'');'];
        eval(command);
    end     
    
elseif ~strcmp(type,'LRbrackets')
    %generate symbolic states
    for i=1:obj.dim
        command=['x(',num2str(i),',1)=sym(''x',num2str(i),''');'];
        eval(command);
    end  

    %generate symbolic inputs
    for i=1:obj.nrOfInputs
        command=['u(',num2str(i),',1)=sym(''u',num2str(i),''');'];
        eval(command);
    end
    
    %generate linearization point of the state
    for i=1:obj.dim
        command=['dx(',num2str(i),',1)=sym(''dx',num2str(i),''');'];
        eval(command);
    end

    %generate linearization point of the input
    for i=1:obj.nrOfInputs
        command=['du(',num2str(i),',1)=sym(''du',num2str(i),''');'];
        eval(command);
    end    
else
    %default values
    x = [];
    y = [];
    u = [];
    dx = [];
    dy = [];
    du = [];
end


%------------- END OF CODE --------------