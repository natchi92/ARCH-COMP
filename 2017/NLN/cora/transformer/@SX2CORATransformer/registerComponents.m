function componentRegister = registerComponents(obj, xmlStruct)
nComponents = length(xmlStruct.sspaceex{1}.component);
keys = cell(1,nComponents);
values = cell(1,nComponents);

for iComponent = 1:1:nComponents
    keys{iComponent} = xmlStruct.sspaceex{1}.component{iComponent}.Attributes.id;
    values{iComponent} = iComponent;
end

componentRegister = containers.Map(keys, values);
end