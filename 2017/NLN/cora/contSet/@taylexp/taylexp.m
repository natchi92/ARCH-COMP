classdef taylexp
% taylexp (Taylor expression) class 
%
% Syntax:  
%    object constructor: Obj = interval(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    funct
%    intVal
%    order
%
% Outputs:
%    Obj - Generated Object
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: intervalhull,  polytope

% Author:       Dmitry Grebenyuk
% Written:      29-March-2016
% Last update:  ---
%               ---
% Last revision:---

%------------- BEGIN CODE --------------

properties (SetAccess = private, GetAccess = public)
    coefficients = [];
    remainder = interval();
    expPoint = [];
    order = [];
    domain = interval();
    setting = 'sharpivmult';
    numberOfCells = [];
    numberOfCells_i = [];
    numberOfCells_j = [];
    pol_syms = [];
end
    
methods 
    %class constructor
    function obj = taylexp(funct, order, variable, intVal)
        
        %no input
        if nargin==0
            obj.coefficients = [];
            obj.remainder = interval();
        %one input    
        elseif nargin==1
        obj.order = funct;
        %two inputs
        elseif nargin==2
            [numberOfCells_i, numberOfCells_j] = size(infimum(funct));
            obj.numberOfCells = length(infimum(funct));
            obj.numberOfCells_i = numberOfCells_i;
            obj.numberOfCells_j = numberOfCells_j;
            %obj.coefficients = cell(length(infimum(funct)), 1);
            %c = cell(length(infimum(funct)), 1);
            %obj.coefficients = zeros(1, order + 1);
            %for j = 1:obj.numberOfCells_j
            %    for i = 1:obj.numberOfCells_i
                    %obj.coefficients{i,j}(order + 1) = mid(funct(i,j));
                    %obj.coefficients{i,j}(order) = rad(funct(i,j));
            %    end
            %end
            obj.coefficients(order + 1, 1:numberOfCells_i, 1:numberOfCells_j) = mid(funct);
            obj.coefficients(order, 1:numberOfCells_i, 1:numberOfCells_j) = rad(funct);
            obj.expPoint = zeros(1, length(infimum(funct)));
            obj.remainder = interval(-zeros(numberOfCells_i, numberOfCells_j), zeros(numberOfCells_i, numberOfCells_j));
            %obj.domain = interval(-ones(numberOfCells_i, numberOfCells_j), ones(numberOfCells_i, numberOfCells_j));
            obj.domain = funct;
            obj.order = order;
            % uses to make an interval name as a polynomial variable
            name = char(inputname(1));
            syms(name);
            %syms name
            for j = 1:obj.numberOfCells_j
                for i = 1:obj.numberOfCells_i
                    %obj.pol_syms{i, j} = poly2sym(obj.coefficients(:, i, j), name);
                    obj.pol_syms{i, j} = poly2sym([1, 0], name);
                end
            end
            
            
        %four inputs
        elseif nargin==4
            
            expPoint = (supremum(intVal) - infimum(intVal)) ./ 2 ;
              
            T = taylor(funct, variable, order, expPoint); % (function, variable, order, expansion point)
            obj.coefficients = sym2poly(T);

            %poly2sym(obj.coefficients)
            
            %if isscalar(leftLimit)
            %    if leftLimit <= rightLimit
            %        obj.center = 0.5*(rightLimit + leftLimit);
            %        obj.noise = 0.5*(rightLimit - leftLimit);
            %    else
            %        disp('Left limit larger than right limit');
            %    end
            %else
            %    if all(all(leftLimit <= rightLimit))
            %        obj.center = 0.5*(rightLimit + leftLimit);
            %        obj.noise = 0.5*(rightLimit - leftLimit);
            %    else
            %        disp('Left limit larger than right limit');
            %    end
            %end
        else
            error('Wrong input')
        end
%         % Register the variable as an object
%         obj = class(obj, 'interval');
    end
         
    %methods in seperate files 
%     res = plus(summand1,summand2)
%     res = minus(minuend,subtrahend)
     res = times(factor1, factor2)
     res = mtimes(factor1,factor2)
%     res = mrdivide(numerator,denominator)
     res = mpower(base,exponent)
     res = power(base,exponent)
%     intVal = uplus(intVal)
     obj = uminus(obj) 
     res = exp(exponent, order) %exponential function
%     res = abs(value) %absolute value function
     res = sin(inpVal, order) %sine function
     res = cos(inpVal, order) %cosine function
%     res = tan(intVal) %tangent function
     newObj = subsref(obj, S) % retrieves values from arrays
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
     res = tayl2intGl1(obj, var1, eps) % convert a taylor expression to an interval (object, beginning, end) using the global optimization
     res = tayl2intGl2(obj, var1, var2, eps) % two variables
     res = tayl2intGl3(obj, var1, var2, var3, eps) %tree variables
    
    %display functions
    display(obj)
end
end

%------------- END OF CODE -------