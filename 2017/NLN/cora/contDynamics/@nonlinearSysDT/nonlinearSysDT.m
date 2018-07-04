classdef nonlinearSysDT < contDynamics
% nonlinearSysDT class (nonlinear system with discrete time)
%
% Syntax:  
%    object constructor: Obj = nonlinDASys(varargin)
%    copy constructor: Obj = otherObj
%
% Inputs:
%    dim - system dimension
%    nrOfInputs - number of inputs
%    dynFile - handle of the dynamics file
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
% Written:      21-August-2012
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------
  

properties (SetAccess = private, GetAccess = public)
    dim = 1;
    nrOfInputs = 0;
    dynFile = [];
    linError = [];
end
    
methods
    %class constructor
    function obj = nonlinearSysDT(dim,nrOfInputs,dynFile,options)
        %six inputs
        if nargin==4
            obj.dim=dim;
            obj.nrOfInputs=nrOfInputs;
            obj.dynFile=dynFile;
            %compute derivatives
            symbolicDerivation(obj,options);
        end
        
    end
         
    %methods in seperate files 
    [obj, Rfirst, Rfirst_y, options] = initReach(obj, Rinit, Rinit_y, options)
    [Rnext, Rnext_y, options] = reach(obj, R, R_y, options)
    [obj, t, x, index] = simulate(obj, opt, tstart, tfinal, x0, y0, options)
    handle = getfcn(obj, options)
    
    %display functions
    display(obj)
end
end

%------------- END OF CODE --------------