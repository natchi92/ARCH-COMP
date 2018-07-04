function [Asquare] = exactSquareOld(A)
% exactSquare - computes the exact square of an interval matrix 
%
% Syntax:  
%    [Asquare] = exactSquare(A)
%
% Inputs:
%    A - interval matrix 
%
% Outputs:
%    Asquare - resulting interval matrix
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 

% Author: Matthias Althoff
% Written: 04-January-2009 
% Last update: ---
% Last revision: ---

%------------- BEGIN CODE --------------

%obtain dimension
dim=length(A);

%compute result for diagonal and non-diagonal elements
for i=1:dim
    for j=1:dim
        %diagonal elements
        if i==j
            Asquare(i,j)=A(i,j)^2;
            for k=1:dim
                if k~=i
                    Asquare(i,j)=Asquare(i,j)+A(i,k)*A(k,j);
                end
            end
        %non-diagonal elements
        else
            Asquare(i,j)=A(i,j)*(A(i,i)+A(j,j));
            for k=1:dim
                if (k~=i) & (k~=j)
                    Asquare(i,j)=Asquare(i,j)+A(i,k)*A(k,j);
                end
            end            
        end
    end
end

%------------- END OF CODE --------------