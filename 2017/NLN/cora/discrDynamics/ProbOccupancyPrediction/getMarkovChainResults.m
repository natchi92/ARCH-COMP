function [ car ] = getMarkovChainResults( segmentLength, timeStep, runs, leftIntervalPositionAndSpeedColumn, rightIntervalPositionAndSpeedColumn )

    %load Markov chain of car
    cd([coraroot filesep 'discrDynamics' filesep 'ProbOccupancyPrediction' filesep 'MarkovModels']);
    file = load(strcat('markovChain_segLength', int2str(segmentLength), '_step', num2str(timeStep), '.mat'));

    probModel = file.probModel;
    Tcar = probModel.T;    %Transition matrix of the markov chain 
    projMat = probModel.projMat;   %Projection from velocity and position to position only
    GammaFull = probModel.GammaFull;   %acceleration profiles

    %Markov-Chain specific settings
    markovChainSpec.timeStep = probModel.timeStep;
    markovChainSpec.nrOfInputs = prod(get(probModel.inputField,'nrOfSegments'));

    %obtain state and input field
    stateField = probModel.stateField;
    inputField = probModel.inputField;

    %initial set
    initCar = interval(leftIntervalPositionAndSpeedColumn, rightIntervalPositionAndSpeedColumn);

    %set simOptions for straight road
    simOptions.type = 'car'; %set as default for simplicity
    simOptions.runs = runs;    %Anzahl der Markovchain Schritte
    simOptions.initialStateSet = initCar;
    simOptions.stateField = stateField;
    simOptions.inputField = inputField;
    simOptions.profileHandle = @profile1;    %Profil für verschiedene Geschwindigkeiten
    simOptions.transitionMatrix = Tcar;
    simOptions.projMat = projMat; %<--change here
    simOptions.GammaFull = GammaFull; %<--change here
    simOptions.mode = 'freeDriving'; %freie Straße voraus => Keine Anpassung an andere Verkehrsteilnehmer
    simOptions.gamma = 0.2;
    simOptions.freeDrivingProb = [0.01 0.04 0.1 0.4 0.4 0.05];   %Wsk für verschiedene Beschleunigungen von voll bremsen zu voll beschleunigen
    simOptions.initialInputProb = [0 0 0 1 0 0];     %Beschleunigungswskten

    %instantiate simulation object
    carSim = simulation(simOptions, markovChainSpec);
    car = simulateOptimized(carSim); 
end

