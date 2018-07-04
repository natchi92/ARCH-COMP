function res = minus(factor1, factor2)
% plus - Overloaded '-' operator for a taylor expression
%
% Syntax:  
%    res = minus(factor1, factor2)
%
% Inputs:
%    factor1 and factor2 - a taylor expression objects
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
% Written:      20-April-2016
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

if isa(factor1, 'taylexp') && isa(factor2, 'taylexp')
    order = max(factor1.order, factor2.order); % to achive x^0 is the zero order
    res = factor1;

    res.numberOfCells_i = factor1.numberOfCells_i;
    res.numberOfCells_j = factor1.numberOfCells_j;
    
    %if size(factor1.coefficients) == size(factor2.coefficients)
    %    res.coefficients = factor1.coefficients - factor2.coefficients;
    %else
        for j = 1:factor1.numberOfCells_j
            for i = 1:factor1.numberOfCells_i
               % a = polynom(factor1.coefficients(:,i,j));
                %b = polynom(factor2.coefficients(:,i,j));
                %c = a - b;
                %res.coefficients(:,i,j) = 0;
                %vec = vector(c);
                %res.coefficients(1:length(vec),i,j) = vec;
                res.pol_syms{i,j} = factor1.pol_syms{i,j} - factor2.pol_syms{i,j};
            end
        end
    %end
    res.remainder = factor1.remainder - factor2.remainder;
    res.order = order;
    
elseif isa(factor1, 'taylexp') && ~isa(factor2, 'taylexp')
    res = factor1;
    res.numberOfCells_i = factor1.numberOfCells_i;
    res.numberOfCells_j = factor1.numberOfCells_j;
    res.remainder = factor1.remainder; % - 1;
    for j = 1:factor1.numberOfCells_j
        for i = 1:factor1.numberOfCells_i
            %res.coefficients(length(factor1.coefficients(:,i,j)),i,j) = factor1.coefficients(length(factor1.coefficients(:,i,j)),i,j) - factor2;
            res.pol_syms{i,j} = factor1.pol_syms{i,j} - factor2;
        end
    end
elseif ~isa(factor1, 'taylexp') && isa(factor2, 'taylexp')
    res = -factor2;
    res.numberOfCells_i = factor2.numberOfCells_i;
    res.numberOfCells_j = factor2.numberOfCells_j;
    %res.remainder = res.remainder;
    for j = 1:factor2.numberOfCells_j
        for i = 1:factor2.numberOfCells_i
            %res.coefficients(length(factor2.coefficients(:,i,j)),i,j) = factor1 + res.coefficients(length(factor2.coefficients(:,i,j)),i,j);
            res.pol_syms{i,j} = factor1 - factor2.pol_syms{i,j};
        end
    end
end

%------------- END OF CODE --------------
 