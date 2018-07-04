function [Zred]=reduceAlthoff(Z,order,filterLength)
% reduceAlthoff - Zonotope reduction method.
%
% Syntax:  
%    [Zred]=reduceAlthoff(Z,order)
%
% Inputs:
%    Z - zonotope object
%    order - zonotope order
%
% Outputs:
%    Zred - reduced zonotope
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Matthias Althoff
% Written: 14-September-2007 
% Last update: 22-March-2007
%              07-January-2009
%              26-February-2009
% Last revision: ---

%------------- BEGIN CODE --------------


%initialize Z_red
Zred=Z;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');

%extract generator matrix
G=Zmatrix(:,2:end);

%determine dimension of zonotope
dim=length(G(:,1));

%only reduce if zonotope order is greater than the desired order
if length(G(1,:))>dim*order

    Zred=reduceMethD(Z,dim*(order-1),filterLength);
end

%------------- END OF CODE --------------
