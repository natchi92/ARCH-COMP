function [Tp] = MCcreator(KernelFunction,X)
%MCCREATOR Creates the Markov Chain that corresponds to the representative
%points contained in X. 
%   KernelFunction is the name of the kernel function. This input must
%   be a string.
%   X is a matrix input which consists of the centres of the cell as well
%   as the length of the edges.
%   The output Tp is a m by m matrix, where m equals the cardinality of the
%   partition defined in X.

% Check for presence of the parallel computing toolbox
v=ver;
if ~ismac
    if ~(any(strcmp('Parallel Computing Toolbox', {v.Name})))
        msgbox(sprintf('The Parallel Computing Toolbox is not installed on this device.\nInstalling this toolbox could increase the computation speed significantly.'),'Warning','warn')
    end
end


if ((~ismac) & (any(strcmp('Parallel Computing Toolbox', {v.Name}))))
    
    clear v

    % Cardinality
    m=size(X,1);

    % Dimension of the system
    dim=size(X,2)/2;

    % Number of cores of the system
    Cores=feature('numCores');

    % The timer for the calculation of the MC
    Ktime=Kind(KernelFunction,X);

    % Tolerances of the integration
    abstol=1/m/1000;
    reltol=1/1000;

    % Time check and notification set for calculations 
    Ctime=Ktime*m^2/Cores;
    button='';
    sound='';
    button = questdlg(['The creation of the transition matrix will take approximately, ',...
            num2str(floor(Ctime/60)),' minutes and ',...
            num2str(mod(round(Ctime),60)),' seconds. Plus an additional 10 seconds for the initialization of parallel computing. Do you wish to continue?'],...
            'Derivation Time','No');
    if strcmp(button,'No')
        errordlg('The process has been terminated')
        Tp=[];
        return
    elseif strcmp(button,'Yes')
       sound=questdlg(['Do you wish Matlab to notify you',...
           ' with a sound when the calculations have been finished?'],...
            'Notification','Yes');
    elseif strcmp(button,'Cancel')
       sound=display(['The process will continue. This will take approximately ',...
           num2str(round(Ctime)),' seconds.']);
    end

    % Open the matlabpool and first check if it is not already open
     s = isempty(gcp('nocreate'));
    if s==1
        parpool('local');
    end



    % Calculate the transition probabilities
    if dim == 3

        % Calculation of the pointwise transition probabilities
        Tp=zeros(m,m);
        p = ProgressBar(m); 
        parfor i=1:m
            for j=1:m
                p1=num2cell(X(i,1:dim));
                Tp(i,j)=integral3(@(x,y,z)KernelFunction(p1{:},x,y,z),X(j,1)-X(j,dim+1)*0.5,X(j,1)+X(j,dim+1)*0.5,X(j,2)-X(j,dim+2)*0.5,X(j,2)+X(j,dim+2)*0.5,X(j,3)-X(j,dim+3)*0.5,X(j,3)+X(j,dim+3)*0.5,'AbsTol',abstol,'RelTol',reltol);
            end
            p.progress;
        end
        p.stop;  

    elseif dim == 2
        % Calculation of the pointwise transition probabilities
        Tp=zeros(m,m);
        p = ProgressBar(m); 
        for i=1:m
            for j=1:m
                p1=num2cell(X(i,1:dim));
                Tp(i,j)=integral2(@(x,y)KernelFunction(p1{:},x,y),X(j,1)-X(j,dim+1)*0.5,X(j,1)+X(j,dim+1)*0.5,X(j,2)-X(j,dim+2)*0.5,X(j,2)+X(j,dim+2)*0.5,'AbsTol',abstol,'RelTol',reltol);
            end
            p.progress;
        end
        p.stop; 

    elseif dim == 1
        % Calculation of the pointwise transition probabilities
        p = ProgressBar(m); 
        Tp=zeros(m,m);
        parfor i=1:m
            for j=1:m
                p1=num2cell(X(i,1:dim));
                Tp(i,j)=integral(@(x)KernelFunction(p1{:},x),X(j,1)-X(j,dim+1)*0.5,X(j,1)+X(j,dim+1)*0.5,'AbsTol',abstol,'RelTol',reltol);
            end
            p.progress;
        end
        p.stop;

    else % for dim>3
        warndlg('There will be an aditional error, because of the high dimensionality of the system. The approximation error will be approximately twice as large. For a formal approach, please consider the Lipschitz method that includes the MC approximation error')

        % Calculation of the pointwise transition probabilities
        try %This is the fast but memory expensive way
            p=cell(1,2*dim);
            for i=1:dim
                p{i}=kron(X(:,i),ones(1,m));
            end
            for i=dim+1:2*dim
                p{i}=kron(X(:,i-dim)',ones(m,1));
            end
            Tp=KernelFunction(p{:});
        catch %This is the slower but less memory expensive way
            Tp=zeros(m,m);
            h = waitbar(0,'Creation of the Markov Chain');
            parfor i=1:m
                waitbar(i/m,h);
                for j=1:m
                    p1=num2cell(X(i,1:dim));
                    p2=num2cell(X(j,1:dim));
                    Tp(i,j)=KernelFunction(p1{:},p2{:});
                end
            end
            close(h);
        end

        % Make Tp transition probabilities by multiplying with the Lebesque measure 
        Tp=Tp.*kron(prod(X(:,dim+1:2*dim)',1),ones(m,1));

    end % this is the end of the "if-else" statement regarding the dimension of the system

delete(gcp('nocreate'));


    % Play sound if calculations have finished (optional)
    if strcmp(sound,'Yes')
        beep
    end

else % If not PC or Unix (so if Mac) or if the parallel toolbox is not installed
    

    % v=ver;
    % if ~(any(strcmp('Parallel Computing Toolbox', {v.Name})))
    %     msgbox(sprintf('The Parallel Computing Toolbox is not installed on this device.\nPlease add this toolbox to you computer.\n A second option is to remove the parallel computations from the GUI. Remove the matlabpool from MCcreator.m and replace parfor by for in this code and the whole GUI should work.'),'Warning','warn')
    % end
    % clear v

    % Cardinality
    m=size(X,1);

    % Dimension of the system
    dim=size(X,2)/2;

    % Number of cores of the system
    Cores=feature('numCores');

    % The timer for the calculation of the MC
    Ktime=Kind(KernelFunction,X);

    % Tolerances of the integration
    abstol=1/m/1000;
    reltol=1/1000;

    % Time check and notification set for calculations 
    Ctime=Ktime*m^2;
    button='';
    sound='';
    button = questdlg(['The creation of the transition matrix will take approximately, ',...
            num2str(floor(Ctime/60)),' minutes and ',...
            num2str(mod(round(Ctime),60)),' seconds. Do you wish to continue?'],...
            'Derivation Time','No');
    if strcmp(button,'No')
        errordlg('The process has been terminated')
        Tp=[];
        return
    elseif strcmp(button,'Yes')
       sound=questdlg(['Do you wish Matlab to notify you',...
           ' with a sound when the calculations have been finished?'],...
            'Notification','Yes');
    elseif strcmp(button,'Cancel')
       sound=display(['The process will continue. This will take approximately ',...
           num2str(round(Ctime)),' seconds.']);
    end



    % Calculate the transition probabilities
    if dim == 3

        % Calculation of the pointwise transition probabilities
        Tp=zeros(m,m);
        p = waitbar(0,'Progress of the MC creation'); 
        for i=1:m
            for j=1:m
                p1=num2cell(X(i,1:dim));
                Tp(i,j)=integral3(@(x,y,z)KernelFunction(p1{:},x,y,z),X(j,1)-X(j,dim+1)*0.5,X(j,1)+X(j,dim+1)*0.5,X(j,2)-X(j,dim+2)*0.5,X(j,2)+X(j,dim+2)*0.5,X(j,3)-X(j,dim+3)*0.5,X(j,3)+X(j,dim+3)*0.5,'AbsTol',abstol,'RelTol',reltol);
            end
            waitbar(i/m,p);
        end
        close(p)  

    elseif dim == 2
        % Calculation of the pointwise transition probabilities
        Tp=zeros(m,m);
        p = waitbar(0,'Progress of the MC creation'); 
        for i=1:m
            for j=1:m
                p1=num2cell(X(i,1:dim));
                Tp(i,j)=integral2(@(x,y)KernelFunction(p1{:},x,y),X(j,1)-X(j,dim+1)*0.5,X(j,1)+X(j,dim+1)*0.5,X(j,2)-X(j,dim+2)*0.5,X(j,2)+X(j,dim+2)*0.5,'AbsTol',abstol,'RelTol',reltol);
            end
            waitbar(i/m,p);
        end
        close(p) 

    elseif dim == 1
        % Calculation of the pointwise transition probabilities
        p = waitbar(0,'Progress of the MC creation'); 
        Tp=zeros(m,m);
        for i=1:m
            for j=1:m
                p1=num2cell(X(i,1:dim));
                Tp(i,j)=integral(@(x)KernelFunction(p1{:},x),X(j,1)-X(j,dim+1)*0.5,X(j,1)+X(j,dim+1)*0.5,'AbsTol',abstol,'RelTol',reltol);
            end
            waitbar(i/m,p);
        end
        close(p) 

    else % for dim>3
        warndlg('There will be an aditional error, because of the high dimensionality of the system. The approximation error will be approximately twice as large. For a formal approach, please consider the Lipschitz method that includes the MC approximation error')

        % Calculation of the pointwise transition probabilities
        try %This is the fast but memory expensive way
            p=cell(1,2*dim);
            for i=1:dim
                p{i}=kron(X(:,i),ones(1,m));
            end
            for i=dim+1:2*dim
                p{i}=kron(X(:,i-dim)',ones(m,1));
            end
            Tp=KernelFunction(p{:});
        catch %This is the slower but less memory expensive way
            Tp=zeros(m,m);
            h = waitbar(0,'Creation of the Markov Chain');
            for i=1:m
                waitbar(i/m,h);
                for j=1:m
                    p1=num2cell(X(i,1:dim));
                    p2=num2cell(X(j,1:dim));
                    Tp(i,j)=KernelFunction(p1{:},p2{:});
                end
            end
            close(h);
        end

        % Make Tp transition probabilities by multiplying with the Lebesque measure 
        Tp=Tp.*kron(prod(X(:,dim+1:2*dim)',1),ones(m,1));

    end % this is the end of the "if-else" statement regarding the dimension of the system

    % matlabpool close
delete(gcp('nocreate'))

    % Play sound if calculations have finished (optional)
    if strcmp(sound,'Yes')
        beep
    end

end

end % end of function

