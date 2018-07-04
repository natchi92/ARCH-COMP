function res = rdivide(numerator, denominator)
% rdivide - Overloads the ./ operator that provides elementwise division of 
% two matrices
%
% Syntax:  
%    res = rdivide( numerator, denominator )
%
% Inputs:
%    numerator, denominator - taylexp objects
%
% Outputs:
%    res - a taylexp object after elementwise division
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%

% Author:       Dmitry Grebenyuk
% Written:      07-February-2016
% Last update:  13-March-2016       Speed improvement
% Last revision:---

%------------- BEGIN CODE --------------

if isa(numerator, 'taylexp') && ~isa(denominator, 'taylexp')
    res = numerator;
    %res.coefficients = numerator.coefficients ./ denominator;
    for j = 1:numerator.numberOfCells_j
        for i = 1:numerator.numberOfCells_i
            res.pol_syms{i,j} = numerator.pol_syms{i,j} ./ denominator;
        end
    end
    res.remainder = numerator.remainder ./ denominator;
    
elseif isa(numerator, 'taylexp') && isa(denominator, 'taylexp')
    
    %res = numerator;
    new = 1./ tayl2int(denominator);
    new1 = taylexp(new, denominator.order);
    res = numerator .* new1;
    %res.coefficients = numerator.coefficients;
    %res.remainder = numerator.remainder ./ tayl2int(denominator);
    
elseif ~isa(numerator, 'taylexp') && isa(denominator, 'taylexp')
    
    new = 1./ tayl2int(denominator);
    res = numerator .* taylexp(new, denominator.order);
    
end

%------------- END OF CODE --------------