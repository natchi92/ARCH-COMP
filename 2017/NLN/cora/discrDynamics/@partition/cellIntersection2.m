function [tp_total]=cellIntersection2(Obj,P)
% Purpose:  Calculate the volumes of a polytope P with cells Ci
% Pre:      partition object, P (polytope)
% Post:     cell indices, volumes
% Built:    09.10.06,MA
% Modified: 26.03.08,MA

%initialize--------------------------------------------------------
tp(1:prod(Obj.nrOfSegments),1)=0; %tp: transition probability
%------------------------------------------------------------------

tv=modVolume(P);
%check if polytope is not empty
if tv~=0
    cellIndices=cellCandidates(Obj,P);
    %intersect cells with reachable set
    for cellNr=cellIndices
        if cellNr~=0 %cell is not the outside cell
            %generate polytope out of cell
            sP=segmentPolytope(Obj,cellNr); %sP: segment polytope
            iP=P&sP; %iP:intersected polytope

            %volume
            vol=modVolume(iP);
            if tv<1e-10
                tp(cellNr,1)=0;
            else
                tp(cellNr,1)=(vol/tv); %tp: transition probability
            end
         end
    end
end

%calculate probability that outside area is reached
tp_outside=1-sum(tp);
if tp_outside<-0.01
    disp('transition probability error')
    disp(['P(outside)=',num2str(tp_outside)])
end
tp_total=[tp_outside;tp];

tp_total=sparse(tp_total);