function [Zred,t]=reduceMethAa(Z)
% reduceMethA - apply exhaustive search
%
% Syntax:  
%    [Zred,t]=reduceMethA(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    Zred - reduced zonotope
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author: Matthias Althoff
% Written: 11-September-2008
% Last update: 06-March-2009
% Last revision: ---

%------------- BEGIN CODE --------------


%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');
dim=length(Zmatrix(:,1));

%extract generator matrix
G=Zmatrix(:,2:end);

%Delete zero-generators
G=nonzeroFilter(G);

%reorder generators
Gcells=reorderingFilter(G);

tic;

%pick generator with the best volume
Gtemp=volumeFilter(Gcells,Z);
Gpicked=Gtemp{1};

%time measurement
t=toc;


%Build transformation matrix P
P=Gpicked;

%Project Zonotope into new coordinate system
Ztrans=inv(P)*Z;
Zinterval=interval(Ztrans);
Zred=P*zonotope(Zinterval);


%------------- END OF CODE --------------
