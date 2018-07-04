function [newObj] = subsref(obj, S)
% subsref - Overloads the opertor that selects elements, e.g. I(1,2),
% where the element of the first row and second column is referred to.
%
% Syntax:  
%    [element] = subsref(obj, S)
%
% Inputs:
%    obj - a taylor expression object 
%    S - contains information of the type and content of element selections  
%
% Outputs:
%    element - element or elemets of the taylexp matrix
%
% Example: 
%    a=interval([-1 1], [1 2]);
%    b = taylexp(a, 6);
%    b(1,2)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Dmitry Grebenyuk
% Written:      18-April-2016 
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%obtain sub-intervals from the taylexp object
newObj = taylexp();
%check if parantheses are used to select elements
if strcmp(S.type,'()')
    % only one index specified
    if length(S.subs)==1
        %newObj.coefficients = cell(1, 1);
        newObj.coefficients=obj.coefficients(:,S.subs{1});  %{1} to be changed
        newObj.remainder=obj.remainder(S.subs{1});
        newObj.domain=obj.domain(S.subs{1});
        newObj.order = obj.order;
        newObj.numberOfCells = 1;  %old                         % = 1 to be changed
        newObj.numberOfCells_i = length(S.subs{1});                         % = 1 to be changed
        newObj.numberOfCells_j = 1;                         % = 1 to be changed
    %two indices specified
    elseif length(S.subs)==2 % here and below is out of order
        %Select column of obj
        if strcmp(S.subs{1},':')
            column=S.subs{2};
            newObj.inf=obj.inf(:,column);
            newObj.sup=obj.sup(:,column);
        %Select row of V    
        elseif strcmp(S.subs{2},':')
            row=S.subs{1};
            newObj.inf=obj.inf(row,:);
            newObj.sup=obj.sup(row,:);
        %Select single element of V    
        elseif isnumeric(S.subs{1}) & isnumeric(S.subs{2})        
            %newObj.coefficients{1, 1}=obj.coefficients{S.subs{1}, S.subs{2}};
            newObj.coefficients=obj.coefficients(:, S.subs{1}, S.subs{2});  %{1} to be changed
            newObj.remainder=obj.remainder(S.subs{1}, S.subs{2});
            newObj.domain=obj.domain(S.subs{1}, S.subs{2});
            newObj.order = obj.order;
            newObj.numberOfCells = 1;  %old                         % = 1 to be changed
            newObj.numberOfCells_i = length(S.subs{1});                         % = 1 to be changed
            newObj.numberOfCells_j = length(S.subs{2});                         % = 1 to be changed
        end
    end
end
%------------- END OF CODE --------------
