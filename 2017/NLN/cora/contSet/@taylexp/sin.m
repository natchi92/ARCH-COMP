function res = sin(inpVal)
% sin - Overloaded 'sin()' operator for a taylor expression
%
% Syntax:  
%    res = sin(inpVal, order)
%
% Inputs:
%    inpVal - (input value) a taylor expression object
%    order  - the cut-off order of the Taylor series. The constat term is
%    the zero order.
%
% Outputs:
%    res - a taylor expression object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: mtimes

% Author:       Dmitry Grebenyuk
% Written:      07-April-2016
% Last update:  ---
% Last revision:---


%------------- BEGIN CODE --------------
order = inpVal.order + 1; % to achive x^0 is the zero order
res = taylexp();

expPoint = (supremum(inpVal.remainder) + infimum(inpVal.remainder)) ./ 2;

res.numberOfCells_i = inpVal.numberOfCells_i;
res.numberOfCells_j = inpVal.numberOfCells_j;
%c = cell(inpVal.numberOfCells, 1);

for j = 1:inpVal.numberOfCells_j
    for i = 1:inpVal.numberOfCells_i
        %a = inpVal.coefficients(:,i,j);
        %x = poly2sym(a);
        x = inpVal.pol_syms{i,j};
        %syms x;
        T1 = taylor(sin(x), order, expPoint(i,j));
        res.pol_syms = T1;
        T = taylor(sin(x), x, 3*order, expPoint(i,j)); % (function, variable, order, expansion point)

        pol = sym2poly(T);
        c(:,i,j) = pol(end-order+1:end);
        
        coef = fliplr(pol);         % % the coefficients are from the lowest to the biggest
        rem1 = 0;
        
        factor3 = inpVal(i,j);
        factor3.remainder = interval(0, 0);
        
        claim = char(T1);
        new_claim = strrep(claim, '^', '.^');                
        rem11a = evalin('caller', new_claim);
        rem11 = rem11a(i,j);
        
        claim = char(T);
        new_claim = strrep(claim, '^', '.^');                
        rem12a = evalin('caller', new_claim);
        rem12 = rem12a(i,j);
        
        %factor3.coefficients = pol(end-order+1:end)';
        %rem11 = tayl2int(factor3);
        %factor3.coefficients = pol';
        %rem12 = tayl2int(factor3);
        
        if infimum(rem12) < infimum(rem11)
            rem1_inf = infimum(rem12) - infimum(rem11);
        else
            rem1_inf = 0;
        end
        if supremum(rem12) > supremum(rem11)
            rem1_sup = supremum(rem12) - supremum(rem11);
        else
            rem1_sup = 0;
        end
        rem1 = interval(rem1_inf, rem1_sup);
        
        %for k = order: 3*order - 1
        %    rem1 = rem1 + ((inpVal.domain(i,j)).^k) .* coef(k+1);
        %end
        res.remainder(i,j) = rem1;
    end
end

res.coefficients = c; % polynom
res.order = inpVal.order;
%res.expPoint = expPoint;
res.domain = inpVal.domain;

%if mod(order, 4) == 2
%    res.remainder = 1./factorial(order) .* sin(inpVal.domain) .* (inpVal.domain).^order; % interval remainder
%elseif mod(order, 4) == 3
%    res.remainder = 1./factorial(order) .* cos(inpVal.domain) .* (inpVal.domain).^order; % interval remainder
%elseif mod(order, 4) == 0
%    res.remainder = 1./factorial(order) .* -sin(inpVal.domain) .* (inpVal.domain).^order; % interval remainder
%else
%    res.remainder = 1./factorial(order) .* -cos(inpVal.domain) .* (inpVal.domain).^order; % interval remainder
%end

%------------- END OF CODE --------------
