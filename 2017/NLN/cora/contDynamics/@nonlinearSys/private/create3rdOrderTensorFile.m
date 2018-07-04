function create3rdOrderTensorFile(J3dyn,path,name)
% create3rdOrderTensorFile - generates an mFile that allows to compute the
% 3rd order terms 
%
% Syntax:  
%    createHessianTensorFile(obj,path)
%
% Inputs:
%    obj - nonlinear system object
%    path - path for saving the file
%    name - name of the nonlinear function to which the 3rd order tensor belongs
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
% Last update:  08-March-2017
% Last revision:---

%------------- BEGIN CODE --------------


for k=1:length(J3dyn(:,1,1,1))
    for l=1:length(J3dyn(1,:,1,1))
        Tdyn{k,l} = squeeze(J3dyn(k,l,:,:));
    end
end

fid = fopen([path '/thirdOrderTensor_',name,'.m'],'w');
fprintf(fid, '%s\n\n', ['function [T]=thirdOrderTensor_',name,'(x,u)']);

%dynamic part
for k=1:length(Tdyn(:,1))
    for l=1:length(Tdyn(1,:))
        %get matrix size
        [rows,cols] = size(Tdyn{k,l});
        sparseStr = ['sparse(',num2str(rows),',',num2str(cols),')'];
        str=['T{',num2str(k),',',num2str(l),'} = interval(',sparseStr,',',sparseStr,');'];
        %str=['T{',num2str(k),',',num2str(l),'} = infsup(',sparseStr,',',sparseStr,');']; %for INTLAB
        %write in file
        fprintf(fid, '\n\n %s\n\n', str);
        % write rest of matrix
        writeSparseMatrix(Tdyn{k,l},['T{',num2str(k),',',num2str(l),'}'],fid);

        disp(['dynamic index ',num2str(k),',',num2str(l)]);
    end
end

%close file
fclose(fid);


%------------- END OF CODE --------------