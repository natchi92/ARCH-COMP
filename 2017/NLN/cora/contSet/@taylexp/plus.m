function res = plus(factor1, factor2)
% plus - Overloaded '+' operator for a taylor expression
%
% Syntax:  
%    res = plus(factor1, factor2)
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
%               21-July-2016 (DG) the polynomial part is changed to syms
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

if isa(factor1, 'taylexp') && isa(factor2, 'taylexp')
    order = max(factor1.order, factor2.order); % to achive x^0 is the zero order
    res = factor1;
    res.coefficients = 0;
    res.numberOfCells_i = factor1.numberOfCells_i;
    res.numberOfCells_j = factor1.numberOfCells_j;
    
    for j = 1:factor1.numberOfCells_j
        for i = 1:factor1.numberOfCells_i
            %T = polynom(factor1.coefficients(:,i,j)) + polynom(factor2.coefficients(:,i,j));
            %res.coefficients(1:length(vector(T)),i,j) = vector(T);
            res.pol_syms{i,j} = factor1.pol_syms{i,j} + factor2.pol_syms{i,j};
        end
    end
    res.remainder = factor1.remainder + factor2.remainder;
    res.order = order;

elseif isa(factor1, 'taylexp') && ~isa(factor2, 'taylexp')
    res = factor1;
    res.numberOfCells_i = factor1.numberOfCells_i;
    res.numberOfCells_j = factor1.numberOfCells_j;
    res.remainder = factor1.remainder; %+ factor2;
    for j = 1:factor1.numberOfCells_j
        for i = 1:factor1.numberOfCells_i
            %res.coefficients(length(factor1.coefficients(:,i,j)), i,j) = factor1.coefficients(length(factor1.coefficients(:,i,j)),i,j) + factor2;
            res.pol_syms{i,j} = factor1.pol_syms{i,j} + factor2;
        end
    end
elseif ~isa(factor1, 'taylexp') && isa(factor2, 'taylexp')
    res = factor2;
    res.numberOfCells_i = factor2.numberOfCells_i;
    res.numberOfCells_j = factor2.numberOfCells_j;
    res.remainder = factor2.remainder; %+ factor1;
    for j = 1:factor2.numberOfCells_j
        for i = 1:factor2.numberOfCells_i
            %res.coefficients(length(factor2.coefficients(:,i,j)),i,j) = factor2.coefficients(length(factor2.coefficients(:,i,j)),i,j) + factor1;
            res.pol_syms{i,j} = factor1 + factor2.pol_syms{i,j};
        end
    end
end

%------------- END OF CODE --------------

