function res = times(factor1, factor2)
% times - Overloaded '.*' operator for a taylor expression
%
% Syntax:  
%    res = times(factor1, factor2)
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
% Written:      07-April-2016
%               21-July-2016 (DG) the polynomial part is changed to syms
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------
if isa(factor1, 'taylexp') && isa(factor2, 'taylexp')
    
    order = max(factor1.order, factor2.order); % to achive x^0 is the zero order
    res = taylexp();

    res.numberOfCells_i = factor1.numberOfCells_i;
    res.numberOfCells_j = factor1.numberOfCells_j;
    res.remainder = interval();

    for j = 1:factor1.numberOfCells_j
        for i = 1:factor1.numberOfCells_i

            rem3 = 0;
            a = factor1.pol_syms{i,j};
            b = factor2.pol_syms{i,j};

            c = a * b;
            res.pol_syms{i,j} = c;
            %if any(factor1.coefficients(:,i,j)) == 0 & all(factor2.coefficients(:,i,j)) == 0 
            %    res.coefficients{j} = zeros(1, order + 1); 
            if 0
                a = polynom(factor1.coefficients(:,i,j));
                b = polynom(factor2.coefficients(:,i,j));

                c = a * b;
                vec = vector(c); % add shift
                coef = fliplr(vec);
                %rem3 = 0;
                if length(vec) > order + 1; % let's ((a1 + b1x) + I1) * (a2 + b2x) + I2), than here b1x * b2x
                    res.coefficients(:,i,j) = vec((length(vec) - order):length(vec));
                    factor3 = factor1(i,j);
                    factor3.remainder = interval(0, 0);
                    
                    %factor3.order = factor1.order .* factor2.order;
                    factor3.coefficients = vec((length(vec) - order):length(vec))';
                    rem31 = tayl2int(factor3);
                    factor3.coefficients = vec';
                    rem32 = tayl2int(factor3);
                    
                    if infimum(rem32) < infimum(rem31)
                        rem3_inf = infimum(rem32) - infimum(rem31);
                    else
                        rem3_inf = 0;
                    end
                    if supremum(rem32) > supremum(rem31)
                        rem3_sup = supremum(rem32) - supremum(rem31);
                    else
                        rem3_sup = 0;
                    end
                    rem3 = interval(rem3_inf, rem3_sup);
                    
                    %for k = (length(vec) - order+2) : (length(vec)-1)
                    %    %rem3 = rem3 + ((factor1.domain(j) - factor1.expPoint(j)).^i) .* coef(i+1);
                    %    rem3 = rem3 + (factor1.domain(j).^k) .* coef(k+1);
                    %end
                    %rem3
                else
                    res.coefficients(:,i,j) = vec;
                end   

            end

            res.order = order;

            %coef1 = fliplr(factor1.coefficients(:,i,j)')'; coef2 = fliplr(factor2.coefficients(:,i,j)')';
            rem2 = 0; rem1 = 0;
            
            %factor3.coefficients = factor1.coefficients(:,i,j);
            %rem2 = tayl2int(factor3) .* factor2.remainder(i,j);
            %for k = 0:(length(coef1)-1)
                %rem2 = rem2 + factor2.remainder(j) .* ((factor1.domain(j) - factor1.expPoint(j)).^i) .* coef1(i+1); % here I2 * (a1 + b1x)
                %rem1 = rem1 + factor1.remainder(j) .* ((factor2.domain(j) - factor2.expPoint(j)).^i) .* coef2(i+1); % here I1 * (a2 + b2x)
            %    rem2 = rem2 + factor2.remainder(i,j) .* (factor1.domain(j).^k) .* coef1(k+1); % here I2 * (a1 + b1x)
                %rem1 = rem1 + factor1.remainder(i,j) .* (factor2.domain(j).^k) .* coef2(k+1); % here I1 * (a2 + b2x)
            %end
            
            %factor3.coefficients = factor2.coefficients(:,i,j);
            %rem1 = tayl2int(factor3) .* factor1.remainder(i,j);
            %for k = 0:(length(coef2)-1)
            %    rem1 = rem1 + factor1.remainder(i,j) .* (factor2.domain(j).^k) .* coef2(k+1); % here I1 * (a2 + b2x)
            %end

            rem4 = factor1.remainder(i,j) .* factor2.remainder(i,j); % here I1 * I2

            res.remainder(i,j) = rem1 + rem2 + rem3 + rem4;

        end
    end

    res.domain = hull(factor1.domain, factor2.domain);
    
elseif isa(factor1, 'taylexp') && isa(factor2, 'interval')
    res = factor1;
    res.numberOfCells_i = factor1.numberOfCells_i;
    res.numberOfCells_j = factor1.numberOfCells_j;
    int1 = tayl2int(factor1);
    product = int1 .* factor2;
    tayl = taylexp(product, factor1.order);
    res.remainder = tayl.remainder;
    res.coefficients = tayl.coefficients;
    
elseif isa(factor1, 'interval') && isa(factor2, 'taylexp')
    res = factor2;
    res.numberOfCells_i = factor2.numberOfCells_i;
    res.numberOfCells_j = factor2.numberOfCells_j;
    int2 = tayl2int(factor2);
    product = int2 .* factor1;
    tayl = taylexp(product, factor2.order);
    res.remainder = tayl.remainder;
    res.coefficients = tayl.coefficients;
    
elseif isa(factor1, 'taylexp') && ~isa(factor2, 'taylexp')
    res = factor1;
    res.numberOfCells_i = factor1.numberOfCells_i;
    res.numberOfCells_j = factor1.numberOfCells_j;
    res.remainder = factor1.remainder * factor2;
    res.coefficients = factor1.coefficients .* factor2;
    for j = 1:factor1.numberOfCells_j
        for i = 1:factor1.numberOfCells_i 
            res.pol_syms{i, j} = factor1.pol_syms{i, j} * factor2;
        end
    end
elseif ~isa(factor1, 'taylexp') && isa(factor2, 'taylexp')
    res = factor2;
    res.numberOfCells = factor2.numberOfCells;
    res.numberOfCells_i = factor2.numberOfCells_i;
    res.numberOfCells_j = factor2.numberOfCells_j;
    res.remainder = factor2.remainder * factor1;
    res.coefficients = factor2.coefficients .* factor1;
    for j = 1:factor2.numberOfCells_j
        for i = 1:factor2.numberOfCells_i 
            res.pol_syms{i, j} = factor2.pol_syms{i, j} * factor1;
        end
    end
end
    
    

%------------- END OF CODE --------------