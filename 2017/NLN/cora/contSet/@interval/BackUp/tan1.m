function res = tan(intVal)
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
%if abs(x.inf) < pi/2 || abs(x.sup) >= pi/2 
%	res.inf = -inf;
%	res.sup = +inf;
%	return;
%end
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

%res.inf = tan(x.inf);
%res.sup = tan(x.sup);

for i = 1:length(intVal) 

    %sup - inf >= pi
    if intVal.sup(i) - intVal.inf(i) >= pi
        res.inf(i) = -Inf;
        res.sup(i) = +Inf;
    else
        %remove multiples of pi
        if intVal.inf(i) < 0
            inf = - mod(abs( intVal.inf(i) ), 2*pi);
        else
            inf = mod( intVal.inf(i), 2*pi);
        end
        if intVal.sup(i) < 0
            sup = - mod(abs( intVal.sup(i) ), 2*pi);
        else
            sup = mod( intVal.sup(i), 2*pi);
        end
        %inf = mod(intVal.inf(i), 2*pi);
        %sup = mod(intVal.sup(i), 2*pi);

        %inf in [-pi/2, pi/2]
        if inf > -pi/2 && inf < pi/2
            if  sup > -pi/2 && sup < pi/2 
                res.inf(i) = min(tan(inf), tan(sup));
                res.sup(i) = max(tan(inf), tan(sup));
            else 
                res.inf(i) = -Inf;
                res.sup(i) = +Inf;
            end
            
        %inf in [pi/2, 3*pi/2]
        elseif inf > pi/2 && inf < 3*pi/2
            if  ( sup > pi/2 && sup < 3*pi/2 ) || ( sup > -3*pi/2 && sup < -pi/2 )
                res.inf(i) = min(tan(inf), tan(sup));
                res.sup(i) = max(tan(inf), tan(sup));
            else 
                res.inf(i) = -Inf;
                res.sup(i) = +Inf;
            end
            
        %inf in [-3*pi/2, -pi/2]    
        elseif inf >= -3*pi/2 && inf < -pi/2
            if  ( sup > pi/2 && sup < 3*pi/2 ) || ( sup > -3*pi/2 && sup < -pi/2 )
                res.inf(i) = min(tan(inf), tan(sup));
                res.sup(i) = max(tan(inf), tan(sup));
            else 
                res.inf(i) = -Inf;
                res.sup(i) = +Inf;
            end
            
        %inf in [3*pi/2, 2*pi]
        elseif inf > 3*pi/2 && inf < 2*pi
            if  sup > 3*pi/2 && sup < 2*pi
                res.inf(i) = min(tan(inf), tan(sup));
                res.sup(i) = max(tan(inf), tan(sup));
            else 
                res.inf(i) = -Inf;
                res.sup(i) = +Inf;
            end
            
        %inf in [3*pi/2, 2*pi]    
        elseif inf > 3*pi/2 && inf < 2*pi
            if  sup > 3*pi/2 && sup < 2*pi
                res.inf(i) = min(tan(inf), tan(sup));
                res.sup(i) = max(tan(inf), tan(sup));
            else 
                res.inf(i) = -Inf;
                res.sup(i) = +Inf;
            end 
       
        end
        
    end

end


return;
%------------- END OF CODE --------------