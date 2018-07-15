function [a] = Matlab2PRISM_Contr(Tp,method)
%MATLAB2PRISM_CONTR converts a transition kernel to one or
% multiple files that can be imported by the PRISM model checker.
%   [a] = Matlab2PRISM(Tp,method)
%   Tp should be a m by m transition matrix with m equal to the cardinality
%   of the partition of the safe set.
%   Furthermore a method can be defined to either a .tra file 
%   and a .sta file that work with the command line version of PRISM or
%   output a .prism file that works with the PRISM GUI.
%   method can be either 'Normal' or 'GUI'. 'Normal' is selected when the
%   function is given only one input


% Cardinality
m=size(Tp,1);

% Cardinality of the input
q=size(Tp,3);

% Check the number of inputs
if nargin==1
    method='Normal';
end

% Create a subfolder for the PRISM files
if exist([cd,'\PRISM']) ~= 7
    mkdir('PRISM');
end

% Adjust Tp for the transition to the "non Safe" Set
Tp=cat(2,Tp,1-sum(Tp,2));

% Adjust Tp for remaining in the "non Safe" Set if it is reached
Tp=cat(1,Tp,cat(2,zeros(1,m,q),ones(1,1,q)));


%%% The creation of the output files %%%
switch method
    case 'Normal'

        % Make a small file for timing purposes (if m*q is bigger than 50)
        if m*q>100 
            m_test=min(round(m/10),100); % Number of lines to write
            q_test=min(round(q/10),100); % Number of lines to write

            % List of states
            Tp_aux=Tp(1:m_test+1,1:m_test+1,1:q_test);
            listm=0:1:m_test; % PRISM states start at 0 (The m^th state is the non-safe state)
            listq=0:1:q_test-1; % PRISM states start at 0
            [listm2,listm1,listq1]=ndgrid(listm,listm,listq);
            total=[listm2(:) listq1(:) listm1(:) Tp_aux(:)]';

            % Transition file
            fileID = fopen('PRISM/test.tra','w');
            Timer1=tic;
            fprintf(fileID,'%u %u %u\r\n',m_test,q_test*m_test,q_test*m_test^2);
            fprintf(fileID,'%1.0f %1.0f %1.0f %1.4e\r\n',total);
            Ktime1=toc(Timer1);
            fclose(fileID);


            % states file
            opening=':(';
            closing=')';
            fileID = fopen('PRISM/test.sta','w');
            Timer2=tic;
            fprintf(fileID,'%0s\r\n','(s)');
            total=cellstr([num2str(list'),repmat(opening,m_test+1,1),num2str(list'+1),repmat(closing,m_test+1,1)]);
            cells=regexprep(total,'[^:()\w'']','');
            fprintf(fileID,'%s\r\n',cells{:});
            Ktime2=toc(Timer2);
            a=fclose(fileID);

            % Delete the test files
            delete('PRISM/test.sta','PRISM/test.tra');

        else
            Ktime1=0;Ktime2=0;m_test=1;
        end

        % Warn if the expected conversion time will be long
        Ctime=((Ktime1+Ktime2)/(m_test^2))*m^2;
        button='';
        if Ctime>30
            button = questdlg(['The creation of the PRISM file will take approximately ',...
                num2str(floor(Ctime/60)),' minutes and ',...
                num2str(mod(round(Ctime),60)),' seconds. Do you wish to continue?'],...
                'Derivation Time Warning!','No');
        end
        if strcmp(button,'No')
            a=0;
            return
        elseif strcmp(button,'Cancel')
            a=0;
            return
        end


        % Creation of the actual output
        % List of states
        listm=0:1:m; % PRISM states start at 0 (The m^th state is the non-safe state)
        listq=0:1:q-1; % PRISM states start at 0
        [listm2,listm1,listq1]=ndgrid(listm,listm,listq);
        total=[listm2(:) listq1(:) listm1(:) Tp(:)]';

        qm=msgbox('The .sta and .tra files are being generated.');
        % Transition file
        fileID = fopen('PRISM/PRISM.tra','w');
        fprintf(fileID,'%u %u %u\r\n',m,q*m,q*m^2);
        fprintf(fileID,'%1.0f %1.0f %1.0f %1.4e\r\n',total);
        fclose(fileID);

        % states file
        fileID = fopen('PRISM/PRISM.sta','w');
        fprintf(fileID,'(s)\r\n');
        fprintf(fileID,'%u:(%u)\r\n',[listm;listm+1]);
        a=fclose(fileID);


        close(qm);

    
    case 'GUI'


        % The text file
        fName = 'PRISM.prism';            
        fid = fopen('PRISM/PRISM.prism','w');  

        if fid == -1
            error('Matlab was not able to create the PRISM text file')
        end    

        % Opening text %MDP
        fprintf(fid,'//Transition probabilities\r\n\r\nmdp\r\n\r\nmodule M1\r\n\r\n');

        %%%%%%%%%% Main Body %%%%%%%%%%%%%%%%%%%%

        % Definition of the states
        fprintf(fid,'//Definition of the states\r\ns : [1..%u];\r\n\r\n',m+1);

        % Creation of one line for timing
        start=tic;
        h = waitbar(0,'Creation of 1 line of the .prism file');
        for j=1
            for i=1:m
                waitbar((i)/m,h);
                fprintf(fid,'[] s=%u -> ',i);
                fprintf(fid,'%1.4e : (s''=%u) + ',[Tp(i,1:end-1,j);1:m]);
                fprintf(fid,'%1.4e : (s''=%u);\r\n',Tp(i,m+1,j),m+1);
            end
            fprintf(fid,'\r\n');
        end
        close(h)
        Ktime=toc(start);

        % Warn if the expected conversion time will be long
        Ctime=Ktime*(q-1);
        button='';
        if Ctime>30
            button = questdlg(['The creation of the PRISM file will take approximately ',...
                num2str(floor(Ctime/60)),' minutes and ',...
                num2str(mod(round(Ctime),60)),' seconds. Do you wish to continue?'],...
                'Derivation Time Warning!','No');
        end
        if strcmp(button,'No')
            a=fclose(fid);
            return
        elseif strcmp(button,'Cancel')
            a=fclose(fid);
            return
        end

        % Contruction of the main part of the code
        h = waitbar(0,'Creation of the .prism file');
        for j=2:q
            waitbar(j/q,h);
            for i=1:m
                fprintf(fid,'[] s=%u -> ',i);
                fprintf(fid,'%1.4e : (s''=%u) + ',[Tp(i,1:end-1,j);1:m]);
                fprintf(fid,'%1.4e : (s''=%u);\r\n',Tp(i,m+1,j),m+1);
            end
            fprintf(fid,'\r\n');
        end
        close(h)
        % Add the final non-safe state
        fprintf(fid,'[] s=%u -> 1 : (s''=%u); // This represents the unsafe state\r\n',m+1,m+1);


        %%%%%%%%%% Main Body end %%%%%%%%%%%%%%%%         

        fprintf(fid,'\r\nendmodule\r\n\r\n');

        % close the file
        a=fclose(fid);

    
    otherwise
        error('No correct method was selected. The method can be either ''Normal'' or ''GUI''')
end

end % End of the function

