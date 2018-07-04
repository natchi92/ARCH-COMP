function create3rdOrderTensorFile(J3dyn,path)
% create3rdOrderTensorFile - generates an mFile that allows to compute the
% 3rd order terms 
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
% Written:      22-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------


for k=1:length(J3dyn(:,1,1,1))
    for l=1:length(J3dyn(1,:,1,1))
        Tdyn{k,l} = squeeze(J3dyn(k,l,:,:));
    end
end

fid = fopen([path '/thirdOrderTensor.m'],'w');
fprintf(fid, '%s\n\n', 'function [T]=thirdOrderTensor(x,u)');

%dynamic part
for k=1:length(Tdyn(:,1))
    for l=1:length(Tdyn(1,:))
        %get matrix size
        [rows,cols] = size(Tdyn{k,l});
        sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
        str=['T{',num2str(k),',',num2str(l),'} = interval(',sparseStr,',',sparseStr,');'];
        %write in file
        fprintf(fid, '\n\n %s\n\n', str);
        % write rest of matrix
        writeSparseMatrix(Tdyn{k,l},['T{',num2str(k),',',num2str(l),'}'],fid);

        disp(['dynamic index ',num2str(k),',',num2str(l)]);
    end
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