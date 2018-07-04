function [Zred]=reduceGirardMultiple(Z,order)
% reduceGirard - Reduce zonotope so that its order stays below a specified
% limit 
%
% Syntax:  
%    [Zred]=reduceGirard(Z,order)
%
% Inputs:
%    Z - zonotope object
%    order - desired order of the zonotope
%
% Outputs:
%    Zred - reduced zonotope
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author:       Matthias Althoff
% Written:      31-August-2011
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

%initialize Z_red
Zred=cell(1,length(order));

%get Z-matrix from zonotope Z
Zmatrix=get(Z,'Z');

%extract generator matrix
G=Zmatrix(:,2:end);

if ~isempty(G)

    %determine dimension of zonotope
    dim=length(G(:,1));
    
    %compute metric of generators
    h=vnorm(G,1,1)-vnorm(G,1,inf);

    [elements,indices]=sort(h);


    %for each order
    for iOrder = 1:length(order)
    
        %only reduce if zonotope order is greater than the desired order
        if length(G(1,:))>dim*order(iOrder)

            %number of generators that are not reduced
            nUnreduced=floor(dim*(order(iOrder)-1));
            %number of generators that are reduced
            nReduced=length(G(1,:))-nUnreduced;

            %pick generators that are reduced
            pickedGenerators=G(:,indices(1:nReduced));
            %compute interval hull vector d of reduced generators
            d=sum(abs(pickedGenerators),2);
            %build box Gbox from interval hull vector d
            Gbox=diag(d);

            %unreduced generators
            Gunred=G(:,indices((nReduced+1):end));

            %build reduced zonotope
            if iOrder==1
                Zred{iOrder}=zonotope([Zmatrix(:,1),Gunred,Gbox]);
            else
                Zred{iOrder}=zonotope([0*Zmatrix(:,1),Zmatrix(:,1),Gunred,Gbox]);
            end
        else
            %do not change zonotope
            if iOrder==1
                Zred{iOrder}=zonotope(Zmatrix);
            else
                Zred{iOrder}=zonotope([0*Zmatrix(:,1),Zmatrix]);
            end
        end

    end
end


%------------- END OF CODE --------------