function [P]=buildDatabase(Obj)
% Purpose:  Build database for the mapping from 1D to 2D movement
% Pre:      road object
% Post:     road object
% Built:    16.11.06,MA

%build prototype polytope
[Obj]=buildPrototypePolytope2(Obj);


%------------------------------------
%generate field for road
roadField=Obj.targetField;
%x/y cell length
segmentLength=get(Obj.targetField,'segmentLength');
xLength=segmentLength(1);
yLength=segmentLength(2);

probDistribution=[1,2,3,3.5,3,2,1];
edgeDistribution=[1,1,1,1];
deviationProbability=[0.98*1/sum(probDistribution)*[1,2,3,3.5,3,2,1],...
                     0.02*edgeDistribution];

%initialize waitbar
counter=0;
h = waitbar(0,'Calculate transition from 1D to 2D');
                
for iAngle=1:Obj.discretization(1)
    for iXoffset=1:Obj.discretization(2)
        for iYoffset=1:Obj.discretization(3)
            for iDeltaAngle=1:11
                %actual angle
                angle=(iAngle-1)/Obj.discretization(1)*2*pi;
                %actual x-offset
                xOffset=(iXoffset-1)/Obj.discretization(2)*xLength;
                %actual y-offset
                yOffset=(iYoffset-1)/Obj.discretization(3)*yLength;
                %build polytope
                [P]=buildPolytope(Obj,angle,xOffset,yOffset,iDeltaAngle);
                %get tp propapility, but define cell intersection for x/y plane
                %only; now its all states inclusing e.g. velocity-------------
                %initilaize probability
                nrOfSegments=get(roadField,'nrOfSegments');
                tp_total(1:(prod(nrOfSegments)+1),1)=0; %tp: transition probability
                for iPoly=1:length(P)
                    [tp]=cellIntersection2(roadField,P{iPoly});
                    tp_total=tp_total+deviationProbability(iPoly)*tp;
                end
                conv{iAngle,iXoffset,iYoffset,iDeltaAngle}=sparse(tp_total);
                %--------------------------------------------------------------

                %update waitbar
                counter=counter+1;
                waitbar(counter/(prod(Obj.discretization)*11),h);   
            end
        end
    end
end

%close waitbar
close(h);
%save
uisave