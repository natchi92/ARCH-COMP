function [tp_total]=cellIntersection3(Obj,IH)
% As cellIntersection2, but with interval hulls
% Post:     cell indices, volumes
% Built:    09.10.06,MA


%initialize--------------------------------------------------------
tp(1:prod(Obj.nrOfSegments),1)=0; %tp: transition probability
%------------------------------------------------------------------

tv=volume(IH);
cellIndices=cellCandidates(Obj,IH);
%intersect cells with reachable set
for cellNr=cellIndices
    if cellNr~=0 %cell is not the outside cell
        %generate polytope out of cell
        sI=segmentIntervals(Obj,cellNr); %sIH: segment interval
        sIH=interval(sI(:,1),sI(:,2));
        
        %intersect interval hulls
        iIH=IH&sIH; %iIH: intersected interval

        %volume
        vol=volume(iIH);
        if tv<1e-10
            tp(cellNr,1)=0;
        else
            tp(cellNr,1)=(vol/tv); %tp: transition probability
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