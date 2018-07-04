function createRemainderFile(J2dyn,J2con,path)
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
% Written:      28-October-2011
% Last update: 	---
% Last revision:---

%------------- BEGIN CODE --------------

    
% %load second order jacobian
% J2dyn = obj.derivative.secondOrder.dyn;
% J2con = obj.derivative.secondOrder.con;

%obtain symbolic variables
[x,y,u,dx,dy,du] = symVariables(obj,'LRbrackets');

%compute dynamic remainder term
for k=1:length(J2dyn(:,1,1))
    Lf(k,1)=0.5*[dx;dy;du].'*squeeze(J2dyn(k,:,:))*[dx;dy;du];
end
for k=1:length(J2con(:,1,1))
    Lg(k,1)=0.5*[dx;dy;du].'*squeeze(J2con(k,:,:))*[dx;dy;du];
end

%simplify expression
%f=simple(f);  %<--change back!

%create file
fid = fopen([path '/lagrangeRemainder.m'],'w');
fprintf(fid, '%s\n\n', 'function [lf,lg]=lagrangeRemainder(x,y,u,dx,dy,du)');

%dynamic remainder
for k=1:length(Lf(:,1))
    str=['lf(',num2str(k),',1)=',char(Lf(k,1)),';'];
    %generate left and right brackets
    str=strrep(str,'L','(');
    str=strrep(str,'R',')');
%     %replace zeros by interval-zeros
%     str=strrep(str,'=0;','=infsup(0,0);');        
    %write in file
    fprintf(fid, '%s\n', str);
end

%constraint remainder
for k=1:length(Lg(:,1))
    str=['lg(',num2str(k),',1)=',char(Lg(k,1)),';'];
    %generate left and right brackets
    str=strrep(str,'L','(');
    str=strrep(str,'R',')');
%     %replace zeros by interval-zeros
%     str=strrep(str,'=0;','=infsup(0,0);');        
    %write in file
    fprintf(fid, '%s\n', str);
end

%close file
fclose(fid);

%------------- END OF CODE --------------