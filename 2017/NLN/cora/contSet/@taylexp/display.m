function display(obj)
% display - Displays the Taylor expression
%
% Syntax:  
%    display(obj)
%
% Inputs:
%    obj - interval object
%
% Outputs:
%    ---
%
% Example: 
%    a = taylexp(exp(x), interval(-1, 1), 3);
%    display(a);
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Dmitry Grebenyuk
% Written:      31-March-2016
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%determine size of interval
%[rows, columns] = size(obj.inf);

name = [inputname(1), ' = '];
disp(name)

c = obj.pol_syms;

for j = 1:obj.numberOfCells_j
    %j
    rowStr = [];
    for i = 1:obj.numberOfCells_i
        %disp(poly2sym(obj.coefficients))
        ca = c{i,j};
        %disp(poly2sym(ca))
        %disp(' + ')
        remainder = sprintf('[%0.5f,%0.5f]',infimum(obj.remainder(i, j)),supremum(obj.remainder(i, j)));
        %disp(newStr)
        str = [char(ca), ' + ', remainder];
        
        rowStr = sprintf('%s \t %s',rowStr ,str);
       
    end
     disp(rowStr)
end
%for i = 1:rows
%    str = [];
%    % display one row
%    for j = 1:columns
%        newStr = sprintf('[%0.5f,%0.5f]',obj.inf(i,j),obj.sup(i,j));
%        str = [str,' ',newStr];
%    end
%    disp(str);
end

%------------- END OF CODE --------------