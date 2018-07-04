function functionName = generateMainFunction(obj, xmlFilename, xmlStruct)
%GENERATEMAINFUNCTION generates the output matlab file of the transformation which will be used to run CORA

% Define naming norm
functionName = ['generated_cora_main_' strrep(xmlFilename,'.xml','')]; % remove the XML extension from the input filename and add the "Generated_" tag in the beginning
mFilename = [functionName '.m']; % add the matlab extension to the functionName

% Open the generated matlab files and get its ID
folder = [coraroot '/contDynamics/stateSpaceModels/'];
fileID = fopen([folder mFilename], 'w');

% Header of the generated function
headerFunction = ['function PHA = ' functionName '()\n\n'];
fprintf(fileID, headerFunction);

% Main comment of the generated function
dateComment = ['%% Generated on ' datestr(date) '\n\n'];
functionComment = ['%% ' functionName ' is the generated function implementing a parallel hybrid automaton. \n \n'];
headerComment = [functionComment dateComment];
fprintf(fileID, headerComment);

%find the super components of the system
rootComponents = obj.findRoot(xmlStruct);

%generate the system part
obj.generateSystem(fileID, xmlStruct, rootComponents)

%generate the call to the CORA tool / hybridautomata, simulate,
%reach

strRunCORA = '';

strRunCORA = [ strRunCORA '%%define the parallel hybrid automaton \n' ];
strRunCORA = [ strRunCORA 'PHA = parallelHybridAutomaton(comp); \n \n' ];

fprintf(fileID, strRunCORA);

% end
fprintf(fileID, 'end');

%close the file
fclose(fileID);


end

