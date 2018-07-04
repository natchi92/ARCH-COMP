function [P] = enclosingPolytope(varargin)
% enclosingPolytope - Converts a zonotope to a polytope representation
%
% Syntax:  
%    [P] = enclosingPolytope(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    P - polytope object
%
% Example: 
%    Z=zonotope(rand(2,5));
%    P=polytope(Z);
%    plot(P);
%    hold on
%    plot(Z);
%
% Other m-files required: vertices, polytope
% Subfunctions: none
% MAT-files required: none
%
% See also: intervalhull,  vertices

% Author:       Matthias Althoff
% Written:      18-September-2007
% Last update:  26-August-2010
%               20-October-2010
%               25-July-2016 (intervalhull replaced by interval)
%               05-April-2017
% Last revision:---

%------------- BEGIN CODE --------------

if nargin==1
     Z=varargin{1};
     W{1}=eye(length(Z.Z(:,1)));
     filterLength=[];
     options.polytopeType = 'mpt';
elseif nargin==2
     Z=varargin{1};
     options=varargin{2};
     
     
     %filter length
     if isfield(options,'filterLength')
        filterLength=options.filterLength;
     else
         dim=length(Z.Z(:,1));
         filterLength(1)=dim+2;
         filterLength(2)=dim+3;
     end
     
     %flag for tight conversion
     if isfield(options,'tightPolytopeConversion');
        tightConversion=options.tightPolytopeConversion;
     else
         tightConversion=1;
     end
end


%use simple reduction
if isempty(filterLength)
     Zred=zonotope(interval(Z));
     P=parallelotope(Zred, options);
     
%filter length is specified     
else
     if tightConversion
         %solution1 (axis-aligned):
         Zred=zonotope(interval(Z));
         P=parallelotope(Zred, options); 
         %solution 2 (method C):
         Zred=reduce(Z,'methC',1,filterLength);
         Zred = repair(Zred,Z);
         Padd = parallelotope(Zred, options);
         %intersect results
         P=P&Padd;
     else
         %solution 1 (method C):
         Zred1 = reduce(Z,'methC',1,filterLength);
         Zred1 = repair(Zred1,Z);
         vol1 = volume(Zred1);
         %solution2 (axis-aligned):
         Zred2 = zonotope(interval(Z));
         Zred2 = repair(Zred2,Z);
         vol2 = volume(Zred2);

         if vol1<vol2
            P=parallelotope(Zred1, options);
         else
            P=parallelotope(Zred2, options);
         end
     end
end

%repair zonotope if there is no length in one dimenion
function Zrep = repair(Z,Zorig)

%get length of each dimension
len = 2*rad(interval(Z));

%find zero lengths
index = find(len==0);

if ~isempty(index)
    %construct zonotope to be added
    origLen = 2*rad(interval(Zorig));
    origCenter = mid(interval(Zorig));
    
    %get Zmatrix
    Zmat = get(Z,'Z');
    
    for i=1:length(index)
        
        ind = index(i);
        %replace center
        Zmat(ind,1) = origCenter(ind);
        %replace generator value
        Zmat(ind,ind+1) = 0.5*origLen(ind);
    end

    %instantiate zonotopes
    Zrep = zonotope(Zmat);
else
    Zrep = Z;
end


%------------- END OF CODE --------------