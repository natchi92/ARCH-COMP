function res = tan(x)
% tan - Overloaded 'tan()' operator for intervals
%
% Syntax:  
%    res = tan(intVal)
%
% Inputs:
%    intVal - interval object
%
% Outputs:
%    res - interval object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: mtimes

% Author:       Daniel Althoff
% Written:      03-November-2015
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%init res
res = interval();

% both bigger or smaller than +/-pi/2
% >= pi/2 to map behavior of Intlab
if abs(x.inf) < pi/2 || abs(x.sup) >= pi/2 
	res.inf = -inf;
	res.sup = +inf;
	return;
    
end
% 
% % inferior
% if x.inf < pi/2
% 	x.inf = -inf;
% end
% 
% % superior
% if x.sup > pi/2
% 	x.sup = + inf;
% end

res.inf = tan(x.inf);
res.sup = tan(x.sup);


return;
%------------- END OF CODE --------------
