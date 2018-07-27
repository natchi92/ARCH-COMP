% LocalLipschitz_testfile

% Testing environment for a certain KernelFunction and X.
% Here different approaches to select the best way to approximate the
% Lipschitz constant are tested.


% Cardinality of the partition of the SafeSet
m=size(X,1);

% Dimension of the system
dim=size(X,2)/2;


% Creating the symbolic functions to derive the derivative of the kernel
derivative='';
seq='';
for i=1:dim
    eval(['syms',' ','x',num2str(i),' ','real'])
    eval(['syms',' ','x',num2str(i),'bar ','real'])
    derivative=[derivative,'diff(KernelFunction,x',num2str(i),');'];
    seq=[seq,'x(',num2str(i*2-1),'),x(',num2str(i*2),'),'];
end
derivative=derivative(1:end-1);
seq=seq(1:end-1);

[~,Kernel2]=evalc(['norm([',derivative,'],2)']);
Kernel3=matlabFunction(Kernel2);

% Initialization
h_ij=zeros(m,m);

% Selection matrix for h_ij_f
C=unique(nchoosek(repmat([0 1],1,dim*2),dim*2),'rows')-0.5;

% creation of the gradient vector
for i=1:dim
    g(i)=eval(['diff(Kernel3,x',num2str(i),')']);
    g(i+dim)=eval(['diff(Kernel3,x',num2str(i),'bar)']);
end
f = matlabFunction(-Kernel2, -g,'outputs', {'name1','name2'});


%%% Test environment %%%%%%%%%%%%%%%%%%%%
profile on
% Options for the fmincon function
options = optimset('Algorithm','trust-region-reflective','GradObj','on','TolFun',1e-20,'MaxIter',30);

% Calculation of the pointwise minima and maxima for the remaining points
h = waitbar(0,'Derivation of the local Lipschitz constants');
tic

for i=1:m
    waitbar(i/m,h);
    for j=1:m
        try
            % "True" value of Lipschitz constant
            [~,~,h_ij_a(i,j)] =  evalc(['fmincon(@(x) (f(',seq,')),[X(i,1:dim)'';X(j,1:dim)''],[],[],[],[],[X(i,1:dim)-0.5*X(i,dim+1:2*dim),X(j,1:dim)-0.5*X(j,dim+1:2*dim)]'',[X(i,1:dim)+0.5*X(i,dim+1:2*dim),X(j,1:dim)+0.5*X(j,dim+1:2*dim)]'',[],options)']);
        catch
            options = optimset('Algorithm','sqp','GradObj','off','TolFun',1e-20,'MaxIter',30);
            [~,~,h_ij_a(i,j)] =  evalc(['fmincon(@(x) (Kernel3(',seq,')),[X(i,1:dim)'';X(j,1:dim)''],[],[],[],[],[X(i,1:dim)-0.5*X(i,dim+1:2*dim),X(j,1:dim)-0.5*X(j,dim+1:2*dim)]'',[X(i,1:dim)+0.5*X(i,dim+1:2*dim),X(j,1:dim)+0.5*X(j,dim+1:2*dim)]'',[],options)']);
            options = optimset('Algorithm','trust-region-reflective','GradObj','on','TolFun',1e-20,'MaxIter',30);
        end
        % Computation of important points
        p0=num2cell([X(i,1:dim),X(j,1:dim)]);

        p1=num2cell([X(i,1:dim)+X(i,dim+1:2*dim)*0.5,X(j,1:dim)]);
        p2=num2cell([X(i,1:dim)-X(i,dim+1:2*dim)*0.5,X(j,1:dim)]);
        p3=num2cell([X(i,1:dim)+X(i,dim+1:2*dim)*0.5,X(j,1:dim)+X(j,dim+1:2*dim)*0.5]);
        p4=num2cell([X(i,1:dim)-X(i,dim+1:2*dim)*0.5,X(j,1:dim)+X(j,dim+1:2*dim)*0.5]);
        p5=num2cell([X(i,1:dim)+X(i,dim+1:2*dim)*0.5,X(j,1:dim)-X(j,dim+1:2*dim)*0.5]);
        p6=num2cell([X(i,1:dim)-X(i,dim+1:2*dim)*0.5,X(j,1:dim)-X(j,dim+1:2*dim)*0.5]);

        % Centre derivative
        h_ij_b0(i,j) = Kernel3(p0{:});

        % Maximum of 6 local derivatives
        h_ij_b1 = Kernel3(p1{:});
        h_ij_b2 = Kernel3(p2{:});
        h_ij_b3 = Kernel3(p3{:});
        h_ij_b4 = Kernel3(p4{:});
        h_ij_b5 = Kernel3(p5{:});
        h_ij_b6 = Kernel3(p6{:});
        h_ij_c(i,j) = max([h_ij_b1,h_ij_b2,h_ij_b3,h_ij_b4,h_ij_b5,h_ij_b6]);
        h_ij_c2(i,j) = max([h_ij_b3,h_ij_b4,h_ij_b5,h_ij_b6]);
        
        
                       
        for q=1:2^(dim*2)
            p=num2cell([[X(i,1:dim),X(j,1:dim)]-[X(i,dim+1:2*dim),X(j,dim+1:2*dim)].*C(q,:)]);
            r(q,:)=p;
            h_ij_f_aux(q)=Kernel3(p{:});
        end
        h_ij_f(i,j)=max(h_ij_f_aux);

        % Numerical derivative in centre
        ksi=0.001;
        p1n=num2cell([X(i,1:dim)+X(i,dim+1:2*dim)*ksi,X(j,1:dim)]);
        p2n=num2cell([X(i,1:dim)-X(i,dim+1:2*dim)*ksi,X(j,1:dim)]);
        h_ij1 = KernelFunction(p1n{:});
        h_ij2 = KernelFunction(p2n{:});
        h_ij_d(i,j)=abs(h_ij1-h_ij2)/norm(X(i,dim+1:2*dim)*ksi*2,2);
        
        % Numerical derivative over full delta
        h_ij1 = KernelFunction(p1{:});
        h_ij2 = KernelFunction(p2{:});
        h_ij_e(i,j)=abs(h_ij1-h_ij2)/norm(X(i,dim+1:2*dim),2);
    end
    
end
time=toc
h_ij_a=-h_ij_a;
surf(100*(h_ij_a-h_ij_f)./h_ij_a);
close(h);
profile off

