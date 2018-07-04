function [G] = symVariables(dim)
% symVariables - generates symbolic variables of the nonlinear system
%
% Syntax:  
%    [x,u] = symVariables(obj)
%
% Inputs:
%    obj - nonlinear system object
%    type - defines if 'LR' brackets should be used
%
% Outputs:
%    x - symbolic state variables
%    u - symbolic input variables
%
% Example: 
%    Text for example...
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author: Matthias Althoff
% Written: 01-April-2010
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------


%generate symbolic states
for i=1:dim
    for j=1:dim
        command=['G(',num2str(i),',',num2str(j),')=sym(''GL',num2str(i),num2str(j),'R'');'];
        eval(command);
    end
end


    


%------------- END OF CODE --------------