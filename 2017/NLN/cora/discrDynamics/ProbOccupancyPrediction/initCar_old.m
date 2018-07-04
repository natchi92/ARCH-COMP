function [HA,options,stateField,inputField]=initCar(varargin)
% built: 31-March-2008 

directory=cd;

%set options---------------------------------------------------------------
options.tStart=0; %start time
options.tFinal=0.5; %final time
%options.tFinal=0.5; %final time
options.startLoc=1; %initial location
options.finalLoc=0; %final location
options.timeStep=0.05; %time step size for reachable set computation
options.taylorTerms=4; %number of taylor terms for reachable sets
options.zonotopeOrder=10; %zonotope order
options.polytopeOrder=6; %polytope order
options.projectedDimensions=[1 2];
options.reductionInterval=1e3;
options.target='vehicleDynamics';
%--------------------------------------------------------------------------

%specify continuous dynamics-----------------------------------------------
acc=nonlinearSys('acc',2,1,@accSys,interval([0;0],[0;10])); %acceleration
dec=linearSys('dec',[0 1;0 0],[0;10]); %deceleration
sL=linearSys('sL',[0 1;0 0],[0;0]); %speed limit
sS=zeroDynSys('sS',2); %standstill
%--------------------------------------------------------------------------

%specify transitions-------------------------------------------------------

%reset map for all transitions
reset.A=eye(2); 
reset.b=zeros(2,1);

%long distance l
l=[0 1e3]; %-->probabilities may only escape in driving direction
maxSpeed=[21 22];
zeroSpeed=[0.001 0.01];

%specify invariant
inv=intervalhull([l; 0 22]); %invariant for all locations

%guard sets
IHstop=intervalhull([l; zeroSpeed]);

IHmaxSpeed=intervalhull([l; maxSpeed]);                                

%specify transitions
tran1{1}=transition(IHmaxSpeed,reset,2,'a','b'); 
tran2=[]; 
tran3{1}=transition(IHstop,reset,4,'a','b');
tran4=[];

%--------------------------------------------------------------------------

%specify locations              
loc{1}=location('acc',inv,tran1,acc);
loc{2}=location('sL',inv,tran2,sL);
loc{3}=location('dec',inv,tran3,dec);
loc{4}=location('sS',inv,tran4,sS);


%specify hybrid automaton
HA=hybridAutomaton(loc);

%Initialize partition------------------------------------------------------
stateField=partition([0, 200;... %position in m
                      0, 22],...  %velocity in m/s         
                     [40;10]);
inputField=partition([-1,1],...  %acceleartion in m/s^2
                     6);  
%--------------------------------------------------------------------------

if nargin==1
    cd(directory);
end