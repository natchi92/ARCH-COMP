function generateComponent(obj,component)
%GENERATECOMPONENT generates the code implementing a component

%Open file for writing
functionName = ['generated_cora_' component.Attributes.id ];
filename = [functionName '.m'];
folder = [coraroot '/contDynamics/stateSpaceModels/'];
fileID = fopen([folder filename], 'w');

% parameters of the function (component)
strParams = '';
sVariables = [];
sConstants = [];
sStates= [];
sInputs = [];

if(isfield(component, 'param'))
    
    paramTypeStruct = obj.getParamType(component);
    
    sVariables = paramTypeStruct{1};
    sConstants = paramTypeStruct{2};
    sStates = paramTypeStruct{3};
    sInputs = paramTypeStruct{4};
    
    % Create a string containing the name of the parameters
    % separated to insert in the prototype of the function
    % describing the component.
    nConstants = length(sConstants);
    for iConstant = 1:1:nConstants
        strParams = strcat(strParams,cell2mat(sConstants(iConstant)),',');
    end
    strParams = strParams(1:end-1);
end

% string prototype of the function
headerFunction = ['function loc = ' functionName '(' strParams ')\n \n'];
fprintf(fileID, headerFunction);

% If there is no location, initialize the collection of
% locations as an empty array cell.
if(~isfield(component,'location'))
    strInitialization = 'loc = {}; \n \n';
    fprintf(fileID, strInitialization);
end

% Generate in the function the code implementing a transition
if(isfield(component, 'transition'))
    
    % Initialize the transition collections
    nLocations = length(component.location);
    fprintf(fileID, 'trans = cell(1,%d);\n\n',nLocations); %nLocations is correct ???
    
    nTransitions = length(component.transition);
    for iTransition = 1:1:nTransitions
        obj.generateTransition(fileID, component.transition{iTransition}, paramTypeStruct);
    end
else
    if(isfield(component, 'location'))
        nLocations = length(component.location);
        fprintf(fileID, 'trans = cell(1,%d);\n\n',nLocations);
    end
end

% Generate in the function the code implementing a location
if(isfield(component, 'location'))
    nLocations = length(component.location);
    fprintf(fileID, 'loc = cell(1,%d);\n\n',nLocations);
    for iLocation = 1:1:nLocations
        obj.generateLocation(fileID, component.location{iLocation},paramTypeStruct);
    end
    fprintf(fileID, 'loc = {loc};\n\n');
end

% Generate in the function the code implementing a bind
% Locations are added by concatenation
if(isfield(component, 'bind'))
    nBinds = length(component.bind);
    for iBind = 1:1:nBinds
        obj.generateBind(fileID, component.bind{iBind}, sConstants);
    end
end

%End of the function
fprintf(fileID, 'end');

%Close the file
fclose(fileID);
end

