function val = get(obj, propName)
% get - Retrieve object data from obj
%
% Syntax:  
%    val = get(obj, propName)
%
% Properties:
%    intervals - intervals of interval hull object

% Author:       Matthias Althoff
% Written:      12-February-2012
% Last update: 	02-June-2012
%               29-Octber-2015
%               27-July-2016
% Last revision:---

%------------- BEGIN CODE --------------

switch propName 
    case 'equations'
        try %MPT V3
            K = obj.P.b;
        catch %MPT V2
            [H,K] = double(obj.P);
        end
        val = length(K);
    case 'P'
        val = obj.P;
    case 'H'
        try %MPT V3
            val = obj.P.A;
        catch %MPT V2
            [val,K] = double(obj.P);
        end
    case 'K'
        try %MPT V3
            val = obj.P.b;
        catch %MPT V2
            [H,val] = double(obj.P);
        end
    otherwise
        error([propName,' is not a valid asset property'])
end

%------------- END OF CODE --------------