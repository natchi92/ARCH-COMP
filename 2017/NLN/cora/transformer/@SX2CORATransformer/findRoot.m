function root = findRoot(obj,xmlStruct)
%FINDROOT finds a list of components which instanciates all
% the other components and are not instanciated.
% They are called here the root components
root = {};
nComponents = length(xmlStruct.sspaceex{1}.component);
componentBindsList = '';

% For each component in sspaceex
for iComponent = 1:1:nComponents
    tmpComponent = xmlStruct.sspaceex{1}.component{iComponent};
    
    % check if the component has a 'bind' field
    if(isfield(tmpComponent,'bind'))
        nBinds = length(tmpComponent.bind);
        
        %if there is a bind field
        for iBind = 1:1:nBinds
            % Get the name of the component binded
            % (instanciated)
            tmpBind = tmpComponent.bind{iBind};
            
            % Add the name to the string containing the list of
            % all the component instantiated by another.
            % (binded)
            componentBindsList = [componentBindsList tmpBind.Attributes.component];
            
        end
    end
end

% For each component, check if it is instanciated by another
% component. Component which are not instanciated by another
% components are considered as root component. They include all
% the others.
for iComponent = 1:1:nComponents
    tmpComponent = xmlStruct.sspaceex{1}.component{iComponent};
    
    if(isempty(strfind(componentBindsList, tmpComponent.Attributes.id)))
        root = [root tmpComponent];
    end
end

end

