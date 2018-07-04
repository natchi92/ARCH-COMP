function [Zred,t]=reduceMethB(Z,filterLength)
% reduceMethB - prefilters longest generators and use exhaustive search
%
% Syntax:  
%    [Zred,t]=reduceMethB(Z)
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

% Author:       Matthias Althoff
% Written:      11-September-2008
% Last update:  06-March-2009
%               28-September-2010
% Last revision:---

%------------- BEGIN CODE --------------

tic;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');
dim=length(Zmatrix(:,1));

%extract generator matrix
G=Zmatrix(:,2:end);

%Delete zero-generators
G=nonzeroFilter(G);

%determine filter length
if filterLength(1)>length(G(1,:))
    filterLength(1)=length(G(1,:));
end


%length filter
G=lengthFilter(G,filterLength(1));

%reorder generators
Gcells=reorderingFilter(G);

%pick generator with the best volume
Gtemp=volumeFilter(Gcells,Z);
Gpicked=Gtemp{1};

%Build transformation matrix P
for i=1:dim
    P(:,i)=Gpicked(:,i);
end

%Project Zonotope into new coordinate system
Ztrans=pinv(P)*Z;
Zinterval=interval(Ztrans);
Zred=P*zonotope(Zinterval);

%time measurement
t=toc;


%------------- END OF CODE --------------
