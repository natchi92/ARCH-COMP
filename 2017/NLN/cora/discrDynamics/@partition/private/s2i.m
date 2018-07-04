function index=s2i(Obj,subscriptVectors)
% Purpose:  convert segment subscripts into segment number
% Pre:      1st Parameter - partition object
%           2nd Parameter - subscript vectors 
% Post:     Return segment numbers
% Tested:   14.09.06,MA
% Updated:  27.01.09,MA


for iVector=1:length(subscriptVectors(:,1))
    %outside is true, if subscripts lie outside of the quantized state space
    outside=(subscriptVectors(iVector,:)<1) | (subscriptVectors(iVector,:)>Obj.nrOfSegments');
    
    if ~any(outside)

        %check if there is only a single dimension
        if length(Obj.nrOfSegments)==1
            index(iVector)=subscriptVectors(iVector);
        %check if there are only two dimensions
        elseif length(Obj.nrOfSegments)==2
            index(iVector)=sub2ind(Obj.nrOfSegments,subscriptVectors(iVector,1),...
                subscriptVectors(iVector,2));
        else

            %Generate string from subscript vector
            string=[];
            for iChar=1:length(subscriptVectors(1,:))
                string=[string,',',num2str(subscriptVectors(iVector,iChar))];
            end
            %Generate command string
            command=['ind=sub2ind([',num2str(Obj.nrOfSegments'),']',string,');'];

            %eval
            try
                eval(command);
            catch
                %index is in outside area or partition is one-dimensional
                disp('error in s2i');
                ind=subscriptVectors(iVector,1);
            end
            index(iVector)=ind;
        end

    else
        index(iVector)=0; %the outside segment is numbered 0
    end
end
