function [indices]=forbidden(Obj,translation)
% Purpose:  calculates forbidden area for translated cells
% Pre:      partition object, translation
% Post:     indices of forbidden area


%interval of state space
IH=interval(Obj.intervals);
IH2=IH+(-translation);

%convert to polytopes
P1=convert2polytope(IH);
P2=convert2polytope(IH2);

%apply set difference
P=P1\P2;

forb_indices=[];
for i=1:length(P)
    [cellIndices]=cellCandidates(Obj,P(i));
    forb_indices=[forb_indices,cellIndices];
end

%cancel zero values
indices=nonzeros(forb_indices);