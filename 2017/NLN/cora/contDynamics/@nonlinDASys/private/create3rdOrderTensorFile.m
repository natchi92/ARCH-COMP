function create3rdOrderTensorFile(J3dyn,J3con,path,name)
% create3rdOrderTensorFile - generates an mFile that allows to compute the
% 3rd order tensor
%
% Syntax:  
%    create3rdOrderTensorFile(J3dyn,J3con,path,name)
%
% Inputs:
%    J3dyn - 3rd order tensor (dynamic part)
%    J3con - 3rd order tensor (constraint part)
%    path - path for saving the file
%    name - name for file name extension
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
% Written:      20-June-2013
% Last update:  16-June-2016
% Last revision:---

%------------- BEGIN CODE --------------

%rearrange dynamic part
for k=1:length(J3dyn(:,1,1,1))
    for l=1:length(J3dyn(1,:,1,1))
        Tdyn{k,l} = squeeze(J3dyn(k,l,:,:));
    end
end
%rearrange constraint part
for k=1:length(J3con(:,1,1,1))
    for l=1:length(J3con(1,:,1,1))
        Tcon{k,l} = squeeze(J3con(k,l,:,:));
    end
end

fid = fopen([path,'/thirdOrderTensor_',name,'.m'],'w');
fprintf(fid, '%s\n\n', ['function [Tf,Tg]=thirdOrderTensor_',name,'(x,y,u)']);

%dynamic part
for k=1:length(Tdyn(:,1))
    for l=1:length(Tdyn(1,:))
        %get matrix size
        [rows,cols] = size(Tdyn{k,l});
        sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
        str=['Tf{',num2str(k),',',num2str(l),'} = interval(',sparseStr,',',sparseStr,');'];
        %write in file
        fprintf(fid, '\n\n %s\n\n', str);
        % write rest of matrix
        writeSparseMatrix(Tdyn{k,l},['Tf{',num2str(k),',',num2str(l),'}'],fid);

        disp(['dynamic index ',num2str(k),',',num2str(l)]);
    end
end


%constraint part
for k=1:length(Tcon(:,1))
    for l=1:length(Tcon(1,:))
        %get matrix size
        [rows,cols] = size(Tcon{k,l});
        sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
        str=['Tg{',num2str(k),',',num2str(l),'} = interval(',sparseStr,',',sparseStr,');'];
        %write in file
        fprintf(fid, '\n\n %s\n\n', str);
        % write rest of matrix
        writeSparseMatrix(Tcon{k,l},['Tg{',num2str(k),',',num2str(l),'}'],fid);

        disp(['dynamic index ',num2str(k),',',num2str(l)]);
    end
end


%close file
fclose(fid);



function writeSparseMatrix(M,var,fid)


%write each row
[row,col] = find(M~=0);

for i=1:length(row)
    iRow = row(i);
    iCol = col(i);
    str=bracketSubs(char(M(iRow,iCol)));
    str=[var,'(',num2str(iRow),',',num2str(iCol),') = ',str,';'];
    %write in file
    fprintf(fid, '%s\n', str);
end


function [str]=bracketSubs(str)

%generate left and right brackets
str=strrep(str,'L','(');
str=strrep(str,'R',')');

%------------- END OF CODE --------------