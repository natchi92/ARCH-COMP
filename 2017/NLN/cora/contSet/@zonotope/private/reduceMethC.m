function [Zred]=reduceMethC(Z,filterLength)
% reduceMethC - prefilters longest generators and generator sets that
% maximize their spanned volume. Use exhaustive search on filtered
% generators
%
% Syntax:  
%    [Pred]=reduceMethD(Z)
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
% Written:      11-September-2008
% Last update:  26-February-2009
%               27-August-2010
%               01-December-2010
%               12-August-2016
%               17-March-2017
% Last revision: ---

%------------- BEGIN CODE --------------


%automatically obtain normalization matrix
IH = interval(Z);
W = diag(2*rad(IH));
Winv = pinv(W);

%normalize zonotope
Z = Winv*Z;

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');
dim=length(Zmatrix(:,1));

%set default filter length
if isempty(filterLength)
    filterLength = [dim+8, dim+3];
end

%extract generator matrix
G=Zmatrix(:,2:end);

%Delete zero-generators
G=nonzeroFilter(G);

%G empty?
if ~isempty(G) && (length(G(1,:)) > length(G(:,1)))

    %determine filter length
    if filterLength(1)>length(G(1,:))
        filterLength(1)=length(G(1,:));
    end

    if filterLength(2)>length(G(1,:))
        filterLength(2)=length(G(1,:));
    end

    %length filter
    G=lengthFilter(G,filterLength(1));

    %apply generator volume filter
    Gcells=generatorVolumeFilter(G,filterLength(2));

    %pick generator with the best volume
    Gtemp=volumeFilter(Gcells,Z);
    Gpicked=Gtemp{1};

    %Build transformation matrix P; normalize for numerical stability
    for i=1:length(Gpicked)
        P(:,i)=Gpicked(:,i)/norm(Gpicked(:,i));
    end

    %Project Zonotope into new coordinate system
    Ztrans=pinv(P)*Z;
    Zinterval=interval(Ztrans);
    Zred=W*P*zonotope(Zinterval);
else
    Zred = zonotope(Zmatrix(:,1));
end

%------------- END OF CODE --------------
