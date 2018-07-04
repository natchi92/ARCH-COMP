function mFunctionName = generate(obj, xmlFilename)
%GENERATEFILE run the generation of the main matlab file to run
%CORA

if(nargin < 2)
    xmlFilename = 'bball.xml';
end

% We use the symbolic engine of MATLAB in this transformater ; we need to
% be sure that the symbolic variables are not used yet.
reset(symengine);

% Extract data from the xml file filename with xml2struct
xmlStruct = obj.xml2struct(xmlFilename);

% Generate main matlab CORA compatible file
mFunctionName = obj.generateMainFunction(xmlFilename, xmlStruct);

end

