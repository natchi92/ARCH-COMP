function [Zred,t]=reducePCA(Z)
% reducePCA - apply principal component analysis
%
% Syntax:  
%    [Zred,t]=reducePCA(Z)
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
% Written:      18-October-2013
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

tic;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');

%extract generator matrix
G=Zmatrix(:,2:end);

%obtain matrix of points from generator matrix
V = [G,-G];

%compute the arithmetic mean of the vertices
mean=sum(V,2)/length(V(1,:));

%obtain sampling matrix
translation=mean*ones(1,length(V(1,:)));
sampleMatrix=V-translation;

%compute the covariance matrix
C=cov(sampleMatrix');

%singular value decomposition
[U,S,V] = svd(C);

%auxiliary computations
orientedMatrix=U'*sampleMatrix;


Ztrans = U.'*Z;
Zinterval = interval(Ztrans);
Zred = U*zonotope(Zinterval);


%time measurement
t=toc;

%------------- END OF CODE --------------
