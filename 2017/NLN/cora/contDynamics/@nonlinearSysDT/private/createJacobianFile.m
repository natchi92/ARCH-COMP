function createJacobianFile(Jdyn,path)
% createJacobianFile - generates an mFile that allows to compute the
% jacobian at a certain state and input
%
% Syntax:  
%    createJacobianFile(obj)
%
% Inputs:
%    obj - nonlinear DA system object
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
% Written:      21-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------


fid = fopen([path '/jacobian.m'],'w');
fprintf(fid, '%s\n\n', 'function [A,B]=jacobian(x,u)');

% DYNAMIC MATRICES
% write "A=["
fprintf(fid, '%s', 'A=[');
% write rest of matrix
writeMatrix(Jdyn.x,fid);

% write "B=["
fprintf(fid, '%s', 'B=[');
% write rest of matrix
writeMatrix(Jdyn.u,fid);


%close file
fclose(fid);


%------------- END OF CODE --------------