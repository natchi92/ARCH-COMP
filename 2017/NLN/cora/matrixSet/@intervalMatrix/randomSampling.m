function A = randomSampling(intA,samples)
% randomSampling - uniformly creates samples within an interval matrix
%
% Syntax:  
%    A = randomSampling(intA,samples)
%
% Inputs:
%    intA - interval matrix 
%    samples - number of segments
%
% Outputs:
%    A - cell array of matrices
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      22-June-2010
% Last update:  02-April-2017
% Last revision:---

%------------- BEGIN CODE --------------

%obtain dim, minimum and difference matrix
dim = intA.dim;
minA = infimum(intA.int);
diffA = supremum(intA.int)-infimum(intA.int);

%generate sample matrices
A=cell(samples,1);
for i=1:samples
    %init A{i}
    A{i}=minA + rand(dim).*diffA;
end

    
%------------- END OF CODE --------------
