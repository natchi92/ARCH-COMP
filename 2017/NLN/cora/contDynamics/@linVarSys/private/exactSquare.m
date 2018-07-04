function [sq] = exactSquare(A)
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

%initialize
sq=0*A;
E=eye(dim); %identity matrix

%get diagonal elements of A (diagA)
for i=1:dim
    diagA(i,i)=A(i,i);
end

%compute result for diagonal and non-diagonal elements
%compute elements of H, Hu and sq
for i=1:dim
    %i neq j
    %auxiliary value s
    s=sum(A,i);
    %auxiliary value b
    b=A(i,:); b(i)=0;
    %auxiliary matrix C
    C=E*A(i,i)+diagA;
    %compute non-diagonal elements of sq
    sq(i,:)=b*C+s;
    
    %i=j
    %compute diagonal elements of sq
    sq(i,i)=sq(i,i)+A(i,i)^2;            
end

%sum function:
%s=0.5 \sum_{k:k\neq i,k\neq j} a_{ik}a_{kj}t^2
function s=sum(A,i)

% for k=1:length(A)
%     A(k,k)=0;
% end

%get indices that should be 0
n=length(A);
k=0:n;
ind=k*n+1:n+1:n^2;
A(ind)=zeros(n,1);

s=A(i,:)*A;

%------------- END OF CODE --------------