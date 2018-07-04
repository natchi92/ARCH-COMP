function createHessianTensorFile(J2dyn,J2con,path,name)
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
% Written:      28-October-2011
% Last update:  17-May-2013
%               23-May-2013
%               25-June-2013
% Last revision:---

%------------- BEGIN CODE --------------

    
% %load second order jacobian
% J2dyn = obj.derivative.secondOrder.dyn;
% J2con = obj.derivative.secondOrder.con;


fid = fopen([path,'/hessianTensor_',name,'.m'],'w');
fprintf(fid, '%s\n\n', ['function [Hf,Hg]=hessianTensor_',name,'(x,y,u)']);

%dynamic part
if ~isempty(J2dyn)
    for k=1:length(J2dyn(:,1,1))
        Hdyn{k} = squeeze(J2dyn(k,:,:));
    end

    for k=1:length(Hdyn)
        if ~isempty(Hdyn{k})
            %get matrix size
            [rows,cols] = size(Hdyn{k});
            sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
            str=['Hf{',num2str(k),'} = interval(',sparseStr,',',sparseStr,');'];
            %str=['Hf{',num2str(k),'} = infsup(',sparseStr,',',sparseStr,');']; %(for INTLAB toolbox) 
            %write in file
            fprintf(fid, '\n\n %s\n\n', str);
            % write rest of matrix
            writeSparseMatrix(Hdyn{k},['Hf{',num2str(k),'}'],fid);
        else
            str = ['Hf{',num2str(k),'} = [];'];
            fprintf(fid, '%s', str);
        end
        disp(['dynamic dim ',num2str(k)]);
    end
else
    fprintf(fid, '%s', 'Hf=[];');
end


%constraint part
if ~isempty(J2con)
    for k=1:length(J2con(:,1,1))
        Hcon{k} = squeeze(J2con(k,:,:));
    end

    for k=1:length(Hcon)
        if ~isempty(Hcon{k})
            %get matrix size
            [rows,cols] = size(Hcon{k}); 
            sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
            str=['Hg{',num2str(k),'} = interval(',sparseStr,',',sparseStr,');'];
            %str=['Hg{',num2str(k),'} = infsup(',sparseStr,',',sparseStr,');']; %(for INTLAB toolbox) 
            %write in file
            fprintf(fid, '\n\n %s\n\n', str);
            % write rest of matrix
            writeSparseMatrix(Hcon{k},['Hg{',num2str(k),'}'],fid);
        else
            str = ['Hg{',num2str(k),'} = [];'];
            fprintf(fid, '%s', str);
        end

        disp(['constraint dim ',num2str(k)]);
    end
else
    fprintf(fid, '%s', 'Hg=[];');
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




% function writeMatrix(M,fid)
% 
% %write each row
% for iRow=1:(length(M(:,1)))
%     if (length(M(1,:))-1)>0
%         for iCol=1:(length(M(1,:))-1)
%             str=bracketSubs(char(M(iRow,iCol)));
%             str=[str,','];
%             %write in file
%             fprintf(fid, '%s', str);
%         end
%     else
%         iCol = 0; %for vectors
%     end
%     if iRow<length(M(:,1))
%         %write last element
%         str=bracketSubs(char(M(iRow,iCol+1)));
%         str=[str,';...'];
%         %write in file
%         fprintf(fid, '%s\n', str);
%     else
%         %write last element
%         str=bracketSubs(char(M(iRow,iCol+1)));
%         str=[str,'];'];
%         %write in file
%         fprintf(fid, '%s\n\n', str);   
%     end
% end


function [str]=bracketSubs(str)

%generate left and right brackets
str=strrep(str,'L','(');
str=strrep(str,'R',')');

%------------- END OF CODE --------------