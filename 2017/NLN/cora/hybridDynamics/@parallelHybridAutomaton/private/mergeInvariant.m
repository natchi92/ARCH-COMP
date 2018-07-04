function mergedInvariant = mergeInvariant( invariantCollection, options)
%MERGEINVARIANT Summary of this function goes here
%   Detailed explanation goes here

nInvariants = length(invariantCollection);

if(nInvariants == 1 && iscell(invariantCollection))
    mergedInvariant = invariantCollection{1};
elseif (nInvariants == 1 && ~iscell(invariantCollection))
    mergedInvariant = invariantCollection;
else
    invariantCollectionAsPolytope = cell(1,nInvariants);
    A=[];
    b=[];
    
    for iInvariant = 1:1:nInvariants
        
        if(isa(invariantCollection{iInvariant},'mptPolytope'))
            
            invariantCollectionAsPolytope{1,iInvariant} = invariantCollection{iInvariant};
            invariantCollectionAsPolytope{1,iInvariant} = halfspace(invariantCollectionAsPolytope{1,iInvariant});
            
            H = get(invariantCollectionAsPolytope{1,iInvariant},'H');
            K = get(invariantCollectionAsPolytope{1,iInvariant},'K');
            
            [dimA1,dimA2] = size(A);
            [dimH1,dimH2] = size(H);
            A1 = zeros(dimA1,dimH2);
            A2 = zeros(dimH1,dimA2);
            
            A=[A, A1; A2, H];
            b=[b ; K];
            
        elseif(isa(invariantCollection{iInvariant},'halfspace'))
            invariantCollectionAsPolytope{1,iInvariant} = invariantCollection{iInvariant};
            
            c = invariantCollectionAsPolytope{1,iInvariant}.c;
            d = invariantCollectionAsPolytope{1,iInvariant}.d;
            
            
            [dimA1,dimA2] = size(A);
            [dimH1,dimH2] = size(c);
            A1 = zeros(dimA1,dimH2);
            A2 = zeros(dimH1,dimA2);
            
            A=[A, A1; A2, c];
            b=[b ; d];
            
        else
            
            invariantCollectionAsPolytope{1,iInvariant} = polytope(invariantCollection{iInvariant},options);
            invariantCollectionAsPolytope{1,iInvariant} = halfspace(invariantCollectionAsPolytope{1,iInvariant});
                
                H = get(invariantCollectionAsPolytope{1,iInvariant},'H');
                K = get(invariantCollectionAsPolytope{1,iInvariant},'K');
                
                [dimA1,dimA2] = size(A);
                [dimH1,dimH2] = size(H);
                A1 = zeros(dimA1,dimH2);
                A2 = zeros(dimH1,dimA2);
                
                A=[A, A1; A2, H];
                b=[b ; K];
            
        end
        
    end
    
    mergedInvariant = mptPolytope(A,b);
    
end
end

