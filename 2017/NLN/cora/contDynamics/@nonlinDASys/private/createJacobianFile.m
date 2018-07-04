function createJacobianFile(Jdyn,Jcon,path,name)
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
% Written:      27-October-2011
% Last update:  17-May-2013
%               25-June-2013
% Last revision: ---

%------------- BEGIN CODE --------------

    
% %load first order jacobians
% Jdyn = obj.derivative.firstOrder.dyn;
% Jcon = obj.derivative.firstOrder.con;

fid = fopen([path,'/jacobian_',name,'.m'],'w');
fprintf(fid, '%s\n\n', ['function [A,B,C,D,E,F]=jacobian_',name,'(x,y,u)']);

% DYNAMIC MATRICES
% write "A=["
fprintf(fid, '%s', 'A=[');
% write rest of matrix
if ~isempty(Jdyn.x)
    writeMatrix(Jdyn.x,fid);
else
    fprintf(fid, '%s', '];');
end

% write "B=["
fprintf(fid, '%s', 'B=[');
% write rest of matrix
if ~isempty(Jdyn.u)
    writeMatrix(Jdyn.u,fid);
else
    fprintf(fid, '%s', '];');
end


% write "C=["
fprintf(fid, '%s', 'C=[');
% write rest of matrix
if ~isempty(Jdyn.y)
    writeMatrix(Jdyn.y,fid);
else
    fprintf(fid, '%s', '];');
end


% INPUT MATRICES
% write "D=["
fprintf(fid, '%s', 'D=[');
% write rest of matrix
if ~isempty(Jcon.x)
    writeMatrix(Jcon.x,fid);
else
    fprintf(fid, '%s', '];');
end

% write "E=["
fprintf(fid, '%s', 'E=[');
% write rest of matrix
if ~isempty(Jcon.u)
    writeMatrix(Jcon.u,fid);
else
    fprintf(fid, '%s', '];');
end

% write "F=["
fprintf(fid, '%s', 'F=[');
% write rest of matrix
if ~isempty(Jcon.y)
    writeMatrix(Jcon.y,fid);
else
    fprintf(fid, '%s', '];');
end


%close file
fclose(fid);


%------------- END OF CODE --------------