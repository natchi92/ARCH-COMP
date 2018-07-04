classdef affexp
% affexp (affine expression) class 
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
% Written:      18-March-2016
% Last update:  ---
%               ---
% Last revision:---

%------------- BEGIN CODE --------------

properties (SetAccess = private, GetAccess = public)
    inf = [];
    sup = [];
    setting = 'sharpivmult';
end
    
methods 
    %class constructor
    function obj = affexp(leftLimit,rightLimit)
        
        %no input
        if nargin==0
            obj.center = [];
            obj.noise = [];
        
        %one input
        elseif nargin==1
            if isa(leftLimit,'interval')
                obj = leftLimit;
            elseif isnumeric(leftLimit)
                obj.center = leftLimit;
                obj.noise = [];
            end
        %two inputs
        elseif nargin==2
            if isscalar(leftLimit)
                if leftLimit <= rightLimit
                    obj.center = 0.5*(rightLimit + leftLimit);
                    obj.noise = 0.5*(rightLimit - leftLimit);
                else
                    disp('Left limit larger than right limit');
                end
            else
                if all(all(leftLimit <= rightLimit))
                    obj.center = 0.5*(rightLimit + leftLimit);
                    obj.noise = 0.5*(rightLimit - leftLimit);
                else
                    disp('Left limit larger than right limit');
                end
            end
        end
%         % Register the variable as an object
%         obj = class(obj, 'interval');
    end
         
    %methods in seperate files 
%     res = plus(summand1,summand2)
%     res = minus(minuend,subtrahend)
%     res = mtimes(factor1,factor2)
%     res = mrdivide(numerator,denominator)
%     res = mpower(base,exponent)
%     intVal = uplus(intVal)
%     intVal = uminus(intVal) 
%     res = exp(exponent) %exponential function
%     res = abs(value) %absolute value function
%     res = sin(intVal) %sine function
%     res = cos(intVal) %cosine function
%     res = tan(intVal) %tangent function
%     newObj = subsref(obj, S) % retrieves values from arrays
%     obj = subsasgn(obj, S, value) % assigns values to arrays
%     obj = horzcat(varargin) % horizontal concatenation (a = [b,c])
%     obj = vertcat(varargin) % vertical concatenation (a = [b;c])
%     res = isscalar(intVal) % checks if interval is scalar
%     res = supremum(obj) % returns supremum
%     res = infimum(obj) % returns infimum
%     res = mid(obj) % returns center
%     res = rad(obj) % returns radius
%     obj = and(obj,otherObj) % intersection
%     res = length(obj) % returns the length of the array
%     res = sqrt(obj) % returns the square root
%     varargout = size(obj) % returns size of object
%     res = sinh(intVal) %hyperbolic sine function
%     res = cosh(intVal) %hyperbolic cosine function
%     res = tanh(intVal) %hyperbolic tangent function
    
    %display functions
    disp(obj)
end
end

%------------- END OF CODE -------