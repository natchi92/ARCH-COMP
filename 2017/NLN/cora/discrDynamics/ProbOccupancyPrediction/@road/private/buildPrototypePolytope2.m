function [Obj]=buildPrototypePolytope2(Obj)
% Purpose:  Build polytope for the mapping from 1D to 2D movement
% Pre:      road object
% Post:     road object
% Built:    06.12.06,MA
% Modified: 13.11.07,MA


for iAngle=1:11
    angle=(iAngle-6)/Obj.discretization(1)*2*pi;

    %Build initial vertices-----------------------------------------
    I1=[0,Obj.width/2];
    I2=[Obj.segmentLength,Obj.width/2];
    I3=[Obj.segmentLength,-Obj.width/2];
    I4=[0,-Obj.width/2];
    %---------------------------------------------------------------

    %delta angle computation----------------------------------------

    %auxiliary point
    auxPoint=[Obj.segmentLength*cos(angle),Obj.segmentLength*sin(angle)];
    %update vertices
    R1=I1;
    R2=auxPoint+0.5*[-Obj.width*sin(angle),Obj.width*cos(angle)];
    R3=auxPoint+0.5*[Obj.width*sin(angle),-Obj.width*cos(angle)];
    R4=I4;
    if angle>0
        R5=I4+[0.5*Obj.segmentLength,0];
    elseif angle<0
        R5=I1+[0.5*Obj.segmentLength,0];
    else
        R5=I1;
    end
    %---------------------------------------------------------------

    %uncertain starting angle---------------------------------------
    %determine uncertain angle
    uncertainAngle=pi/Obj.discretization(1); %in rad, half angle!
    % deviation due to uncertain angle: staring points
    delta_x_a(1)=Obj.width/2*atan(uncertainAngle);
    % deviation due to uncertain angle: ending points
    factor=atan(uncertainAngle);
    delta_x_a(2)=factor*Obj.width/2;
    delta_y_a(2)=factor*Obj.segmentLength;
    delta_x_a(3)=factor*Obj.width/2;
    delta_y_a(3)=factor*Obj.segmentLength/2;
    %update vertices
    A1=R1+[-delta_x_a(1),0];
    A2=R2+[-delta_x_a(2),delta_y_a(2)];
    A3=R2+[+delta_x_a(2),-delta_y_a(2)];
    A4=R3+[+delta_x_a(2),+delta_y_a(2)];
    A5=R3+[-delta_x_a(2),-delta_y_a(2)];
    A6=R4+[-delta_x_a(1),0];
    if angle>0
        A7=R5+[-delta_x_a(3),-delta_y_a(3)];
    elseif angle<0
        A7=R5+[-delta_x_a(3),delta_y_a(3)];;
    else
        A7=A1;
    end
    %---------------------------------------------------------------

    %generate polytopes---------------------------------------------
    %generate helping points H
    %divide into 7 parts of constant probability
    delta_y_h(1)=(R1(2)-R4(2))/7;
    delta_y_h(2)=(R2(2)-R3(2))/7;
    delta_x_h(1)=(R2(1)-R3(1))/7;

    for i=1:7
        P{i}=polytope([R1-[0,(i-1)*delta_y_h(1)];R2-[(i-1)*delta_x_h(1),(i-1)*delta_y_h(2)];...
            R2-[i*delta_x_h(1),i*delta_y_h(2)];R1-[0,i*delta_y_h(1)]]);
    end

    auxP1=polytope([A1;A2;A3;A4;A5;A6;A7]);
    %bloat due to uncertain starting position----------
    segmentLength=get(Obj.targetField,'segmentLength');
    xLength=segmentLength(1);
    yLength=segmentLength(2);
    delta_x_t=xLength/Obj.discretization(2);
    delta_y_t=yLength/Obj.discretization(3);
    IH=interval([-delta_x_t; -delta_y_t], [delta_x_t;delta_y_t]);
    auxP2=polytope(IH);
    auxP3=auxP1+auxP2;
    %--------------------------------------------------
    auxP4=polytope([R1;R2;R3;R4]);

    P{8}=auxP3\auxP4;
    counter=1;
    
    %make vertices
    for iV=1:8
        for iPoly=1:length(P{iV})
            Obj.prototypeVertices{iAngle,counter}=extreme(P{iV}(iPoly))';
            counter=counter+1;
        end
    end
end