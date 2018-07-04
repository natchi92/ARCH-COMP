function plot3d(V);
% plot - Plots convex hull of vertices that are projected onto 3d
%
% Syntax:  
%    plot(V)
%
% Inputs:
%    V - vertices object 
%
% Outputs:
%    none
%
% Example: 
%    V=vertices(rand(3,6));
%    plot(V)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author: Matthias Althoff
% Written: 06-October-2007
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

%Obtain x- and y- coordinates of potential vertices
xPotential=V.V(1,:);
yPotential=V.V(2,:);
zPotential=V.V(3,:);

%Plot if there are more than three points
if length(xPotential)>3
    %determine vertex indices for convex hull vertices from potential
    %vertices 
    vertexIndices=convhulln([xPotential',yPotential',zPotential']);
else
    vertexIndices=[1 2 3];
end
    %Select convex hull vertices
    xCoordinates=xPotential(vertexIndices);
    yCoordinates=yPotential(vertexIndices);
    zCoordinates=zPotential(vertexIndices);

    %Plot convex hull and crosses for vertices
    %plot(xCoordinates,yCoordinates,'b-',...
    %     xCoordinates,yCoordinates,'r+');
    plot3(xCoordinates,yCoordinates,zCoordinates,'b-');     


%------------- END OF CODE --------------