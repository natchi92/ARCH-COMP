function createHessianTensorFile(J2dyn,path,infsupFlag)
% createHessianTensorFile - generates an mFile that allows to compute the
% hessian tensor
%
% Syntax:  
%    createHessianTensorFile(obj,path)
%
% Inputs:
%    obj - nonlinear system object
%    path - path for saving the file
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


for k=1:length(J2dyn(:,1,1))
    Hdyn{k} = squeeze(J2dyn(k,:,:));
end

fid = fopen([path '/hessianTensor.m'],'w');
fprintf(fid, '%s\n\n', 'function [H]=hessianTensor(x,u)');

%dynamic part
for k=1:length(Hdyn)
    %get matrix size
    [rows,cols] = size(Hdyn{k});
    sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
    if infsupFlag 
        str=['H{',num2str(k),'} = interval(',sparseStr,',',sparseStr,');'];
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


function writeSparseMatrix(M,var,fid)


%write each row
for iRow=1:(length(M(:,1)))
    for iCol=1:(length(M(1,:)))
        if M(iRow,iCol)~=0
            str=bracketSubs(char(M(iRow,iCol)));
            str=[var,'(',num2str(iRow),',',num2str(iCol),') = ',str,';'];
            %write in file
            fprintf(fid, '%s\n', str);
        end
    end
end



function [str]=bracketSubs(str)

%generate left and right brackets
str=strrep(str,'L','(');
str=strrep(str,'R',')');

%------------- END OF CODE --------------