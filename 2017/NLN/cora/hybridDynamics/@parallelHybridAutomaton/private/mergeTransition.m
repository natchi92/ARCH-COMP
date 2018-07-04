function [ mergedTransition ] = mergeTransition(transitionsCollection, options )
%MERGETRANSITION Summary of this function goes here
%   Detailed explanation goes here

nTransitions = length(transitionsCollection);

if(nTransitions == 1 && iscell(transitionsCollection))
    mergedTransition = transitionsCollection{1};
elseif (nTransitions == 1 && ~iscell(transitionsCollection))
    mergedTransition = transitionsCollection;
else
    
    nTransitions = length(transitionsCollection);
    
    for iTransition = 1:1:nTransitions

        guardCollection{iTransition} = get(transitionsCollection{iTransition},'guard');
        
        resetCollection{iTransition} = get(transitionsCollection{iTransition},'reset');
        
        target(iTransition) = get(transitionsCollection{iTransition},'target');
    end
    
    mergedGuard = mergeGuards(guardCollection, options);
    
    mergedReset = mergeReset(resetCollection, options);
    
    % trans = transition(guard,reset,indexTarget,'inputLAbel','outputLabel'); %transition
    mergedTransition = transition(mergedGuard, mergedReset, target,'inputLabel','outputlabel');
    
end
end

