function [Z] = mtimes(factor1,factor2)
% mtimes - Overloaded '*' operator for the multiplication of a matrix or an
% interval matrix with a quadZonotope
%
% Syntax:  
%    [Z] = mtimes(matrix,Z)
%
% Inputs:
%    matrix - numerical or interval matrix
%    Z - quadZonotope object 
%
% Outputs:
%    Z - quadZonotpe after multiplication of a matrix with a quadZonotope
%
% Example: 
%    ---
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: plus

% Author:       Matthias Althoff
% Written:      04-September-2012 
% Last update:  18-March-2016
% Last revision:---

%------------- BEGIN CODE --------------

%Find a zonotope object
%Is factor1 a zonotope?
if strcmp('quadZonotope',class(factor1))
    %initialize resulting zonotope
    Z=factor1;
    %initialize other summand
    matrix=factor2;
%Is factor2 a zonotope?    
elseif strcmp('quadZonotope',class(factor2))
    %initialize resulting zonotope
    Z=factor2;
    %initialize other summand
    matrix=factor1;  
end

%numeric matrix
if isnumeric(matrix)
    Z.c=matrix*Z.c;
    Z.G=matrix*Z.G;
    Z.Gsquare=matrix*Z.Gsquare;
    Z.Gquad=matrix*Z.Gquad;
    Z.Grest=matrix*Z.Grest;

 
%interval matrix
elseif strcmp('interval',class(matrix))
    %get minimum and maximum
    M_min=infimum(matrix);
    M_max=supremum(matrix);
    %get center of interval matrix
    T=0.5*(M_max+M_min);
    %get symmetric interval matrix
    S=0.5*(M_max-M_min);
    
    %absolute sum of all generators
    Zabssum=sum(abs([Z.c, Z.G, Z.Gsquare, Z.Gquad, Z.Grest]), 2);
    
    %compute new zonotope
    Z.c = T*Z.c;
    Z.G = T*Z.G;
    Z.Gsquare = T*Z.Gsquare;
    Z.Gquad = T*Z.Gquad;
    Z.Grest = [T*Z.Grest, diag(S*Zabssum)];
    
    
%interval matrix 
elseif strcmp('intervalMatrix',class(matrix))
    %get minimum and maximum
    M_min=infimum(matrix.int);
    M_max=supremum(matrix.int); 
    %get center of interval matrix
    T=0.5*(M_max+M_min);
    %get symmetric interval matrix
    S=0.5*(M_max-M_min);
    
    %absolute sum of all generators
    Zabssum=sum(abs([Z.c, Z.G, Z.Gsquare, Z.Gquad, Z.Grest]), 2);
    
    %compute new zonotope
    Z.c = T*Z.c;
    Z.G = T*Z.G;
    Z.Gsquare = T*Z.Gsquare;
    Z.Gquad = T*Z.Gquad;
    Z.Grest = [T*Z.Grest, diag(S*Zabssum)];

    
%matrix zonotope 
elseif strcmp('matZonotope',class(matrix))
    
    disp('not yet implemented')
end    




%------------- END OF CODE --------------