function subscriptMatrix=i2s(Obj,indexVector)
% Purpose:  convert segment number into segment subscripts
% Pre:      1st Parameter - partition object
%           2nd Parameter - row vector of cell indices; 
% Post:     Return segment subscripts
% Tested:   14.09.06,MA
% Comment:  currently not in use

%obtain vector of number of segments for each dimension
siz=Obj.nrOfSegments';

%check if there is only a single dimension
if length(Obj.nrOfSegments)==1
    subscriptMatrix=indexVector;
%check if there are only two dimensions
elseif length(Obj.nrOfSegments)==2
    [subscriptMatrix(:,1),subscriptMatrix(:,2)]=ind2sub(Obj.nrOfSegments,indexVector');
else

    %subscript variable string
    string=[];
    for iChar=1:length(siz)
        string=[string,'s',num2str(iChar),','];
    end
    string(end)=[];
    %Generate command string
    command=['[',string,']=ind2sub([',num2str(siz),'],[',num2str(indexVector),']);'];
    %eval
    eval(command);

    %arrange variables in a vector
    string=strrep(string,',',';');
    command=['subscriptMatrix=[',string,']'';'];
    %eval
    eval(command);
end