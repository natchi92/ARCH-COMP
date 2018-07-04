function res = power(base,exponent)
% power - Overloaded '.^' operator for intervals (power)
%
% Syntax:  
%    res = power(base,exponent)
%
% Inputs:
%    base - interval object or numerical value
%    exponent - interval object or numerical value
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

% Author:       Dmitry Grebenyuk
% Written:      10-February-2016
% Last update:  15-March-2016   Faster version
% Last revision:---

% For an interval .^ an interger number
% [min(base.^exp), max(base.^exp)   if the exp is an interger and odd;
% [0, max(base.^exp)                if the exp is an interger and even.
%
% For an interval .^ a real number 
% [min(base.^exp), max(base.^exp)   if base.inf >= 0;
% [NaN, NaN]                        if otherwise.
%
% For a number .^ an interval
% [min(base.^exp), max(base.^exp)   if base.inf >= 0;
% [NaN, NaN]                        if otherwise.
%
% For an interval .^ an interval
% [min(base.^exp), max(base.^exp)   if base.inf >= 0;
% [NaN, NaN]                        if otherwise.

%------------- BEGIN CODE --------------

% an interval .^ a number
if isnumeric(exponent)
    
    res = base;

    %base1 = subsasgn(base, subs, 1 ./ base)
    if (abs(round(exponent) - exponent)) <= eps('double') & exponent < 0 & isscalar(exponent)
        res = (1 ./ base) .^ -exponent;
   
    % a positive integer exponent 
    elseif (abs(round(exponent) - exponent)) <= eps('double') & isscalar(exponent)
        res.inf = min(base.inf .^ exponent, base.sup .^ exponent);
        res.sup = max(base.inf .^ exponent, base.sup .^ exponent);   
    
        % special bechavior for even exponents
        if ~(mod(exponent,2)) && exponent ~= 0
            ind1 =  base.inf < 0 & base.sup > 0 & ~(mod(exponent,2)) & exponent ~= 0;
            res.inf(ind1) = 0;
        end
        
    elseif (abs(round(exponent) - exponent)) <= eps('double') & isscalar(base)
        
        ind1 = exponent < 0;
        oneover = 1 ./ base;
        res.inf(ind1) = min(oneover.inf .^ -exponent(ind1), oneover.sup .^ -exponent(ind1));
        res.sup(ind1) = max(oneover.inf .^ -exponent(ind1), oneover.sup .^ -exponent(ind1));
        
        
        ind1 = exponent >= 0;
        res.inf(ind1) = min(base.inf .^ exponent(ind1), base.sup .^ exponent(ind1));
        res.sup(ind1) = max(base.inf .^ exponent(ind1), base.sup .^ exponent(ind1));
        
        ind1 =  base.inf < 0 & base.sup > 0 & ~(mod(exponent,2)) & exponent ~= 0;
            res.inf(ind1) = 0   

    
    % a real exponent
    elseif isscalar(exponent)
        
        ind1 = base.inf >= 0;
        % an exponent is a scalar
        if isscalar(exponent)
            res.inf(ind1) = base.inf(ind1) .^ exponent;
            res.sup(ind1) = base.sup(ind1) .^ exponent;
        % an exponent is a matrix
        else
            res.inf(ind1) = base.inf(ind1) .^ exponent(ind1);
            res.sup(ind1) = base.sup(ind1) .^ exponent(ind1);
        end
        
        ind1 = base.inf < 0;
        
        res.inf(ind1) = NaN;
        res.sup(ind1) = NaN;
        
    else
        error('The input size is wrong.')

    end 

% a number .^ an inetrval    
elseif isnumeric(base)
    
    res = exponent;
    
    res.inf = min(base .^ exponent.inf, base .^ exponent.sup);
    res.sup = max(base .^ exponent.inf, base .^ exponent.sup);
        
    ind1 = base < 0 ;
    res.inf(ind1) = NaN;
    res.sup(ind1) = NaN;

% an interval .^ an interval   
else
    res = base;
        
        % to find the minimum and the maximum value from all combinations
        possibleValues = {base.inf .^ exponent.inf, base.inf .^ exponent.sup,...
            base.sup .^ exponent.inf, base.sup .^ exponent.sup};
        
        res.inf = possibleValues{1};
        res.sup = possibleValues{1};
        
        for i = 2:4
            res.inf = min(res.inf, possibleValues{i});
            res.sup = max(res.sup, possibleValues{i});
        end
    
    ind1 = base.inf < 0;
    res.inf(ind1) = NaN;
    res.sup(ind1) = NaN;
    
    
end
