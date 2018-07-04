function  mergedFlow = mergeFlows(flowsCollection, bindsCollection, options)
%MERGEFLOW Summary of this function goes here
%   Detailed explanation goes here

nFlows = length(flowsCollection);

if(nFlows == 1 && iscell(flowsCollection))
    mergedFlow = flowsCollection{1};
elseif (nFlows == 1 && ~iscell(flowsCollection))
    mergedFlow = flowsCollection;
else
    
    A = cell(nFlows,1);
    B = cell(nFlows,1);
    nVariables = zeros(1,nFlows);
    nBinds = zeros(1,nFlows);
    nExtInputs = zeros(1,nFlows);
    
    dimVariables = 0;
    dimInputs = 0;
    
    % Get the data
    for iFlow = 1:1:nFlows
        
        A{iFlow} = get(flowsCollection{iFlow},'A');
        B{iFlow} = get(flowsCollection{iFlow},'B');
        
        nVariables(1,iFlow) = size(A{iFlow},2);
        startDim (1,iFlow) = dimVariables + (size(A{iFlow},2) > 0);
        dimVariables = dimVariables + size(A{iFlow},1);
        
        nBinds(1,iFlow) = length(bindsCollection{iFlow});
        nExtInputs(1,iFlow) = size(B{iFlow},2) - nBinds(1,iFlow);
        dimInputs = dimInputs + nExtInputs(1,iFlow);
        
    end
    
    Amerged = [];
    Bmerged = [];
    
    inputIndex = 0;
    
    % Process the data flow by flow
    for iFlow = 1:1:nFlows
        
        Ainit = zeros(nVariables(1,iFlow),dimVariables);
        Binit = zeros(nVariables(1,iFlow),dimInputs);
        
        %Process A
        Ainit(:,startDim(1,iFlow):1:startDim(1,iFlow)+nVariables(1,iFlow)-1) = A{iFlow};
        
        % Get the bind description
        bindDesc = zeros(nBinds(1,iFlow),3);
        for iBind = 1:1:nBinds(1,iFlow)
            %get the matrices representation of the bind 
            %[idInput,idComponent, idStateVariable]
            bindDesc (iBind,:) = matricesRep(bindsCollection{iFlow}{iBind});
        end
        
        %number of external variables of the component
        nExtInputs = size(B{iFlow},2);
        
        for iInput = 1:1:nExtInputs
            
            % Check if the dimension shall be bind to a global state variable
            iBind = find((bindDesc(:,1)==iInput), 1);
            
            if(~isempty(iBind))
                % the input is internal to the whole system ; it is a state
                % variable of another component
                component = bindDesc(iBind,2);
                state = bindDesc(iBind,3);
                
                index = nVariables(1,1:component-1)*ones(component-1,1) + state;
                
                Ainit(:,index) = B{iFlow}(:,iInput);
            else
                % the input is external to the whole system
                inputIndex = inputIndex + 1;
                Binit(:,inputIndex) = B{iFlow}(:,iInput);
            end
        end
        
        % merge matrices
        
        Amerged = [Amerged ; Ainit];
        Bmerged = [Bmerged ; Binit];
        
    end
    
    mergedFlow = linearSys('mergedLinearSys',Amerged,Bmerged);
    
end

end

