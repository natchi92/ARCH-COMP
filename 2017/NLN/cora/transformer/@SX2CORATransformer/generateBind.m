        function generateBind(obj,fileID, bind, constantsList)
            %GENERATEBIND generate the code implementing a bind
            %Example : loc = [loc , cora_filter_4th_order(-5)];
            if(isfield(bind, 'map'))
                nMaps = length(bind.map);
                
                functionName = [ 'generated_cora_' bind.Attributes.component()];
                
                % Construct the mapping of the bind
                keys = cell(1,nMaps);
                values = cell(1,nMaps);
                for iMaps = 1:1:nMaps
                    values{iMaps} = bind.map{iMaps}.Text;
                    keys{iMaps} = bind.map{iMaps}.Attributes.key;
                end
                map = containers.Map(keys, values);

                % Construct the string to print
                % It is a call to the function implemeting the component to
                % bind
                sortedKeys = sort(keys);
                strCallFunction = ['loc = [loc , ' functionName '('];
                nKeys = nMaps;
                for iKey = 1:1:nKeys   
                    %check if the value associated to the key in the map is a
                    %number...
                    status = ~isnan(str2double(map(cell2mat(sortedKeys(iKey)))));            

                    if(status || ismember(sortedKeys(iKey), constantsList))
                        strCallFunction = [strCallFunction map(cell2mat(sortedKeys(iKey))) ','];
                    end
                end
                if(strCallFunction(end) == ',')
                    strCallFunction = strCallFunction(1:end-1);
                end
                
                strCallFunction = [ strCallFunction ')];\n \n' ];
                
                fprintf(fileID, strCallFunction);
            end
        end