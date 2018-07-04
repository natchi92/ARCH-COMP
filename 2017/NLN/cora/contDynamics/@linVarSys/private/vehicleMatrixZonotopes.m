function [zA] = vehicleMatrixZonotopes(zAcell, p, uTrans, c)
% vehicleMatrixZonotopes - specific functiontion for the vehicle dynamics to
% provide the matrix zonotopes
%
% Syntax:  
%    zA = vehicleMatrixZonotopes(zAcell, p, uTrans)
%
% Inputs:
%    zAcell - system matrix cell
%    p - parameter vector
%    uTrans - current input
%
% Outputs:
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Matthias Althoff
% Written:      26-April-2011
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

syms uL3R
syms xL1R xL2R xL4R 

%substitute input values
for i=[1 2 3]
    zAcell{i} = subs(zAcell{i},uL3R,uTrans(3));
end

%substitute linearization point
zAcell{1} = subs(zAcell{1},[xL1R, xL2R, xL4R],[c(1), c(2), c(4)]);

%get centers and normalized deltas
pCenter = mid(p);
pDelta = rad(p);


%normalize cell matrices
%system matrix
AnormCenter = 0*zAcell{1};
counter = 1;

%generators for A
for i=1:length(zAcell)
    %add center matrices
    AnormCenter = AnormCenter + double(pCenter(i)*zAcell{i});
    %if a prototype generator is "activated"
    if pDelta(i)>0
        Anorm{counter} = double(pDelta(i)*zAcell{i});
        counter = counter+1;
    end
end


%generate zonotope matrices
zA = matZonotope(AnormCenter, Anorm);


%------------- END OF CODE --------------