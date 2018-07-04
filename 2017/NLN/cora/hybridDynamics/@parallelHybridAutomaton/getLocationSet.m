function locationsCollection = getLocationSet(obj, loc)

nComponents = length(obj.components);

locationsCollection = cell(1,nComponents);

for iComponent = 1:1:nComponents
    resComp = get(obj.components{iComponent},'location');
    locationsCollection{iComponent} = resComp{loc(iComponent)};
    
end

end