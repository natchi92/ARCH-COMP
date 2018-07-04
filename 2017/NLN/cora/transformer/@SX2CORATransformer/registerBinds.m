function [ inputComponentBindRegister, stateComponentBindRegister, idSet, componentIdSet ] = registerBinds( obj, xmlStruct, componentRegister, parentRegisterBind, component, idSet, componentIdSet)
%REGISTERBINDS Summary of this function goes here
%   Detailed explanation goes here

inputComponentBindRegister = [];

paramTypeStruct = obj.getParamType(component);

sVariables = paramTypeStruct{1};
sStates = paramTypeStruct{3};
sInputs = paramTypeStruct{4};

nVariables = length(sVariables);

variablesRegister = cell(nVariables,2);

%Create the mapping

for iVariables = 1:1:nVariables
    
    index = [];
    if(~isempty(parentRegisterBind))
        index = find(ismember(parentRegisterBind(:,1),sVariables{iVariables}));
    end
    
    if(isempty(index))
        %add new id
        variablesRegister{iVariables,1} = sVariables{iVariables};
        variablesRegister{iVariables,2} = idSet+1;
        idSet = idSet + 1;
    else
        %get the bond id
        variablesRegister{iVariables,1} = parentRegisterBind{index,1};
        variablesRegister{iVariables,2} = parentRegisterBind{index,2};
    end
end

variablesMap = containers.Map(variablesRegister(:,1),variablesRegister(:,2));

if(isfield(component,'bind'))
    % Apply the mapping to the binds
    nBinds = length(component.bind);
    
    inputComponentBindRegister = [];
    stateComponentBindRegister = [];
    
    for iBind =1:1:nBinds
        if(isfield(component.bind{iBind},'map'))
            nMaps = length(component.bind{iBind}.map);
            newParentRegisterBind = {};
            for iMap = 1:1:nMaps
                key = component.bind{iBind}.map{iMap}.Attributes.key;
                value = component.bind{iBind}.map{iMap}.Text;
                
                if(isnan(str2double(value)))
                    try
                        newParentRegisterBind{iMap,1} = key;
                        newParentRegisterBind{iMap,2} = variablesMap(value);
                    catch
                        %TO DO : detect label from variables
                        warning('label detected in xml model')
                    end
                    
                end
            end
            
            componentName = component.bind{iBind}.Attributes.component;
            
            childrenComponent = findInComponentRegister(obj, xmlStruct, componentRegister, componentName);
            
            [ childrenInputComponentBindRegister, childrenStateComponentBindRegister, idSet, componentIdSet ] = registerBinds( obj, xmlStruct, componentRegister, newParentRegisterBind, childrenComponent, idSet, componentIdSet);
            
            [nInputChildrenBinds,~] = size(childrenInputComponentBindRegister);
            [nStateChildrenBinds,~] = size(childrenStateComponentBindRegister);
            
            inputComponentBindRegister(end+1:end+nInputChildrenBinds,:) = childrenInputComponentBindRegister;
            stateComponentBindRegister(end+1:end+nStateChildrenBinds,:) = childrenStateComponentBindRegister;
        end
    end
else
    % if no binds, return the mapping of the component.
    
    nInputs = length(sInputs);
    nStates = length(sStates);
    
    inputComponentBindRegister = zeros(nInputs,3);
    for iInput = 1:1:nInputs
        tmpParamName = sInputs{iInput};
        
        globalId = variablesMap(tmpParamName);
        
        inputComponentBindRegister(iInput,:) = [componentIdSet+1, iInput, globalId];
    end
    
    stateComponentBindRegister = zeros(nStates,3);
    for iState = 1:1:nStates
        tmpParamName = sStates{iState};
        
        globalId = variablesMap(tmpParamName);
        
        stateComponentBindRegister(iState,:) = [componentIdSet+1, iInput, globalId];
        
    end
    
    componentIdSet = componentIdSet+1;
end
end

