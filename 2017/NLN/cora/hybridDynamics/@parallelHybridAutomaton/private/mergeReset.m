function [ mergedReset ] = mergeReset(resetsCollection, options)
%MERGERESET Summary of this function goes here
%   Detailed explanation goes here

nReset = length(resetsCollection);

if(nReset == 1 && iscell(resetsCollection))
    mergedReset = resetsCollection{1};
elseif (nReset == 1 && ~iscell(resetsCollection))
    mergedReset = resetsCollection;
else
    %resetsCollection = cell(1,nReset);
    mergedA=[];
    mergedb=[];
    
    for iRest = 1:1:nReset
        resA = resetsCollection{1,iRest}.A;
        resb = resetsCollection{1,iRest}.b;
        
        [dimMergedA1,dimMergedA2] = size(mergedA);
        [dimA1,dimA2] = size(resA);
        A1 = zeros(dimMergedA1,dimA2);
        A2 = zeros(dimA1,dimMergedA2);
        
        mergedA=[mergedA, A1; A2, resA];
        mergedb=[mergedb ; resb];
    end
    
    mergedReset.A = mergedA;
    mergedReset.b = mergedb;
end

end

