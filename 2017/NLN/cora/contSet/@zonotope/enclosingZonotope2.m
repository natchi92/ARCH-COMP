function [Zenclose] = enclosingZonotope2(Zfirst,V,options)
% polytope - Converts a zonotope to a polytope representation
%
% Syntax:  
%    [P] = polytope(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    P - polytope object
%
% Example: 
%    Z=zonotope(rand(2,5));
%    P=polytope(Z);
%    plot(P);
%    hold on
%    plot(Z);
%
% Other m-files required: vertices, polytope
% Subfunctions: none
% MAT-files required: none
%
% See also: intervalhull,  vertices

% Author: Matthias Althoff
% Written: 02-October-2008
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

%set rotation increment
deltaAngle=0.1;

%delete empty vertices cells
i=1;
while i<=length(V)
    if isempty(V{i})
        V(i)=[];
    else
        i=i+1;
    end
end

Vsum=V{1};
for i=2:length(V)
   newPoints=length(V{i});
   Vsum(:,(end+1):(end+newPoints))=V{i};
end

if ~isempty(V)
    Vsum=vertices(Vsum);
    [iAxis,relImpr] = evaluateRotations(Vsum,deltaAngle);
    

    
else
    Zenclose=[];
end


    
%------------- END OF CODE --------------