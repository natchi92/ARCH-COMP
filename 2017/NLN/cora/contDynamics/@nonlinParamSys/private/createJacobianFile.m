function createJacobianFile(obj)
% createJacobianFile - generates an mFile that allows to compute the
% jacobian at a certain state and input
%
% Syntax:  
%    createJacobianFile(obj)
%
% Inputs:
%    obj - nonlinear parametric system object
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
% Written:      27-May-2011
% Last update:  ---
% Last revision: ---

%------------- BEGIN CODE --------------

    
%load first order jacobians
Jp = obj.derivative.firstOrderParam;


fid = fopen([coraroot '/contDynamics/stateSpaceModels/jacobian.m'],'w');
fprintf(fid, '%s\n\n', 'function [A,B]=jacobian(x,u)');

% SYSTEM MATRICES
for iMatrix = 1:length(Jp.x)
    % write "A{i}=["
    fprintf(fid, '%s', 'A{', num2str(iMatrix),'}=[');
    % write rest of matrix
    writeMatrix(Jp.x{iMatrix},fid);
end


% INPUT MATRICES
for iMatrix = 1:length(Jp.u)
    % write "B{i}=["
    fprintf(fid, '%s', 'B{', num2str(iMatrix),'}=[');
    % write rest of matrix
    writeMatrix(Jp.u{iMatrix},fid);
end


%close file
fclose(fid);


%------------- END OF CODE --------------