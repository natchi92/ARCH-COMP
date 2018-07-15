function [a] = Matlab2MRMC(Tp)
%MATLAB2MRMC converts a transition kernel to one or
% multiple files that can be imported by the MRMC model checker.
%   [a] = Matlab2MRMC(Tp)



% Cardinality
m=size(Tp,1);

% Create a subfolder for the PRISM files
if exist([cd,'\MRMC']) ~= 7
    mkdir('MRMC');
end

% Adjust Tp for the transition to the "non Safe" Set
Tp=[Tp,1-sum(Tp,2)];


%%% The creation of the output files %%%


% Make a small file for timing purposes (if m is bigger than 50)
if m>50 
    m_test=min(max(30,round(m/10)),200); % Number of lines to write

    % List of states
    list=1:1:m_test+1; % MRMC states start at 1 (The (m+1)^th state is the non-safe state)
    [list2,list1]=ndgrid(list,list(1:end-1));
    Tp_aux=Tp(1:m_test,1:m_test+1)';
    total=[list1(:) list2(:) Tp_aux(:)]';

    q=msgbox('The .tra files are being generated.');
    % Transition file
    fileID = fopen('MRMC/test.tra','w');
    start1=tic;
    fprintf(fileID,'STATES %u\r\nTRANSITIONS %u\r\n',m_test+1,(m_test+1)*m_test+1);
    fprintf(fileID,'%1.0f %1.0f %1.4e\r\n',total);
    fprintf(fileID,'%1.0f %1.0f 1\r\n',m_test+1,m_test+1);
    Ktime1=toc(start1);
    fclose(fileID);
    close(q)
    
    % Delete the test files
    delete('MRMC/test.tra');
   
else
    Ktime1=0;Ktime2=0;m_test=1;
end

% Warn if the expected conversion time will be long
Ctime=((Ktime1)/(m_test^2))*m^2;
button='';
if Ctime>5
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
list=1:1:m+1; % MRMC states start at 1 (The (m+1)^th state is the non-safe state)
[list2,list1]=ndgrid(list,list(1:end-1));
Tp_aux=Tp';
total=[list1(:) list2(:) Tp_aux(:)]';

q=msgbox('The .tra files are being generated.');
% Transition file
fileID = fopen('MRMC/MRMC.tra','w');
fprintf(fileID,'STATES %u\r\nTRANSITIONS %u\r\n',m+1,(m+1)*m+1);
fprintf(fileID,'%1.0f %1.0f %1.4e\r\n',total);
fprintf(fileID,'%1.0f %1.0f 1\r\n',m+1,m+1);
fclose(fileID);


close(q);

a=0;


end % End of the function

