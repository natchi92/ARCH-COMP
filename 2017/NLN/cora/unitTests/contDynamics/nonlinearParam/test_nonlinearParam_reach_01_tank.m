function res = test_nonlinearParam_reach_01_tank()
% test_nonlinearParam_reach_01_tank - unit_test_function of nonlinear
% reachability analysis with uncertain parameters
%
% Checks the solution of the nonlinearSys class for the 6 tank example with 
% uncertain parameters;
% It is checked whether the enclosing interval of the final reachable set 
% is close to an interval provided by a previous solution that has been saved
%
% Syntax:  
%    res = test_nonlinearParam_reach_01_tank()
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
% Written:      30-June-2009
% Last update:  16-June-2011
%               16-August-2016
% Last revision:---


%------------- BEGIN CODE --------------

dim=6;

%set options --------------------------------------------------------------
options.tStart=0; %start time
options.tFinal=400; %final time
options.x0=[2; 4; 4; 2; 10; 4]; %initial state for simulation
options.R0=zonotope([options.x0,0.2*eye(dim)]); %initial state for reachability analysis
options.timeStep=4;
options.taylorTerms=4; %number of taylor terms for reachable sets
options.intermediateOrder = options.taylorTerms;
options.zonotopeOrder=10; %zonotope order
options.reductionTechnique='girard';
options.maxError = 1*ones(dim,1);
options.reductionInterval=1e3;
options.tensorOrder = 1;

options.advancedLinErrorComp = 0;

options.u=0; %input for simulation
options.U=zonotope([0,0.005]); %input for reachability analysis
options.uTrans=0; %has to be zero for nonlinear systems!!

options.p=0.015; %parameter values for simulation
options.paramInt=interval(0.0148,0.015); %parameter intervals for reachability analysis
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------

%specify continuous dynamics-----------------------------------------------
tankParam = nonlinParamSys(6,1,1,@tank6paramEq,options.maxError,options); %initialize system
%--------------------------------------------------------------------------
        
%compute reachable set
Rcont = reach(tankParam,options);

%compute enclosing interval
IH = interval(Rcont{end}{1});

%saved result
IH_saved = interval( ...
    [2.4903170845176050; 2.3881154927166337; 2.2338114998240024; 2.0731833864553750; 1.9221501296260928; 1.8269962610779964], ...
    [3.6946128601939452; 3.4968232604830307; 3.2453015515143604; 2.9900914653986699; 2.8058423087894533; 2.7519808608048622]);

%check if slightly bloated versions enclose each other
res_1 = (IH <= enlarge(IH_saved,1+1e-8));
res_2 = (IH_saved <= enlarge(IH,1+1e-8));

%final result
res = res_1*res_2;

% %specify continuous dynamics-----------------------------------------------
% tank = nonlinearSys('tank6',6,1,@tank6Eq,options); %initialize tank system
% %--------------------------------------------------------------------------
% 
% %compute reachable set using zonotopes
% RcontNoParam = reach(tank, options);
% 
% %simulate
% stepsizeOptions = odeset('MaxStep',0.2*(options.tStart-options.tFinal));
% %generate overall options
% opt = odeset(stepsizeOptions);
% 
% %initialize
% runs=30;
% 
% for i=1:runs
% 
%     %set initial state, input
%     if i<=15
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
%     [tankParam,t{i},x{i}] = simulate(tankParam,options,options.tStart,options.tFinal,options.x0,opt); 
% end
% 
% 
% plotOrder = 20;
% 
% %plot dynamic variables
% for plotRun=1:1
% 
%     
%     if plotRun==1
%         projectedDimensions=[1 2];
%     end 
% 
%     figure;
%     hold on
% 
%     %plot reachable sets of zonotope; uncertain parameters
%     for i=1:length(Rcont)
%         for j=1:length(Rcont{i})
%             Zproj = reduce(Rcont{i}{j},'girard',plotOrder);
%             plotFilled(Zproj,projectedDimensions,[.675 .675 .675],'EdgeColor','none');
%         end
%     end
%     
%     %plot reachable sets of zonotope; without uncertain parameters
%     for i=1:length(RcontNoParam)
%         for j=1:length(RcontNoParam{i})
%             Zproj = reduce(RcontNoParam{i}{j},'girard',plotOrder);
%             plotFilled(Zproj,projectedDimensions,'w','EdgeColor','k');
%         end
%     end
%     
%   
%     %plot simulation results      
%     for i=1:length(x)
%         plot(x{i}(:,1),x{i}(:,2),'k');
%     end
%     
%     %plot initial set
%     plotFilled(options.R0,projectedDimensions,'w','EdgeColor','k');
% 
%     xlabel('x_1');
%     ylabel('x_2');
% end

%------------- END OF CODE --------------