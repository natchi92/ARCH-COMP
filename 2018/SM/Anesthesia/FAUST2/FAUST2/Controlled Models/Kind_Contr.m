function [Ktime] = Kind_Contr(KernelFunction,X,U)
%KIND_CONTR Calculates the time it takes to do one calculation of the kernel by
%averaging over a number of trials

% Cardinality of the partition of the SafeSet
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;

% The dimension of the system 
dim_u = size(U,2)/2;

% Tolerances of the integration
abstol=1/m/1000;
reltol=1/1000;

% Two points with two delta's
p1=num2cell(X(1,1:dim));
p2=num2cell(X(end,1:dim));

delta1=num2cell(X(1,dim+1:2*dim));
delta2=num2cell(X(end,dim+1:2*dim));

% One input
try
    u1=num2cell(U(floor(end/2),1:dim_u));
catch % if there is only one input u
    u1=num2cell(U(1,1:dim_u));
end

% Calculate the transition probabilities
if dim == 3
    tic;
    for i=1:10
        integral3(@(x,y,z)KernelFunction(p1{:},x,y,z,u1{:}),p1{1}-delta1{1}*0.5,p1{1}+delta1{1}*0.5,p1{2}-delta1{2}*0.5,p1{2}+delta1{2}*0.5,p1{3}-delta1{3}*0.5,p1{3}+delta1{3}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral3(@(x,y,z)KernelFunction(p1{:},x,y,z,u1{:}),p2{1}-delta2{1}*0.5,p2{1}+delta2{1}*0.5,p2{2}-delta2{2}*0.5,p2{2}+delta2{2}*0.5,p2{3}-delta2{3}*0.5,p2{3}+delta2{3}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral3(@(x,y,z)KernelFunction(p2{:},x,y,z,u1{:}),p2{1}-delta2{1}*0.5,p2{1}+delta2{1}*0.5,p2{2}-delta2{2}*0.5,p2{2}+delta2{2}*0.5,p2{3}-delta2{3}*0.5,p2{3}+delta2{3}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral3(@(x,y,z)KernelFunction(p2{:},x,y,z,u1{:}),p1{1}-delta1{1}*0.5,p1{1}+delta1{1}*0.5,p1{2}-delta1{2}*0.5,p1{2}+delta1{2}*0.5,p1{3}-delta1{3}*0.5,p1{3}+delta1{3}*0.5,'AbsTol',abstol,'RelTol',reltol);
    end
    t=toc;
    
    Ktime=t/(40);
    
elseif dim == 2
    tic;
    for i =1:10
        integral2(@(x,y)KernelFunction(p1{:},x,y,u1{:}),p1{1}-delta1{1}*0.5,p1{1}+delta1{1}*0.5,p1{2}-delta1{2}*0.5,p1{2}+delta1{2}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral2(@(x,y)KernelFunction(p1{:},x,y,u1{:}),p2{1}-delta2{1}*0.5,p2{1}+delta2{1}*0.5,p2{2}-delta2{2}*0.5,p2{2}+delta2{2}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral2(@(x,y)KernelFunction(p2{:},x,y,u1{:}),p2{1}-delta2{1}*0.5,p2{1}+delta2{1}*0.5,p2{2}-delta2{2}*0.5,p2{2}+delta2{2}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral2(@(x,y)KernelFunction(p2{:},x,y,u1{:}),p1{1}-delta1{1}*0.5,p1{1}+delta1{1}*0.5,p1{2}-delta1{2}*0.5,p1{2}+delta1{2}*0.5,'AbsTol',abstol,'RelTol',reltol);
    end
    t=toc;
    
    Ktime=t/(40);
    
elseif dim == 1
    tic;
    for i =1:10
        integral(@(x)KernelFunction(p1{:},x,u1{:}),p1{1}-delta1{1}*0.5,p1{1}+delta1{1}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral(@(x)KernelFunction(p1{:},x,u1{:}),p2{1}-delta2{1}*0.5,p2{1}+delta2{1}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral(@(x)KernelFunction(p2{:},x,u1{:}),p2{1}-delta2{1}*0.5,p2{1}+delta2{1}*0.5,'AbsTol',abstol,'RelTol',reltol);
        integral(@(x)KernelFunction(p2{:},x,u1{:}),p1{1}-delta1{1}*0.5,p1{1}+delta1{1}*0.5,'AbsTol',abstol,'RelTol',reltol);
    end
    t=toc;
    
    Ktime=t/(40);

    
else
    tic;
    
    for i =1:1000
        KernelFunction(p1{:},p2{:},u1{:});
        KernelFunction(p2{:},p2{:},u1{:});
        KernelFunction(p2{:},p1{:},u1{:});
        KernelFunction(p1{:},p1{:},u1{:});
    end
    t=toc;
    
    Ktime=t/(4000);

    
end % this is the end of the "if-else" statement regarding the dimension of the system

end

