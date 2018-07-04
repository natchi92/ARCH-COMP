function res = tayl2int(varargin)
% tayl2int - convert a taylor expression to an interval (object, beginning, end)
%
% Syntax:  
%    res = tayl2int(obj)
%
% Inputs:
%    obj - (input value) a taylor expression object
%    
%
% Outputs:
%    res - an interval object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%

% Author:       Dmitry Grebenyuk
% Written:      18-April-2016
% Last update:  ---
% Last revision:---


%------------- BEGIN CODE --------------
res = interval();

obj = varargin{1};

for j = 1:obj.numberOfCells_j
    for i = 1:obj.numberOfCells_i
         
        %vec = obj.coefficients(:,i,j);  % the coefficients are from the biggest to the lowest
        %if numel(varargin) > 1
        %    beginn = varargin{2};
        %    vec(length(vec) - beginn + 1:length(vec)) = 0;
        %end
        %coef = fliplr(vec')';         % % the coefficients are from the lowest to the biggest
        %rem1 = 0;
        
        % here extremum calculations are placed
        if 0
        
        d_vec = polyder(vec);
        
        rts = roots(d_vec);
        
        real_rts = rts(rts == real(rts));
        
        x = linspace(-1, 1);
        y = polyval(vec, x);
        plot(x, y)
        %hold on
        
        %pol = polynom(obj.coefficients(:,i,j))
        extremums = polyval(vec, real_rts(real_rts >= -1 & real_rts <= 1));
        
        low_boundery = min(polyval(vec, -1), polyval(vec, 1));
        high_boundery = max(polyval(vec, -1), polyval(vec, 1));
        
        if ~isempty(extremums)
            interval_min = low_boundery;
            interval_max = high_boundery;
            for i1 = 1:length(extremums)
                interval_min = min(interval_min, extremums(i1));
            	interval_max = max(interval_max, extremums(i1));
            end
        else
            interval_min = low_boundery;
            interval_max = high_boundery;
        end
        
        rem1 = interval(interval_min, interval_max);
        
        end
        
        
        % the end of extra piece
        if 1

        %for k = 0 : (length(vec)-1)
            %rem1 = rem1 + ((obj.domain(i,j)).^k) .* coef(k+1);
        %end
        %for j = 1:obj.numberOfCells_j
            %for i = 1:obj.numberOfCells_i
                % change the ^'s to the .^'s to preserve work in vector
                % case
                claim = char(obj.pol_syms{i, j});
                new_claim = strrep(claim, '^', '.^');
                
                rem11 = evalin('caller', new_claim);
                rem1 = rem11(i,j);
            %end
        %end
        
        end

        rem2 = obj.remainder(i,j);

        res(i,j) = rem1 + rem2;
    
    end
end
%test_answer



%------------- END OF CODE --------------
