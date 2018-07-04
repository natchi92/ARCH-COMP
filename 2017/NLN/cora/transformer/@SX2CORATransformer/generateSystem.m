function generateSystem(obj, fileID, xmlStruct, rootComponents)
%GENERATESYSTEM generates the root components of the system (=
%generate the matlab code associated to the entire system)

% Generate the call to the root function of the system
nRoots = length(rootComponents);
tmpFct = 'loc = [];\n \n';

componentRegister = registerComponents(obj, xmlStruct);

idSet = 0;
componentIdSet = 0;

for iRoot = 1:1:nRoots
    % Called root functions
    
    tmpFct = [ tmpFct 'loc = [loc , generated_cora_' rootComponents{iRoot}.Attributes.id '()];\n \n' ];
    
%     tmpFct = [ tmpFct,'loc{' int2str(iRoot) '} = ' rootComponents{iRoot}.Attributes.id '();\n \n'];
    
    [ inputComponentBindRegister, stateComponentBindRegister, idSet, componentIdSet ] = registerBinds( obj, xmlStruct, componentRegister, [], rootComponents{iRoot}, idSet, componentIdSet);
    
    for iObjectComponent = 1:1:componentIdSet
        
        index = inputComponentBindRegister(:,1) == iObjectComponent;
        inputBindComponent = inputComponentBindRegister(index,:);
        
        nInputBindComponent = size(inputBindComponent,1);
        tmpFct = [tmpFct 'bd=cell(1,' int2str(nInputBindComponent) ');\n \n'];
        
        for iInputBindComponent = 1:1: nInputBindComponent
            
            tmpInputId = inputBindComponent(iInputBindComponent,2);
            tmpGlobalId = inputBindComponent(iInputBindComponent,3);
            
            indexx = stateComponentBindRegister(:,3) == tmpGlobalId;
            
            stateBindComponent = stateComponentBindRegister(indexx,:);
            
            tmpFct = [ tmpFct 'bd{' int2str(iInputBindComponent) '} = bind(' int2str(tmpInputId) ',' int2str(stateBindComponent(1)) ',' int2str(stateBindComponent(2)) ');\n \n' ];
        end
        
        tmpFct = [ tmpFct 'comp{' int2str(iObjectComponent) '} = component(' char(39) 'comp' int2str(iObjectComponent) char(39) ',[], loc{' int2str(iObjectComponent) '},bd);\n \n' ];
        
    end
    
end

fprintf(fileID, tmpFct);

nComponents = length(xmlStruct.sspaceex{1}.component);

for iComponent = 1:1:nComponents
    obj.generateComponent(xmlStruct.sspaceex{1}.component{iComponent});
end

end
