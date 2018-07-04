function [Pred,t]=reduceMethH(Z)
% reduceMethH - reduces by intersecting two-dimensional projections of the 
% zonotope
%
% Syntax:  
%    [Pred,t]=reduceMethH(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    Pred - polytope of reduced zonotope
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author:       Matthias Althoff
% Written:      15-September-2008 
% Last update:  30-August-2016
% Last revision:---

%------------- BEGIN CODE --------------

tic;

%IMPORTANT-------------------------
%try all combinations of projected dimensions, which are 2 out of n
%combinations (n!/2!/(n-2)!)
%Maybe declare this as method Hb...
%However, method H is sufficient to construct a bounded polytope...
%----------------------------------

%obtain dimesnion
[dim,cols]=size(Z.Z);
nrOfGen=cols-1;

%generate Hinit
Hinit=zeros(nrOfGen*2,dim);

for i=1:(dim-1)
    %project zonotope
    Zproj=project(Z,[i i+1]);
    
    %convert projection to a polytope
    Pproj=polytope(Zproj);
    
    %fill remaining dimensions with zeros
    [Hproj,K] = double(Pproj);
    H=zeros(length(Hproj(:,1)),dim);
    H(:,[i,i+1])=Hproj;
    
    %generate temporal polytope
    Ptemp{i}=polytope(H,K);
end

%init Pred
Pred=Ptemp{1};
%compute intersections
for i=2:length(Ptemp)
    Pred = Pred & Ptemp{i};
end

%time measurement
t=toc;


%------------- END OF CODE --------------
