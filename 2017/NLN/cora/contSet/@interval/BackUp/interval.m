classdef interval
% interval class 
%
% Syntax:  
%    object constructor: Obj = interval(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    input1 - left limit
%    input2 - right limit
%
% Outputs:
%    Obj - Generated Object
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: interval,  polytope

% Author:       Matthias Althoff
% Written:      19-June-2015
% Last update:  18-November-2015
% Last revision:---

%------------- BEGIN CODE --------------

properties (SetAccess = private, GetAccess = public)
    inf = [];
    sup = [];
    setting = 'sharpivmult';
end
    
methods 
    %class constructor
    function obj = interval(leftLimit,rightLimit)
        
        %no input
        if nargin==0
            obj.inf = [];
            obj.sup = [];
        
        %one input
        elseif nargin==1
            if isa(leftLimit,'interval')
                obj = leftLimit;
            elseif isnumeric(leftLimit)
                obj.inf = leftLimit;
                obj.sup = leftLimit;
            end
        %two inputs
        elseif nargin==2
            if isscalar(leftLimit)
                if leftLimit <= rightLimit
                    obj.inf = leftLimit;
                    obj.sup = rightLimit;
                else
                    disp('Left limit larger than right limit');
                end
            else
                if all(all(leftLimit <= rightLimit))
                    obj.inf = leftLimit;
                    obj.sup = rightLimit;
                else
                    disp('Left limit larger than right limit');
                end
            end
        end
%         % Register the variable as an object
%         obj = class(obj, 'interval');
    end
         
    %methods in seperate files 
    res = plus(summand1,summand2)
    res = minus(minuend,subtrahend)
    res = mtimes(factor1,factor2)
    res = mrdivide(numerator,denominator)
    res = mpower(base,exponent)
    intVal = uplus(intVal)
    intVal = uminus(intVal) 
    res = exp(exponent) %exponential function
    res = abs(value) %absolute value function
    res = sin(intVal) %sine function
    res = cos(intVal) %cosine function
    newObj = subsref(obj, S) % retrieves values from integer arrays
    obj = subsasgn(obj, S, value) % assigns values to integer arrays
    obj = horzcat(varargin) % horizontal concatenation (a = [b,c])
    obj = vertcat(varargin) % vertical concatenation (a = [b;c])
    res = isscalar(intVal) % checks if interval is scalar
    res = supremum(obj) % returns supremum
    res = infimum(obj) % returns infimum
    res = mid(obj) % returns center
    res = rad(obj) % returns radius
    obj = and(obj,otherObj) % intersection
    res = length(obj) % returns the length of the array
    
    %display functions
    display(obj)
end
end

%------------- END OF CODE -------