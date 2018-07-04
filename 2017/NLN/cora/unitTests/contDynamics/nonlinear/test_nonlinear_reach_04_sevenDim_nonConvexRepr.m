function res = test_nonlinear_reach_04_sevenDim_nonConvexRepr()
% test_nonlinear_reach_04_sevenDim_nonConvexRepr - unit_test_function of 
% nonlinear reachability analysis
%
% Checks the solution of a 7-dimensional nonlinear example using a non-convex
% set representation;
% It is checked whether the reachable set is enclosed in the initial set
% after a certain amount of time.
%
% Syntax:  
%    res = test_nonlinear_reach_04_sevenDim_nonConvexRepr()
%
% Inputs:
%    no
%
% Outputs:
%    res - boolean 
%
% Example: 
%
% 
% Author:       Matthias Althoff
% Written:      26-January-2016
% Last update:  ---
% Last revision:---


%------------- BEGIN CODE --------------


dim=7;

%set options --------------------------------------------------------------
options.tStart=0; %start time
options.tFinal=0.2; %final time
%options.tFinal=6; %final time
options.x0=[1.2; 1.05; 1.5; 2.4; 1; 0.1; 0.45]; %initial state for simulation
options.R0=quadZonotope(options.x0,0.3*eye(dim),[],[],[]); %initial state for reachability analysis

options.timeStep=0.01; %time step size for reachable set computation
options.taylorTerms=4; %number of taylor terms for reachable sets
options.zonotopeOrder=50; %zonotope order
options.intermediateOrder=5;
options.reductionTechnique='girard';
options.errorOrder=2;
options.polytopeOrder=10; %polytope order
options.reductionInterval=1e3;
options.maxError = 2*ones(dim,1);

options.plotType='frame';
options.projectedDimensions=[1 2];

options.originContained = 0;
options.advancedLinErrorComp = 1;
options.tensorOrder = 3;
%--------------------------------------------------------------------------


%obtain uncertain inputs
options.uTrans = 0;
options.U = zonotope([0]); %input for reachability analysis

%specify continuous dynamics-----------------------------------------------
sys=nonlinearSys(7,1,@sevenDimNonlinEq,options); %initialize system
%--------------------------------------------------------------------------


%compute reachable set using polynomial zonotopes
Rcont = reach(sys, options);

%enclose result by interval
IH = interval(Rcont{end}{1});

%saved result
IH_saved = interval( ...
           [1.015086470461199; 0.800810016164073; 0.927530844088316; 1.611992718257251; 0.493347453224304; -0.069668009056024; 0.006667467946238], ...
           [1.699261379137569; 1.510045429540476; 1.681251494057691; 2.415994519692043; 1.102069270980971; 0.292482477537971; 0.707554523186273]);
        
%check if slightly bloated versions enclose each other
res_1 = (IH <= enlarge(IH_saved,1+1e-8));
res_2 = (IH_saved <= enlarge(IH,1+1e-8));

%final result
res = res_1*res_2;

% %simulate
% stepsizeOptions = odeset('MaxStep',0.2*(options.tStart-options.tFinal));
% %generate overall options
% opt = odeset(stepsizeOptions);
% 
% %initialize
% runs=40;
% finalTime = options.tFinal;
% 
% for i=1:runs
% 
%     %set initial state, input
%     if i<=30
%         options.x0=randPointExtreme(options.R0); %initial state for simulation
%     else
%         options.x0=randPoint(options.R0); %initial state for simulation
%     end
% 
%     %set input
%     if i<=8
%         options.u=randPointExtreme(options.U)+options.uTrans; %input for simulation
%     else
%         options.u=randPoint(options.U)+options.uTrans; %input for simulation
%     end
% 
%     %simulate hybrid automaton
%     [sys,t{i},x{i}] = simulate(sys,options,options.tStart,options.tFinal,options.x0,opt); 
% end
% 
% 
% %plot
% for plotRun=1:1
%     if plotRun==1
%         projectedDimensions=[1 2];
%     end
% 
%     figure;
%     hold on
% 
%     %plot reachable sets of zonotope
%     for i=1:length(Rcont)
%         Zproj = project(Rcont{i}{1},projectedDimensions);
%         Zproj = reduce(Zproj,'girard',20);
%         plot(Zproj);
%     end
% 
%     %plot initial set
%     plotFilled(options.R0,projectedDimensions,1,[],'w','EdgeColor','k');
% 
%     %plot simulation results      
%     for i=1:length(t)
%             plot(x{i}(:,projectedDimensions(1)),x{i}(:,projectedDimensions(2)),'Color',0*[1 1 1]);
%     end
% 
%     xlabel(['x_{',num2str(projectedDimensions(1)),'}']);
%     ylabel(['x_{',num2str(projectedDimensions(2)),'}']);
% end


%------------- END OF CODE --------------