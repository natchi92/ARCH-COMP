function createJacobianFile(Jdyn,path,name)
% createJacobianFile - generates an mFile that allows to compute the
% jacobian at a certain state and input
%
% Syntax:  
%    createJacobianFile(obj)
%
% Inputs:
%    Jdyn - jacobians
%    path - path where the function should be created
%    name - name of the nonlinear function to which the jacobian should
%    belong
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
% Last update:  05-August-2016
% Last revision:---

%------------- BEGIN CODE --------------


fid = fopen([path '/jacobian_',name,'.m'],'w');
fprintf(fid, '%s\n\n', ['function [A,B]=jacobian_',name,'(x,u)']);

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