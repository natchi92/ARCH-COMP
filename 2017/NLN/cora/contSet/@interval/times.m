function res = times(factor1,factor2)
% times - Overloaded '.*' operator for intervals
%
% Syntax:  
%    res = times(factor1,factor2)
%
% Inputs:
%    factor1 - interval (for computational efficiency, no single value
%    considered; does not require type checking)
%    factor2 - interval (for computational efficiency, no single value
%    considered; does not require type checking)
%
% Outputs:
%    res - interval
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: mtimes

% Author:       Matthias Althoff
% Written:      19-June-2015
% Last update:  13-January-2016 (DG)
% Last revision:---

%------------- BEGIN CODE --------------

% an interval * a number
if isa(factor1, 'interval') && ~isa(factor2, 'interval')
    res = interval();
    res.inf = min(factor1.inf .* factor2, factor1.sup .* factor2);
    res.sup = max(factor1.inf .* factor2, factor1.sup .* factor2);
    
% a number * an interval
elseif ~isa(factor1, 'interval') && isa(factor2, 'interval')
    res = interval();
    res.inf = min(factor2.inf .* factor1, factor2.sup .* factor1);
    res.sup = max(factor2.inf .* factor1, factor2.sup .* factor1);

% an interval * an interval
else
    
    % intitialization of res as an interval
    res = factor1;

    % possible combinations
    possibleValues{1} = res.inf .* factor2.inf;
    possibleValues{2} = res.inf .* factor2.sup;
    possibleValues{3} = res.sup .* factor2.inf;
    possibleValues{4} = res.sup .* factor2.sup;

    % to find min and max
    res.inf = possibleValues{1};
    res.sup = possibleValues{1};

    for i = 2:4
        res.inf = min(res.inf, possibleValues{i});            
        res.sup = max(res.sup, possibleValues{i});            
    end
    
end



%------------- END OF CODE --------------