function obj = subsasgn(obj, S, value)
% subsasgn - Overloads the opertor that writes elements, e.g. I(1,2)=value,
% where the element of the first row and second column is referred to.
%
% Syntax:  
%    obj = subsasgn(obj, S, value)
%
% Inputs:
%    obj - taylexp object 
%    S - contains information of the type and content of element selections
%    value - value to be written
%
% Outputs:
%    obj - taylexp object 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Dmitry Grebenyuk
% Written:      04-May-2016 
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%check if value is an interval
if ~isa(value,'taylexp')
    value = taylexp(interval(value,value), obj.order);
end

if ~isa(obj,'taylexp')
    obj = taylexp();
end

%check if parantheses are used to select elements
if strcmp(S.type,'()')
    % only one index specified
    if length(S.subs)==1
        %newObj.coefficients = cell(1, 1);
        obj.coefficients(:,S.subs{1})=value.coefficients;  %{1} to be changed
        obj.remainder(S.subs{1})=value.remainder;
        obj.domain(S.subs{1})=value.domain;
        %obj.order = value.order;
        %obj.numberOfCells = 1;  %old                         % = 1 to be changed
        %obj.numberOfCells_i = length(S.subs{1});                         % = 1 to be changed
        %obj.numberOfCells_j = 1;                         % = 1 to be changed
    %two indices specified
    elseif length(S.subs)==2
        %Select column of obj
        if strcmp(S.subs{1},':')
            column=S.subs{2};
            obj.inf(:,column) = value.inf;
            obj.sup(:,column) = value.sup;
        %Select row of V    
        elseif strcmp(S.subs{2},':')
            row=S.subs{1};
            obj.inf(row,:) = value.inf;
            obj.sup(row,:) = value.sup;
        %Select single element of V    
        elseif isnumeric(S.subs{1}) & isnumeric(S.subs{2})        
            %newObj.coefficients{1, 1}=obj.coefficients{S.subs{1}, S.subs{2}};
            obj.coefficients(:, S.subs{1}, S.subs{2})=value.coefficients;  %{1} to be changed
            obj.remainder(S.subs{1}, S.subs{2})=value.remainder;
            obj.domain(S.subs{1}, S.subs{2})=value.domain;
            [obj.numberOfCells_i, obj.numberOfCells_j] = size(infimum(obj.remainder));
            if ~isempty(value.order)
                obj.order = value.order;
            end
            %obj.numberOfCells = 1;  %old                         % = 1 to be changed
            %obj.numberOfCells_i = length(S.subs{1});                         % = 1 to be changed
            %obj.numberOfCells_j = length(S.subs{2});                         % = 1 to be changed
        end
    end
end

%------------- END OF CODE --------------