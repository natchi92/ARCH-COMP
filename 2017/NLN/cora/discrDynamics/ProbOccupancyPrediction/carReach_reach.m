function carReach_reach()
%generates Markov model based on reachability analysis

%mpt_init('extreme_solver', 'matlab');
%mpt_init('extreme_solver', 'lrs','abs_tol',1e-6,'rel_tol',1e-5);
mpt_init('extreme_solver', 'lrs','abs_tol',1e-5,'rel_tol',1e-4);

[HA,options,stateField,inputField]=initCar_B();
 
%Initialize Markov Chain
MC=markovchain(stateField);

%obtain number of segments of the state discretization
nrOfSegments=get(stateField,'nrOfSegments');

%total number of discrete inputs, states, positions and velocities
totalNrOfInputs=prod(get(inputField,'nrOfSegments'));
totalNrOfStates=prod(get(stateField,'nrOfSegments'));
totalNrOfPositions=nrOfSegments(1);
totalNrOfVelocities=nrOfSegments(2);

% check for even number of inputs
if rem(totalNrOfInputs,2)>0
        disp('Number of Inputs is inappropriate! (only even number)')
end


%for all input combinations
for iInput=1:totalNrOfInputs
    
    %initialize waitbar  
    %h = waitbar(0,['iInput:',num2str(iInput)]);    
    
    %generate input intervals
    uZ=segmentZonotope(inputField,iInput);
    for i=1:totalNrOfInputs
        options.Uloc{i}=uZ;
        options.uLoc{i}=center(uZ);
    end
    
    
    %for all velocities
    for iVel=1:totalNrOfVelocities
            
        %obain current discrete state 
        iState=(iVel-1)*totalNrOfPositions+1;
        %update discretized state space
        stateField=set(stateField,'actualSegmentNr',iState);
        MC=set(MC,'field',stateField);
        
        %display iInput and iState
        iInput
        iState
        
        options.R0=segmentZonotope(stateField,iState);

        %determine initial location
        if iInput>(totalNrOfInputs/2)
            options.startLoc=1; %acceleration
        else
            options.startLoc=3; %deceleartion
        end           
        
        %compute reachable set
        HA=reach(HA,options);     
   
        %Update Markov Chain
        MC=build4road(MC,HA,iInput,iState);
          %if mod(iState,19)==0
           if iState>3000
                plot(MC,HA,options,iState);
           end
        
        %update waitbar
        %waitbar(iState/totalNrOfStates,h); 
    end
end
%close waitbar
%close(h);

%save results to file
[file,path] = uiputfile('*.mat','Save Markov Chain As');
cd(path);
save(file,'MC');
