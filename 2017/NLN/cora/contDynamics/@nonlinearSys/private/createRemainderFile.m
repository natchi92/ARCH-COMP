function createRemainderFile(obj,J2,path,name)
% createRemainderFile - generates an mFile that allows to compute the
% lagrange remainder
%
% Syntax:  
%    createRemainderFile(obj)
%
% Inputs:
%    obj - nonlinear sytsem object
%    J2 - second order jacobian
%    path - path for file location
%    name - name of the corresponding nonlinear system
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
% Last update:  03-February-2011
%               05-September-2012
%               12-October-2015
%               25-January-2016
%               05-August-2016
% Last revision:---

%------------- BEGIN CODE --------------

%create symbolic variables
[x,u,dx,du] = symVariables(obj,'LRbrackets');

for k=1:length(J2(:,1,1))
    f(k,1)=0.5*[dx;du].'*squeeze(J2(k,:,:))*[dx;du];
end

%simplify expression
%f=simple(f);

%use variable precision arithmetic!
%f=vpa(f);

fid = fopen([path '/lagrangeRemainder_',name,'.m'],'w');
fprintf(fid, '%s\n\n', ['function f=lagrangeRemainder_',name,'(x,u,dx,du)']);
fprintf(fid, '%s\n\n', 'f=interval();');
for k=1:length(J2(:,1,1))
    str=['f(',num2str(k),',1)=',char(f(k,1)),';'];
    %generate left and right brackets
    str=strrep(str,'L','(');
    str=strrep(str,'R',')');
        
    %write in file
    fprintf(fid, '%s\n', str);
end

%close file
status = fclose(fid);

%------------- END OF CODE --------------