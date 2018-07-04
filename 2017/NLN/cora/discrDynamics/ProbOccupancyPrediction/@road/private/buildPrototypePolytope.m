function [Obj]=buildPrototypePolytope(Obj)
% Purpose:  Build polytope for the mapping from 1D to 2D movement
% Pre:      road object
% Post:     road object
% Built:    16.11.06,MA

%Build initial vertices-----------------------------------------
I1=[0,Obj.width/2];
I2=[Obj.segmentLength,Obj.width/2];
I3=[Obj.segmentLength,-Obj.width/2];
I4=[0,-Obj.width/2];
%---------------------------------------------------------------

%minimum turning radius effects---------------------------------
%minimum turning radius for cars
minRadius=10; %[m]
%deviation in driving direction caused be turning radius
delta_y_r=minRadius-sqrt(minRadius^2-Obj.segmentLength^2);
%update vertices
R1=I1;
R2=I2+[0,delta_y_r];
R3=I3-[0,delta_y_r];
R4=I4;
%---------------------------------------------------------------

%uncertain starting angle---------------------------------------
%determine uncertain angle
uncertainAngle=pi/Obj.discretization(1); %in rad, half angle!
% deviation due to uncertain angle: staring points
delta_x_a(1)=Obj.width/2*atan(uncertainAngle);
% deviation due to uncertain angle: ending points
diag=sqrt(Obj.segmentLength^2+(Obj.width/2+delta_y_r)^2);
delta_s=diag*atan(uncertainAngle);
factor=delta_s/diag;
delta_x_a(2)=factor*(Obj.width/2+delta_y_r);
delta_y_a(2)=factor*Obj.segmentLength;
%update vertices
A1=R1+[-delta_x_a(1),0];
A2=R2+[-delta_x_a(2),delta_y_a(2)];
A3=R2+[+delta_x_a(2),-delta_y_a(2)];
A4=R3+[+delta_x_a(2),+delta_y_a(2)];
A5=R3+[-delta_x_a(2),-delta_y_a(2)];
A6=R4+[-delta_x_a(1),0];
%---------------------------------------------------------------

%uncertain starting position------------------------------------
%determine uncertain positions
segmentLength=get(Obj.targetField,'segmentLength');
xLength=segmentLength(1);
yLength=segmentLength(2);
delta_x_t=xLength/Obj.discretization(2);
delta_y_t=yLength/Obj.discretization(3);
%update vertices
T1=A1+[-delta_x_t,delta_y_t];
T2=A2+[-delta_x_t,delta_y_t];
T3=A2+[delta_x_t,delta_y_t];
T4=A3+[delta_x_t,delta_y_t];
T5=A4+[delta_x_t,-delta_y_t];
T6=A5+[delta_x_t,-delta_y_t];
T7=A5+[-delta_x_t,-delta_y_t];
T8=A6+[-delta_x_t,-delta_y_t];
%---------------------------------------------------------------

%divide into 7 parts of constant probability----------------------
delta_y_f(1)=(T1(2)-T8(2))/7;
delta_y_f(2)=(T4(2)-T5(2))/7;
%update vertices
F1=T1;
F2=T2;
F3=T3;
F4=T4;
F5=T4+[0,-delta_y_f(2)];
F6=T4+[0,-2*delta_y_f(2)];
F7=T4+[0,-3*delta_y_f(2)];
F8=T4+[0,-4*delta_y_f(2)];
F9=T4+[0,-5*delta_y_f(2)];
F10=T4+[0,-6*delta_y_f(2)];
F11=T5;
F12=T6;
F13=T7;
F14=T8;
F15=T8+[0,delta_y_f(1)];
F16=T8+[0,2*delta_y_f(1)];
F17=T8+[0,3*delta_y_f(1)];
F18=T8+[0,4*delta_y_f(1)];
F19=T8+[0,5*delta_y_f(1)];
F20=T8+[0,6*delta_y_f(1)];
%---------------------------------------------------------------

%generate polytopes---------------------------------------------
Obj.prototypeVertices{1}=[F1',F2',F3',F4',F5',F20'];
Obj.prototypeVertices{2}=[F20',F5',F6',F19'];
Obj.prototypeVertices{3}=[F19',F6',F7',F18'];
Obj.prototypeVertices{4}=[F18',F7',F8',F17'];
Obj.prototypeVertices{5}=[F17',F8',F9',F16'];
Obj.prototypeVertices{6}=[F16',F9',F10',F15'];
Obj.prototypeVertices{7}=[F15',F10',F11',F12',F13',F14'];
%---------------------------------------------------------------