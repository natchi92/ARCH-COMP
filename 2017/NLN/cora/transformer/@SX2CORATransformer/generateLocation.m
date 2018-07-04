function generateLocation(obj, fileID, location, paramTypeStruct)

%GENERATELOCATION generates the code implementing a location

% Generates the invariant of the location
if(isfield(location, 'invariant'))
    obj.generateInvariant(fileID, location.invariant{1}, paramTypeStruct);
else
    fprintf(fileID,'inv=[];\n\n');
end

% Generates the flow of the location
if(isfield(location, 'flow'))
    obj.generateFlows(fileID, location.flow{1}, paramTypeStruct);
else
    fprintf(fileID,'flow=[];\n\n');
end

% Generates the location
id = location.Attributes.id;

fprintf(fileID,'loc{%s}=location(''loc_%s'',%s,inv,trans{%s},flow);\n\n'...
    ,id,id,id,id);

end