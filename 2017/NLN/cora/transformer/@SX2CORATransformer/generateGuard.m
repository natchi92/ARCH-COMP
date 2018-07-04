function generateGuard(obj, fileID, guard, states)
strEquations = guard.Text;
[equations,nEqn] = obj.handleEquations(strEquations);

supEqnMember = [];
infEqnMember = [];
for iEquation = 1:1:nEqn
    % Normalize the string containing the equation
    equation = strrep(equations{iEquation}, ':=', '==');
    equation = strrep(equation, '''', '');
    equation = strrep(equation, ' ', '');
    
    eqnChildren = children(sym(equation));
    
    infEqnMember = [infEqnMember eqnChildren(1)];
    supEqnMember=[supEqnMember eqnChildren(2)];
    
end
[AInf,bInf]=equationsToMatrix(infEqnMember,sym(states(:)));
[ASup,bSup]=equationsToMatrix(supEqnMember,sym(states(:)));

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
fprintf(fileID, 'guard = mptPolytope(A,b);\n\n');
end