function [ mergedLocation ] = mergeLocation(locationsCollection, mergedLocationId, bindsCollection, options)
%MERGELOCATION Summary of this function goes here
%   Detailed explanation goes here

nLocations = length(locationsCollection);

if(nLocations == 1 && iscell(locationsCollection))
    mergedLocation = locationsCollection{1};
elseif (nLocations == 1 && ~iscell(locationsCollection))
    mergedLocation = locationsCollection;
else
    
    nLocations = length(locationsCollection);
    
    nCombinaisons = 1;
    
    for iLocation = 1:1:nLocations
        
        invariantCollection{iLocation} = get(locationsCollection{iLocation},'invariant');
        
        flowsCollection{iLocation} = get(locationsCollection{iLocation},'contDynamics');
        
        transitionsCollection{iLocation} = get(locationsCollection{iLocation},'transition');
        
        nTransitions{iLocation} = length(transitionsCollection{iLocation});
        
        indexTransitions{iLocation} = [1:nTransitions{iLocation}+1];
        
        nCombinaisons = nCombinaisons * nTransitions{iLocation};
    end

    %Merge invariant
    mergedInvariant = mergeInvariant(invariantCollection, options);
    
    %Merge Flows
    mergedFlow = mergeFlows(flowsCollection, bindsCollection, options);
    
    
    %Merge transitions
    allcombinaisons = allcomb(indexTransitions{:});
    
    [nCombinaisons, nComponents] = size(allcombinaisons);
    
    for iCombinaison = 1:1:nCombinaisons
        
        transitionsCollectionToMerge = {};
        
        for iComponent = 1:1:nComponents

            index = allcombinaisons(iCombinaison, iComponent);
            
            if(index-1 ~= 0)
                %if it is a true transition
                transitionsCollectionToMerge{iComponent} = transitionsCollection{iComponent}{index-1};

            else
                %if it is a fake transition modelling that the location of
                %the component does not change
                resFlow = flowsCollection{iComponent};
                
                % Get the number of state variables : There should be a
                % method to get this data from any continuous dynamics
                % implementation !!! For the moment : only linear system
                nStates = size(get(resFlow,'A'),2);
                
                emptyGuards = mptPolytope(zeros(0,nStates));
                emptyReset.A = diag(ones(nStates,1));
                emptyReset.b = zeros(nStates,1);

                transitionsCollectionToMerge{iComponent} = transition(emptyGuards, emptyReset, mergedLocationId(iComponent),'inputLabel','outputlabel');
            end
        end
        
        mergedTransitionCollection{iCombinaison} = mergeTransition(transitionsCollectionToMerge, options);
    end
    
    mergedLocationName = 'loc';
    
    mergedLocation = location(mergedLocationName,mergedLocationId,mergedInvariant,mergedTransitionCollection,mergedFlow);
end

end

