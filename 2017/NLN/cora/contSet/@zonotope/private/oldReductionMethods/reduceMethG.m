function [Pred,t]=reduceMethG(Z,nrOfIntersections)
% reduceMethG - like method Fd, but with intersection of several
% parallelotopes
%
% Syntax:  
%    [Pred,t,vol]=reduceMethG(Z)
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

% Author: Matthias Althoff
% Written: 11-September-2008 
% Last update: ---
% Last revision: ---

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
filterLength1=dim+8;
%filterLength1=dim+5;
if filterLength1>length(G(1,:))
    filterLength1=length(G(1,:));
end
filterLength2=dim+3;
if filterLength2>length(G(1,:))
    filterLength2=length(G(1,:));
elseif filterLength2<nrOfIntersections
    filterLength2=nrOfIntersections;
end

%length filter
G=lengthFilter(G,filterLength1);

%apply generator volume filter
Gcells=generatorVolumeFilter(G,filterLength2);

%pick generator with the best volume
Gpicked=volumeFilter(Gcells,Z,nrOfIntersections);


for iParallelotope=1:length(Gpicked)
    
    G=Gpicked{iParallelotope};

    %Build transformation matrix P
    for i=1:dim
        P(:,i)=G(:,i);
    end

    %Project Zonotope into new coordinate system
    Ztrans=inv(P)*Z;
    Zinterval=interval(Ztrans);
    Zred=P*zonotope(Zinterval);
    
    %generate polytopes
    PredNew=parallelpiped(Zred);
    
    if iParallelotope==1
        Pred=PredNew;
    else
        Pred=Pred&PredNew;
    end
end

% %determine bounding box <-- CHANGED!!!!
% Zbound=reduceGirard(Z,1);
% %generate polytopes
% Pbound=parallelotope(Zbound);
% %intersect both solutions
% Pred=Pred&Pbound;

%time measurement
t=toc;


%------------- END OF CODE --------------
