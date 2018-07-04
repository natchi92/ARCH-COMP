function res = test_linearParam_reach_01_rlc_const()
% test_linearParam_reach_01_rlc_const - unit_test_function of 
% linear parametric reachability analysis
%
% Checks the solution of the linParamSys class for a RLC circuit example;
% It is checked whether the enclosing interval of the final reachable set 
% is close to an interval provided by a previous solution that has been saved
%
% Syntax:  
%    res = test_linearParam_reach_01_rlc_const()
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
% Written:      05-August-2016
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------


%init: get matrix zonotopes of the model
[matZ_A,matZ_B] = initRLC_uTest();
matI_A = intervalMatrix(matZ_A);

%get dimension
dim=matZ_A.dim;

%compute initial set
%specify range of voltages
u0 = intervalMatrix(0,0.2);

%compute inverse of A
intA = intervalMatrix(matZ_A);
invAmid = inv(mid(intA.int)); 

%compute initial set
intB = intervalMatrix(matZ_B);
R0 = invAmid*intB*u0 + intervalMatrix(0,1e-3*ones(dim,1));

%convert initial set to zonotope
R0 = zonotope(interval(R0));

%initial set
options.x0=center(R0); %initial state for simulation
options.R0=R0; %initial state for reachability analysis

%inputs
u=intervalMatrix(1,0.01);
U = zonotope(interval(intB*u));
options.uTrans=center(U);
options.U=U+(-options.uTrans); %input for reachability analysis

%other
options.tStart=0; %start time
options.tFinal=0.05; %final time
options.intermediateOrder = 2;
options.originContained = 0;
options.timeStep = 0.002;
options.eAt = expm(matZ_A.center*options.timeStep);

options.zonotopeOrder=400; %zonotope order
options.polytopeOrder=3; %polytope order
options.taylorTerms=6;

%time step
r = options.timeStep;
maxOrder=options.taylorTerms;

%instantiate linear dynamics with constant parameters
linSys  = linParamSys(matZ_A, eye(dim), r, maxOrder);
linSys2 = linParamSys(matI_A, eye(dim), r, maxOrder);

%initialize reachable set computations
Rcont = reach(linSys, options);
Rcont2 = reach(linSys2, options);

IH = interval(Rcont{end});
IH2 = interval(Rcont2{end});

%saved result
IH_saved = interval( ...
           [0.306719934550558; 0.261686995344786; 0.205140104990298; 0.070775319855058; 0.121656358051319; 0.101078425262069; -0.167307526553961; -0.433189975058412; -0.559407671974744; -0.597855660134973; -0.605862744290804; -0.605210099576931; -0.593217122438070; -0.533075938688302; -0.509177979954288; -0.514497339720059; -0.503576270350033; -0.433614855008524; -0.410036599034696; -0.357848438474787; -0.051584017438266; -0.056718969276525; -0.061690240265133; -0.058099107466501; -0.060038345683795; -0.069140775878981; -0.064471005961840; -0.051167231173559; -0.041332952677669; -0.037147958398752; -0.035925967760522; -0.035603222073092; -0.035231822278726; -0.034055179556937; -0.030839750122631; -0.031709984152309; -0.027445410462298; -0.028454415971626; -0.027383300631638; -0.025048546301898], ...
           [1.012498349648415; 1.022219606280711; 1.066755945909392; 0.983033753751761; 1.125016030336341; 1.163304109089465; 0.970547086842670; 0.767099233474366; 0.657276977430920; 0.619277314450646; 0.609514427926836; 0.605710364774635; 0.593273548068857; 0.533081279883893; 0.509178410905055; 0.514497369740225; 0.503576272175054; 0.433614855106240; 0.410036599039340; 0.357848438474992; -0.018408619466865; -0.009014318915743; -0.010593823547688; -0.004318258205781; -0.002942825825170; -0.009766067450337; -0.000583724729783; 0.017707019599571; 0.029681958241767; 0.034204093313258; 0.035358458402883; 0.035516635149294; 0.035221072848300; 0.034054070000083; 0.030839653239185; 0.031709976894206; 0.027445409990258; 0.028454415944709; 0.027383300630281; 0.025048546301837]);
IH_saved2 = interval( ...
           [0.268137155205288; 0.214829590073189; 0.153548446243936; 0.016070322162430; 0.066624892552552; 0.048988777702973; -0.212787018759149; -0.474388671613980; -0.598872927184542; -0.636824819438984; -0.644698718220947; -0.643892956115271; -0.631527674225192; -0.570149633439592; -0.543615999214095; -0.546996720127730; -0.533466563866825; -0.460597605438818; -0.433131135551899; -0.379358808605373; -0.053402430227511; -0.059354350995493; -0.064661277530719; -0.061289578527928; -0.063297393700210; -0.072398880978112; -0.067420592595509; -0.053774885416525; -0.043766880734612; -0.039522668099940; -0.038285649776992; -0.037956349700996; -0.037573402090260; -0.036352183990443; -0.032990103124714; -0.033728850682811; -0.029310079065773; -0.030170242097112; -0.028909022474591; -0.026337176149684], ...
           [1.051085128537773; 1.069080786314540; 1.118351226346796; 1.037741429301869; 1.180051619883789; 1.215398099200521; 1.016029136838964; 0.808298884329947; 0.696742480376267; 0.658246521348469; 0.648350408913992; 0.644393222144982; 0.631584099935664; 0.570154974641477; 0.543616430165275; 0.546996750147919; 0.533466565691848; 0.460597605536534; 0.433131135556543; 0.379358808605578; -0.016590292457154; -0.006379099726989; -0.007623006205914; -0.001127937467378; 0.000316042819970; -0.006508228972471; 0.002365651762787; 0.020314576530226; 0.032115856387948; 0.036578796417375; 0.037718139320602; 0.037869762634094; 0.037562652644899; 0.036351074432319; 0.032990006241178; 0.033728843424703; 0.029310078593733; 0.030170242070195; 0.028909022473233; 0.026337176149623]);
       
