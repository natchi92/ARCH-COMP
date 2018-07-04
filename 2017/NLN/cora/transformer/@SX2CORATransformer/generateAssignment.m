function generateAssignment(obj, fileID, assignment, states)
strEquations = assignment.Text;
[equations,nEqn] = obj.handleEquations(strEquations);

eqn = [];
base = [];
for iEquation = 1:1:nEqn
    % Normalize the string containing the equation
    equation = strrep(equations{iEquation}, ':=', '==');
    equation = strrep(equation, '''', '');
    equation = strrep(equation, ' ', '');
    
    eqnChildren = children(sym(equation));
    
    eqn=[eqn eqnChildren(2)];
    base = [base eqnChildren(1)];
    
end

[A,b]=equationsToMatrix(eqn,sym(states(:)));
[Abase,~]=equationsToMatrix(base,sym(states(:)));

A = Abase' * A;
b = - Abase' * b;

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

fprintf(fileID, 'assignment.A = %s;\n',strA);
fprintf(fileID, 'assignment.b = %s;\n\n',strb);

end