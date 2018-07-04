function generateInvariant(obj, fileID, invariant, paramTypeStruct)

    states = paramTypeStruct{3};

%GENERATEINVARIANT generates the code implementing an invariant
strEquations = invariant.Text;
[equations,nEqn] = obj.handleEquations(strEquations);

supEqnMember = [];
infEqnMember = [];
for iEquation = 1:1:nEqn
    % Normalize the string containing the equation
    equation = strrep(equations{iEquation}, ':=', '==');
    equation = strrep(equation, '''', '');
    equation = strrep(equation, ' ', '');
    
    % sym oders the inequation in the forme member1 <= member2
    eqnChildren = children(sym(equation));
    
    %infEqnMember is the member of the inequation on the lower
    %side
    infEqnMember = [infEqnMember eqnChildren(1)];
    %supEqnMember is the member of the inequation on the higher
    %side
    supEqnMember=[supEqnMember eqnChildren(2)];
end

%equationsToMatrix transform equation to matrix form Ax<=b by
%returning matrices A and b.
[AInf,bInf]=equationsToMatrix(infEqnMember,sym(states(:)));
[ASup,bSup]=equationsToMatrix(supEqnMember,sym(states(:)));

% The previous results form the inequation Ainf x + binf
A = AInf - ASup;
b = bInf - bSup;

% print the assignment
strA = char(A);
strb = char(b);

if(~isempty(strfind(strA,'matrix')))
    strA([1:8, end-1:end]) = [];
end
if(~isempty(strfind(strb,'matrix')))
    strb([1:8, end-1:end]) = [];
end
% Remove useless space
strA = strrep(strA, ' ', '');
strb = strrep(strb, ' ', '');
% Replace ',' between the '][' by ';'
strA = strrep(strA, '],[', ';');
strb = strrep(strb, '],[', ';');

fprintf(fileID, 'A = %s;\n',strA);
fprintf(fileID, 'b = %s;\n',strb);
fprintf(fileID, 'inv = mptPolytope(A,b);\n\n');
end