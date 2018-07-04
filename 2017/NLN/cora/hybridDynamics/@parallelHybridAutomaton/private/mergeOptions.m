function [ mergedOptions ] = mergeOptions( optionsCollection, type)
%MERGEOPTIONS Summary of this function goes here
%   Detailed explanation goes here

%type = global or local


nOptions = length(optionsCollection);

mergedOptions.x0 = [];

for iOptions = 1:1:nOptions
    
    mergedOptions.x0 = [mergedOptions.x0 ; optionsCollection{iOptions}.x0];
    
    
    
end






 options.x0 = [0; 1]; %initial state for simulation
 options.R0 = zonotope([options.x0, diag([0.05, 0.05])]); %initial set
 options.startLoc = 1; %initial location
 options.finalLoc = 0; %0: no final location
 options.tStart = 0; %start time
 options.tFinal = 5; %final time
 options.timeStepLoc{1} = 0.05; %time step size in location 1
 options.taylorTerms = 10;
 options.zonotopeOrder = 20;
 options.polytopeOrder = 10;
 options.errorOrder=2;
 options.reductionTechnique = 'girard';
 options.isHybrid = 1;
 options.isHyperplaneMap = 0;
 options.enclosureEnables = [5]; %choose enclosure method(s)
 options.originContained = 0;
 options.polytopeType = 'mpt';
 
  %set input:
 options.uLoc{1} = [-1; 0]; %input for simulation
 options.uLocTrans{1} = options.uLoc{1}; %center of input set
 options.Uloc{1} = zonotope(zeros(2,1)); %input deviation from center
 
 options.projectedDimensions = [1 2];
 options.plotType = 'b';



end

