function createHessianTensorFile(J2dyn,path,name,infsupFlag)
% createHessianTensorFile - generates an mFile that allows to compute the
% hessian tensor
%
% Syntax:  
%    createHessianTensorFile(obj,path)
%
% Inputs:
%    obj - nonlinear system object
%    path - path for saving the file
%    name - name of the nonlinear function to which the hessian belongs
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
% Last update:  08-March-2017
% Last revision:---

%------------- BEGIN CODE --------------


for k=1:length(J2dyn(:,1,1))
    Hdyn{k} = squeeze(J2dyn(k,:,:));
end

fid = fopen([path '/hessianTensor_',name,'.m'],'w');
fprintf(fid, '%s\n\n', ['function [H]=hessianTensor_',name,'(x,u)']);

%dynamic part
for k=1:length(Hdyn)
    %get matrix size
    [rows,cols] = size(Hdyn{k});
    sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
    if infsupFlag 
        str=['H{',num2str(k),'} = interval(',sparseStr,',',sparseStr,');'];
        %str=['H{',num2str(k),'} = infsup(',sparseStr,',',sparseStr,');']; %for INTLAB
    else
        str=['H{',num2str(k),'} = ',sparseStr,';'];
    end
    %write in file if Hessian is used as Lagrange remainder
    fprintf(fid, '\n\n %s\n\n', str);
    % write rest of matrix
    writeSparseMatrix(Hdyn{k},['H{',num2str(k),'}'],fid);
    
    disp(['dynamic dim ',num2str(k)]);
end

%close file
fclose(fid);



%------------- END OF CODE --------------