function bindsCollection = getBindsSet(obj)

nComponents = length(obj.components);

bindsCollection = cell(1,nComponents);

for iComponent = 1:1:nComponents
    
    bindsCollection{iComponent} = get(obj.components{iComponent},'binds');
    
end

end
