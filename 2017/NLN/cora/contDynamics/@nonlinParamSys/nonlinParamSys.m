classdef nonlinParamSys < contDynamics
% nonlinParamSys class (nonlinear parametric system; parameters can be 
% constant or vary over time)
%
% Syntax:  
%    object constructor: Obj = nonlinParamSys(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    A - system matrix
%    B - input matrix
%    stepSize - time increment
%    taylorTerms - number of considered Taylor terms
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
% Written:      23-September-2010
% Last update:  27-October-2011
%               16-August-2016
% Last revision:---

%------------- BEGIN CODE --------------
  

properties (SetAccess = private, GetAccess = public)
    nrOfParam = 1;
    mFile = [];
    allowedError = 0;
    constParam = 1; %flag if parameters are constant or time-varying 
    derivative = [];
    linError = [];
end
    
methods
    %class constructor
    function obj = nonlinParamSys(dim,nrOfInputs,nrOfParam,mFile,allowedError,options)
        obj@contDynamics('nonlinParamSysDefault',ones(dim,1),ones(nrOfInputs,1),1); %instantiate parent class
        %four inputs
        if nargin==4
            obj.nrOfParam=nrOfParam;
            obj.mFile=mFile;
        
        %five inputs
        elseif nargin==6
            obj.nrOfParam=nrOfParam;
            obj.mFile=mFile;
            obj.allowedError=allowedError;
            %compute derivatives
            obj = symbolicDerivation(obj,options);
        end
        
    end
         
    %methods in seperate files 
    [obj,Rfirst,options] = initReach(obj, Rinit, options)
    [obj,t,x,index] = simulate(obj,opt,tstart,tfinal,x0,options)
    handle = getfcn(obj,options)
    
    %display functions
    display(obj)
end
end

%------------- END OF CODE --------------