function [obj] = sample(obj)
% sample - computes a sample of the system matrix
%
% Syntax:  
%    [obj] = sample(obj)
%
% Inputs:
%    obj - linIntSys object
%
% Outputs:
%    obj - linIntSys object
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author: Matthias Althoff
% Written: 03-Jan-2009 
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

%number of uncertain parameters
nrOfParam=length(obj.A)-1;

%create random vector for the number of uncertain parameters
randVec=rand(nrOfParam,1);

%multiply system matrices with random vector
Asample=obj.A{1};
for i=1:nrOfParam
    Asample=Asample+randVec(i)*obj.A{i+1};
end

%write result to object structure
obj.sample.A=Asample;
    
%------------- END OF CODE --------------