function output = getParamType(obj, component)
%GETPARAMTYPE get the parameters depending of their type :
%variables defined by the the attributes "any" and constant
%defined by the attributes "const"

sConstants = {}; %Cell Array of constants
sStates = {}; %Cell Array of state variables
sInputs = {}; %Cell Array of input variables
sVariables = {}; %Cell Array of variables

iState = 1; % index for cell array containing variables
iInputs = 1;
iConstant = 1; % index of  cell array containing constant
iVariables = 1;

if(isfield(component, 'param'))
    
    nParams =length(component.param);
    
    for iParam=1:1:nParams
        % Let the attribute structure of the param number iParam be stored
        %TO DO : remake the xml2struct to always have an array of struct
        %even if there is only one element... ???
        tmpAttrParam=component.param{iParam}.Attributes;
        
        % Sort the param depending on their dynamics, and filter the
        % duplicates (TO DO : few modifications might be needed here !!!
        
        if isfield(tmpAttrParam,'dynamics')
            
            if isfield(tmpAttrParam,'controlled')

                if strcmp(tmpAttrParam.dynamics,'any') && strcmp(tmpAttrParam.controlled,'true')
                   
                    % 'any' with 'true' control refers to state variables in spaceEx
                    sStates{iState}=tmpAttrParam.name;
                    iState=iState+1;
                    sVariables{iVariables} = tmpAttrParam.name;
                    iVariables = iVariables + 1;
                    
                elseif strcmp(tmpAttrParam.dynamics,'any') && strcmp(tmpAttrParam.controlled,'false')
                    
                    % 'any' with 'false' control refers to state variables in spaceEx
                    sInputs{iInputs}=tmpAttrParam.name;
                    iInputs=iInputs+1;
                    sVariables{iVariables} = tmpAttrParam.name;
                    iVariables = iVariables + 1;
                    
               elseif strcmp(tmpAttrParam.dynamics,'const')
                    % 'const' refers to constant in spaceEx
                    sConstants{iConstant}=tmpAttrParam.name;
                    iConstant=iConstant+1;
                    
                end
                
            else
                
                if strcmp(tmpAttrParam.dynamics,'any') && (~ismember(tmpAttrParam.name,sStates))
                    
                    % 'any' with undefined control refers to state variables in spaceEx
                    sStates{iState}=tmpAttrParam.name;
                    iState=iState+1;
                    sVariables{iVariables} = tmpAttrParam.name;
                    iVariables = iVariables + 1;
                    
                elseif strcmp(tmpAttrParam.dynamics,'const')
                    % 'const' refers to constant in spaceEx
                    sConstants{iConstant}=tmpAttrParam.name;
                    iConstant=iConstant+1;
                end
            end
        end
    end
end

% Sort constants
if(~isempty(sConstants))
    sConstants = sort(sConstants);
else
    sConstants = {};
end

% Sort state variables
if(~isempty(sStates))
    sStates = sort(sStates);
else
    sStates = {};
end

%Sort input variables
if(~isempty(sInputs))
    sInputs = sort(sInputs);
else
    sInputs = {};
end

% Sort variables
if(~isempty(sVariables))
    sVariables = sort(sVariables);
else
    sVariables = {};
end

output{1} = sVariables;
output{2} = sConstants;
output{3} = sStates;
output{4} = sInputs;


end