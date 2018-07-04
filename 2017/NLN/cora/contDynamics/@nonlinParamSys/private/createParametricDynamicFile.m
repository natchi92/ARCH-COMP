function createParametricDynamicFile(obj)
% createParametricDynamicFile - generates an mFile of the dynamic equations
% sorted by parameter influences
%
% Syntax:  
%    createParametricDynamicFile(obj)
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
% Written:      01-June-2011
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%create symbolic variables
[x,u,dx,du,p]=symVariables(obj,'LRbrackets');

%insert symbolic variables into the system equations
t=0;
f=obj.mFile(t,x,u,p);

%init
fcell=cell(1,obj.nrOfParam+1);
%part without parameters
fcell{1} = subs(f,p,zeros(obj.nrOfParam,1));
%part with parameters
I = eye(obj.nrOfParam); %identity matrix
for i=1:obj.nrOfParam
    fcell{i+1} = subs(f,p,I(i,:)) - fcell{1};
end


fid = fopen([coraroot '/contDynamics/stateSpaceModels/parametricDynamicFile.m'],'w');
fprintf(fid, '%s\n\n', 'function f=parametricDynamicFile(x,u)');
for k=1:length(fcell)
    for i=1:obj.dim
        str=['f{',num2str(k),'}(',num2str(i),',1)=',char(fcell{k}(i,1)),';'];
        str=bracketSubs(str);
        %write in file
        fprintf(fid, '%s\n', str);
    end
end

%close file
fclose(fid);

function [str]=bracketSubs(str)

%generate left and right brackets
str=strrep(str,'L','(');
str=strrep(str,'R',')');

% % add "interval()" to string
% str=['infsup(',str,',',str,')'];

%------------- END OF CODE --------------