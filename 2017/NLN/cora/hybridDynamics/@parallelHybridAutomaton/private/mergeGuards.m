function [ mergedGuard ] = mergeGuards(guardsCollection, options)
%MERGEGUARDS Summary of this function goes here
%   Detailed explanation goes here

nGuards = length(guardsCollection);

if(nGuards == 1 && iscell(guardsCollection))
    mergedGuard = guardsCollection{1};
elseif (nGuards == 1 && ~iscell(guardsCollection))
    mergedGuard = guardsCollection;
else
    guardsCollectionAsPolytope = cell(1,nGuards);
    A=[];
    b=[];
    
    for iGuard = 1:1:nGuards
        
        if(isa(guardsCollection{iGuard},'mptPolytope'))
            
            guardsCollectionAsPolytope{1,iGuard} = guardsCollection{iGuard};
            guardsCollectionAsPolytope{1,iGuard} = halfspace(guardsCollectionAsPolytope{1,iGuard});
            
            H = get(guardsCollectionAsPolytope{1,iGuard},'H');
            K = get(guardsCollectionAsPolytope{1,iGuard},'K');
            
            [dimA1,dimA2] = size(A);
            [dimH1,dimH2] = size(H);
            A1 = zeros(dimA1,dimH2);
            A2 = zeros(dimH1,dimA2);
            
            A=[A, A1; A2, H];
            b=[b ; K];
            
        elseif(isa(guardsCollection{iGuard},'halfspace'))
            guardsCollectionAsPolytope{1,iGuard} = guardsCollection{iGuard};
            
            c = guardsCollectionAsPolytope{1,iGuard}.c;
            d = guardsCollectionAsPolytope{1,iGuard}.d;
            
            
            [dimA1,dimA2] = size(A);
            [dimH1,dimH2] = size(c);
            A1 = zeros(dimA1,dimH2);
            A2 = zeros(dimH1,dimA2);
            
            A=[A, A1; A2, c];
            b=[b ; d];
            
        else
            
            guardsCollectionAsPolytope{1,iGuard} = polytope(guardsCollection{iGuard},options);
            guardsCollectionAsPolytope{1,iGuard} = halfspace(guardsCollectionAsPolytope{1,iGuard});
                
                H = get(guardsCollectionAsPolytope{1,iGuard},'H');
                K = get(guardsCollectionAsPolytope{1,iGuard},'K');
                
                [dimA1,dimA2] = size(A);
                [dimH1,dimH2] = size(H);
                A1 = zeros(dimA1,dimH2);
                A2 = zeros(dimH1,dimA2);
                
                A=[A, A1; A2, H];
                b=[b ; K];
            
        end
        
    end

    mergedGuard = mptPolytope(A,b);
    
end

end

