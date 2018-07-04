function [Zred,t]=reduce(Z,option,varargin)
% reduce - Reduces the order of a zonotope
% option 'girard': Use order reduction technique by Antoine Girard
% option 'althoff': Use order reduction technique by Matthias Althoff where
% order is set to 1
%
% Syntax:  
%    [Zred]=reduce(Z,option,order)
%
% Inputs:
%    Z - zonotope object
%    option - 'girard' or 'althoff'
%    order - order of reduced zonotope
%
% Outputs:
%    Zred - reduced zonotope
%
% Example: 
%    Z=zonotope(rand(2,10));
%    plot(Z);
%    hold on
%    Zred=reduce(Z,'girard',2);
%    plot(Zred);
%    Zred=reduce(Z,'althoff');
%    plot(Zred);
%
% Other m-files required: none
% Subfunctions: reduceGirard, reduceAlthoff
% MAT-files required: none
%
% See also: none

% Author: Matthias Althoff
% Written: 24-January-2007 
% Last update: 15-September-2007
% Last revision: ---

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
    Zred=reduceGirard(Z,order);
    t=[];
%option='girardMultiple'
elseif strcmp(option,'girardMultiple')
    Zred=reduceGirardMultiple(Z,order);
    t=[];    
%option='combastel'
elseif strcmp(option,'combastel')
    Zred=reduceCombastel(Z,order);
    t=[];    
%option='althoff'
elseif strcmp(option,'althoff')
    Zred=reduceAlthoff(Z,order,filterLength);
    t=[];
%option='PCA'
elseif strcmp(option,'pca')
    Zred=reducePCA(Z);
    t=[];

%option='methA'
elseif strcmp(option,'methA')
    [Zred,t]=reduceMethA(Z);   
    
%option='methAa'
elseif strcmp(option,'methAa')
    [Zred,t]=reduceMethAa(Z);      
    
%option='methB'
elseif strcmp(option,'methB')
    [Zred,t]=reduceMethB(Z,filterLength); 
%option='methC'
elseif strcmp(option,'methC')
    [Zred]=reduceMethC(Z,filterLength); 
    t = [];
%option='methD'
elseif strcmp(option,'methD')
    [Zred,t]=reduceMethD(Z,order,filterLength);  
%option='methE'
elseif strcmp(option,'methE')
    [Zred,t]=reduceMethE(Z,order);  
%option='methF'
elseif strcmp(option,'methF')
    [Zred,t]=reduceMethF(Z);   
%option='PP'
elseif strcmp(option,'PP')
    [Zred]=reduceParallelpiped(Z); 
    t=[];    
%option='redistribute'
elseif strcmp(option,'redistribute')
    Zred=reduceRedistribute(Z,order);   
    t=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% additional Methods to reduce a Zonotope
% option='cluster', order must be 1
elseif strcmp(option,'cluster')
    [Zred,t]=reduceCluster(Z,order, method);
% option='clusterAllDim', order must be 1
elseif strcmp(option,'clusterAllDim')
    [Zred,t]=reduceClusterAllDim(Z,order);
% option='KclusterAllDim', order must be 1
elseif strcmp(option,'KclusterAllDim')
    [Zred,t]=reduceKclusterAllDim(Z,order);
% option='iter'
elseif strcmp(option,'clusterIter')
    [Zred,t]=reduceClusterIter(Z,order); 
% option='constOpt'
elseif strcmp(option,'constOpt')
    method = 'svd';
    
    [Zred,t]=reduceConstOpt(Z,order, method, alg);  
% option='tomOpt'
elseif strcmp(option,'tomOpt')
    [Zred,t]=reduceTomOpt(Z,order, method, alg);  
% option='aPCA'
elseif strcmp(option,'aPCA')
    [Zred]=reduceaPCA(Z,order);  
    t = [];
    
    
elseif strcmp(option,'allLines')
    [Zred,t]=reduceAllLines(Z,order);  
elseif strcmp(option,'fracSort')
    [Zred,t]=reduceFracSort(Z,order);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% methods for Basti's Code
elseif strcmp(option,'sysU')
    [Zred,t]=reduceSysU(Z,order, U); 
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%wrong argument

else
    disp('Error: Second argument is wrong');
    Zred=[];
end

%------------- END OF CODE --------------
