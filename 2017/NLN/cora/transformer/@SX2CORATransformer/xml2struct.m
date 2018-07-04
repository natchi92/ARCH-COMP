function xmlStruct = xml2struct(obj, xmlFilename)
%XML2STRUCT extracts a MATLAB structure from an SX XML file

%xml2FriendlyStruct is a private method which contains the actual
%implementation of the transformation of a XML file to a MATLAB structure
xmlStruct = xml2FriendlyStruct(xmlFilename);

end

