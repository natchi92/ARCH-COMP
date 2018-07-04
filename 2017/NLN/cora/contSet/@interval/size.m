function [varargout] = size(obj)
% size - Overloads the opertor that returns the size of the object
%
% Syntax:  
%    varargout = size(obj)
%
% Inputs:
%    obj - interval object 
%
% Outputs:
%    varargout - varying outputs, see 'doc size'
%
% Example: 
%    a=interval([-1 1], [1 2]);
%    size(a)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      26-January-2016 
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%return size of infimum
[varargout{1:nargout}] = size(obj.inf);

%------------- END OF CODE --------------