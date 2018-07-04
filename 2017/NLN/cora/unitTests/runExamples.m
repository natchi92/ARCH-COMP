function runExamples(varargin)
% runExamples - runs all examples starting with a certain prefix in the
% folder 'examples'.
%
% Syntax:  
%    runExamples(varargin)
%
% Inputs:
%    prefix - prefix of function names to be tested
%    verbose - show workspace output or not (not required)
%    directory - change directory (not required)
%
% Outputs:
%    -
%
% Example: 
%    -
%
% 
% Author:       Dmitry Grebenyuk, Matthias Althoff
% Written:      20-September-2016
% Last update:  ---
% Last revision:---


%------------- BEGIN CODE --------------

directory = [coraroot '/examples'];
prefix = 'example';
verbose = 0;

if nargin >= 1
    prefix = varargin{1};
end
if nargin >= 2
    verbose = varargin{2};
end
if nargin >= 3
    directory = varargin{3};
end

% Find all relevant files in directory und run the tests
files = dir([directory, ['/',prefix,'_*.m']]);
for i=1:size(files,1)
    % Extract the function name
    [~, fname] = fileparts(files(i).name);
    % Supress output of tests by usage of evalc
    fprintf(['run ',fname,': ']);
    evalc(fname);
    fprintf('%s\n','completed');
end

% run files in subdirectories
files = dir(directory);
for i=1:size(files,1)
    % Exclude files and directories . and ..
    if files(i).name(1) == '.' || files(i).isdir == 0
        continue;
    end
        
    runExamples(prefix, verbose, [directory '/' files(i).name]);
end

end

%------------- END OF CODE --------------