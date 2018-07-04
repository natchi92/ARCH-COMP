function res = test_zonotope_reduce
% test_zonotope_reduce - unit test function of reduce
%
% Syntax:  
%    res = test_zonotope_reduce
%
% Inputs:
%    -
%
% Outputs:
%    res - boolean 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: -

% Author:       Matthias Althoff
% Written:      26-July-2016
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% create zonotope
Z1 = zonotope([-4, -3, -2, 0.1, -0.1; 1, 2, 3, 0.2, 0.1]);

% obtain result
Z2 = reduce(Z1,'girard',1.5);

% obtain zonotope matrix
Zmat = get(Z2,'Z');

% true result
true_mat = [-4, -2, 3.2, 0; ...
            1, 3, 0, 2.3];

% check result
res = all(all(Zmat == true_mat));

if res
    disp('test_zonotope_reduce successful');
else
    disp('test_zonotope_reduce failed');
end

%------------- END OF CODE --------------
