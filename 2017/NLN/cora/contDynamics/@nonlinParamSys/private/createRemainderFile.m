function createRemainderFile(obj)
% createRemainderFile - generates an mFile that allows to compute the
% lagrange remainder
%
% Syntax:  
%    createRemainderFile(obj)
%
% Inputs:
%    obj - nonlinear system object
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
% Written:      29-October-2007 
% Last update: 	03-February-2011
%               27-May-2011
% Last revision:---

%------------- BEGIN CODE --------------

    
%load second order jacobian
J2=obj.derivative.secondOrderParam;

[x,u,dx,du,p] = symVariables(obj,'LRbrackets');

for k=1:length(J2{1}(:,1,1))
    f(k,1)=0.5*[dx;du].'*squeeze(J2{1}(k,:,:))*[dx;du];
    for iParam=1:length(p)
        f(k,1)=f(k,1) + p(iParam)*(0.5*[dx;du].'*squeeze(J2{iParam+1}(k,:,:))*[dx;du]);
    end
end

%simplify expression
%f=simple(f);  %<--change back!

%create file
fid = fopen([coraroot '/contDynamics/stateSpaceModels/lagrangeRemainder.m'],'w');
fprintf(fid, '%s\n\n', 'function f=lagrangeRemainder(x,u,dx,du,p)');
for k=1:length(f(:,1))
    str=['f(',num2str(k),',1)=',char(f(k,1)),';'];
    %generate left and right brackets
    str=strrep(str,'L','(');
    str=strrep(str,'R',')');
    %replace zeros by interval-zeros
    str=strrep(str,'=0;','=interval(0,0);');
    
%     %for tank example only!!!
%     for i=1:length(J2(:,1,1))
%         %replace ^3/2 by sqrt(^3)
%         str=strrep(str,['x(',num2str(i),')^(3/2)'],['sqrt(x(',num2str(i),')^3)']);
%     end      
    
    %write in file
    fprintf(fid, '%s\n', str);
end

%close file
fclose(fid);

%------------- END OF CODE --------------