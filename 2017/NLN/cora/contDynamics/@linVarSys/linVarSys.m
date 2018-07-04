classdef linVarSys < contDynamics
% linVarSys class 
%
% Syntax:  
%    object constructor: Obj = linVarSys(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    input1 - zonotope matrix
%
% Outputs:
%    Obj - Generated Object
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Matthias Althoff
% Written:      05-August-2010
% Last update:  02-April-2017
% Last revision:---

%------------- BEGIN CODE --------------

properties (SetAccess = private, GetAccess = public)
    A = 1;
    B = 0;
    %stepSize = 0.01/max(abs(eig(A.center)));
    stepSize = 1;
    taylorTerms = 6;
    mappingMatrixSet = [];
    power = [];
    E = [];
    F = [];
    inputF = [];
    inputCorr = [];
    Rinput = [];
    Rtrans = [];
    sampleMatrix = [];
end
    
methods
    %class constructor
    function obj = linVarSys(A,B,stepSize,taylorTerms)
        obj@contDynamics('linVarSysDefault',ones(A.dim,1),1,1); %instantiate parent class
        %one input
        if nargin==1
            obj.A = A;
        %two inputs
        elseif nargin==2
            obj.A = A;
            obj.B = B;
        %three inputs
        elseif nargin==3
            obj.A = A;
            obj.B = B;
            obj.stepSize = stepSize;
        %four inputs
        elseif nargin==4
            obj.A = A;
            obj.B = B;
            obj.stepSize = stepSize;
            obj.taylorTerms = taylorTerms;
        end 
    end
         
    %methods in seperate files 
    [obj,Rfirst,options] = initReach(obj, Rinit, options)
    [Rnext,options] = post(obj,R,options)
    [obj,t,x,index] = simulate(obj,opt,tstart,tfinal,x0,options)
    handle = getfcn(obj,options)
    
    %display functions
    plot(varargin)
    display(obj)
end
end

%------------- END OF CODE --------------