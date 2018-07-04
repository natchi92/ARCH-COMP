function component = findInComponentRegister(obj, xmlStruct, componentRegister, componentName)
%FINDINCOMPONENTREGISTER is the function which returns the
%component qualified by the name componentName in the model.
index = componentRegister(componentName);

component = xmlStruct.sspaceex{1}.component{index};
end