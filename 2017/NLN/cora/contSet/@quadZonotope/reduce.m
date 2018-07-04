function [qZred,t]=reduce(qZ,option,varargin)
% reduce - Reduces the order of a quadZonotope
%
% Syntax:  
%    [qZred,t]=reduce(qZ,option,varargin)
%
% Inputs:
%    qZ - quadZonotope object
%    option - see below
%    order - order of reduced zonotope
%
% Outputs:
%    qZred - reduced quadZonotope
%
% Example: 
%    ---
%
% Other m-files required: none
% Subfunctions: ---
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      05-September-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%2 inputs
if nargin==2
    order=1;
    filterLength=[];
%3 inputs
elseif nargin==3
    order=varargin{1};
    filterLength=[];
%4 inputs
elseif nargin==4
    order=varargin{1};
    filterLength=varargin{2};
end

%option='girard'
if strcmp(option,'girard')
    qZred=reduceGirard(qZ,order);
    t=[];
%option='girardMultiple'
elseif strcmp(option,'girardMultiple')
    qZred=reduceGirardMultiple(qZ,order);
    t=[];    
%option='combastel'
elseif strcmp(option,'combastel')
    qZred=reduceCombastel(qZ,order);
    t=[];    
%option='althoff'
elseif strcmp(option,'althoff')
    qZred=reduceAlthoff(qZ,order,filterLength);
    t=[];

%option='redistribute'
elseif strcmp(option,'redistribute')
    qZred=reduceRedistribute(qZ,order);   
    t=[];

%wrong argument
else
    disp('Error: Second argument is wrong');
    qZred=[];
end

%------------- END OF CODE --------------