%check if slightly bloated versions enclose each other for IH
res_11 = (IH <= enlarge(IH_saved,1+1e-8));
res_12 = (IH_saved <= enlarge(IH,1+1e-8));

%check if slightly bloated versions enclose each other for IH2
res_21 = (IH2 <= enlarge(IH_saved2,1+1e-8));
res_22 = (IH_saved2 <= enlarge(IH2,1+1e-8));

%final result
res = res_11*res_12*res_21*res_22;

% %obtain random simulation results
% stepsizeOptions = odeset('MaxStep',0.2*(options.tStart-options.tFinal));
% %generate overall options
% opt = odeset(stepsizeOptions);
% 
% %init time and state trajectory
% runs=30;
% inputChanges=4;
% t=cell(runs,inputChanges);
% x=cell(runs,inputChanges);
% finalTime=options.tFinal;
% 
% for i=1:runs
%     options.tStart=0;
%     options.tFinal=finalTime/inputChanges;
%     for iChange = 1:inputChanges
%         %set initial state, input
%         if iChange == 1
%             if i<=15
%                 options.x0=randPointExtreme(options.R0); %initial state for simulation
%             else
%                 options.x0=randPoint(options.R0); %initial state for simulation
%             end
%         else
%             options.tStart=options.tFinal;
%             options.tFinal=options.tFinal+finalTime/inputChanges;
%             options.x0 = x{i,iChange-1}(end,:);
%         end
%         if i<=8
%             options.u=randPointExtreme(options.U)+options.uTrans; %input for simulation
%         else
%             options.u=randPoint(options.U)+options.uTrans; %input for simulation
%         end
% 
%         %simulate hybrid automaton
%         [linSys2,t{i,iChange},x{i,iChange}] = simulate(linSys2,options,options.tStart,options.tFinal,options.x0,opt); 
%     end
% end
% 
% for plotRun=1:2
%     if plotRun==1
%         projectedDimensions=[1 21];
%     else
%         projectedDimensions=[20 40];
%     end
% 
%     figure;
%     hold on
% 
%     %plot reachable sets
%     for i=1:length(Rcont2)
%         Zproj = project(Rcont2{i},projectedDimensions);
%         Zproj = reduce(Zproj,'girard',3);
%         plotFilled(Zproj,[1 2],[.675 .675 .675],'EdgeColor','none');
%     end
% 
%     for i=1:length(Rcont)
%         Zproj = project(Rcont{i},projectedDimensions);
%         Zproj = reduce(Zproj,'girard',3);
%         plotFilled(Zproj,[1 2],[.75 .75 .75],'EdgeColor','none');
%     end
% 
%     %plot initial set
%     plotFilled(options.R0,projectedDimensions,'w','EdgeColor','k');
% 
%     %plot simulation results      
%     for i=1:length(t)
%         for j=1:length(t(i,:))
%             plot(x{i,j}(:,projectedDimensions(1)),x{i,j}(:,projectedDimensions(2)),'Color',0*[1 1 1]);
%         end
%     end
% 
%     xlabel(['x_{',num2str(projectedDimensions(1)),'}']);
%     ylabel(['x_{',num2str(projectedDimensions(2)),'}']);
% end
% 
% figure;
% hold on
% 
% %plot time elapse
% for i=1:length(Rcont2)
%     %get Uout 
%     Uout1 = interval(project(Rcont{i},0.5*dim));
%     Uout2 = interval(project(Rcont2{i},0.5*dim));
%     %obtain times
%     t1 = (i-1)*options.timeStep;
%     t2 = i*options.timeStep;
%     %generate plot areas as interval hulls
%     IH1 = interval([t1; infimum(Uout1)], [t2; supremum(Uout1)]);
%     IH2 = interval([t1; infimum(Uout2)], [t2; supremum(Uout2)]);
% 
%     plotFilled(IH2,[1 2],[.675 .675 .675],'EdgeColor','none');
%     plotFilled(IH1,[1 2],[.75 .75 .75],'EdgeColor','none');
% end
% 
% %plot simulation results
% for i=1:(length(t))
%     for j=1:length(t(i,:))
%         plot(t{i,j},x{i,j}(:,0.5*dim),'Color',0*[1 1 1]);
%     end
% end


%------------- END OF CODE --------------