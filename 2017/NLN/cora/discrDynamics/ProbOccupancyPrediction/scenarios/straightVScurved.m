function straightVScurved()
% built: 09-October-2009

%create dummy Markov chain to avoid errors while loading
MCdummy=markovchain([],[]);
fieldDummy=partition([1,2],[2]);

%load Markov chain of car
[FileName,PathName] = uigetfile();
cd(PathName);
file=load(FileName);
% MC_car=file.MC;
% Tcar=get(MC_car,'T');
Tcar=file.T; %<--change here
projMat=file.projMat;
GammaFull=file.GammaFull;

clc

%initial set
initCarA=intervalhull([2, 8;... %interval for the position
                       12, 14]);    %interval for the speed 
                   

%initialize vehicle to get state and input field
%[HA,options,stateField,inputField]=initCar_D(1);
[HA,options,stateField,inputField]=initCar_E(1);


%set simOptions for straight road
simOptionsA.type='car'; %set as default for simplicity
simOptionsA.runs=20;
simOptionsA.initialStateSet=initCarA;
simOptionsA.stateField=stateField;
simOptionsA.inputField=inputField;
simOptionsA.profileHandle=@profile1;
simOptionsA.transitionMatrix=Tcar;
simOptionsA.projMat=projMat; %<--change here
simOptionsA.GammaFull=GammaFull; %<--change here
simOptionsA.mode='freeDriving';
simOptionsA.gamma=0.2;
simOptionsA.freeDrivingProb=[0.01 0.04 0.1 0.4 0.4 0.05];
%simOptionsA.initialInputProb=[0 0 0.5 0.5 0 0];
simOptionsA.initialInputProb=[0 0 0 1 0 0];
simOptionsA.frontProbVectorSeries=[];

%set simOptions for curved road
simOptionsB=simOptionsA;
simOptionsB.profileHandle=@profile4;

	
%Markov-Chain specific settings
markovChainSpec.timeStep=0.5;
markovChainSpec.nrOfInputs=6;
	
%instantiate simulation object
carA=simulation(simOptionsA,markovChainSpec);
%carA=simulate(carA); %<--change here
carA=simulateOptimized(carA); %<--change here

%instantiate simulation object
carB=simulation(simOptionsB,markovChainSpec);
profile on
%carB=simulate(carB); %<--change here
carB=simulateOptimized(carB); %<--change here
profile off
profile viewer

%get positio, velocity and input probability distribution
posA=get(carA,'posProb');
velA=get(carA,'velProb');
inputA=get(carA,'inputProb');
avgVelA=get(carA,'avgVel');

posB=get(carB,'posProb');
velB=get(carB,'velProb');
inputB=get(carB,'inputProb');
avgVelB=get(carB,'avgVel');


nrOfSegments=get(stateField,'nrOfSegments');
intervals=get(stateField,'intervals');

%plot position distribution
posField=partition(intervals(1,:),nrOfSegments(1));
for i=16
    figure
    hold on
    plotHisto(posField,posA{i},'k-');
    plotHisto(posField,posB{i},'k--');
    xlabel('s [m]');
    ylabel('probability');
end

%plot velocity distribution
velField=partition(intervals(2,:),nrOfSegments(2));
for i=16
    figure
    hold on
    plotHisto(velField,velA{i},'k-');
    plotHisto(velField,velB{i},'k--');
    xlabel('v [m/s]');
    ylabel('probability');  
end

%plot input distribution
for i=16
    figure
    hold on
    plotHisto(inputField,inputA{i},'k-');
    plotHisto(inputField,inputB{i},'k--');
    xlabel('u \in [-1,1]');
    ylabel('probability');      
end


%create road
R=road(4,5,1);


%straight road-------------------------------------------------------------

%create path
Rstraight=createPath(R,[pi/2,2,0],[0],[80]);

figure

%plot lowest and highest value for average probability
%plot using own methods
IH=[0.1 0.2; 0.1 0.2];
V=vertices(IH);
plot(V,'grayTones',4);
plot(V,'grayTones',18);

%plot velocity distribution
plot(Rstraight,avgVelA,1);

%plot crossing
plotCrossing(Rstraight,[43,80]);
axis([-10, 10, 0, 200]);


%curved road---------------------------------------------------------------

%create path
Rcurved=createPath(R,[pi/2,2,0],[0,+pi*6/50,+pi/50,0],[12,4,1,24]);

figure

%plot lowest and highest value for average probability
%plot using own methods
IH=[0.1 0.2; 0.1 0.2];
V=vertices(IH);
plot(V,'grayTones',4);
plot(V,'grayTones',18);

%plot velocity distribution
plot(Rcurved,avgVelB,1);

%plot crossing
plotCrossing(Rcurved,[35,80]);
axis([-60, 10, 0, 90]);
%--------------------------------------------------------------------------

%create road
Rcar=road(2,5,4);
dispR=road(4,5,7);

%deviation probability of the cars
devProbCar=[1,2,2,1];
devProbCar=devProbCar/sum(devProbCar);

deviationFieldCenter=partition([-1, 1],4);
deviationFieldBody=partition([-2, 2],7);
stretch=2; %[m]

%compute body distribution from vehicle center distribution
[dispDevProbCar]=vehicleBodyDistribution(deviationFieldCenter,deviationFieldBody,...
    stretch,devProbCar);

%create path
Rstraight=createPath(dispR,[pi/2,2,0],[0],[80]);
Rcurved=createPath(dispR,[pi/2,2,0],[0,+pi*6/50,+pi/50,0],[12,4,1,24]);

for iStep=16
    figure
    %set(gca,'DataAspectRatio',[1 3 3]);    
    %plot pA
    plot(Rstraight,posA{iStep},dispDevProbCar,'k');
    %plot crossing
    plotCrossing(Rstraight,[43,80]);
    axis([-10, 10, 0, 200]);
    
    figure
    %plot pB
    plot(Rcurved,posB{iStep},dispDevProbCar,'k');
    %plot crossing
    plotCrossing(Rcurved,[35,80]); 
    axis([-60, 10, 0, 90]);
end

