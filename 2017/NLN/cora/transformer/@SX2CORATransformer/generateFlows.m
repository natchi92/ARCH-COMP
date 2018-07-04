function generateFlows(obj, fileID, flow, paramTypeStruct)
%GENERATEFLOWS generates the dynamic flow of a location
states = paramTypeStruct{3};
inputs = paramTypeStruct{4};

strEquations = flow.Text;
[equations,nEqn] = obj.handleEquations(strEquations);

eqn = [];
base = [];
for iEquation = 1:1:nEqn
    % Normalize the string containing the equation
    equation = strrep(equations{iEquation}, ':=', '==');
    equation = strrep(equation, '''', '');
    equation = strrep(equation, ' ', '');
    
    eqnChildren = children(sym(equation));
    
    %base is the left member of the equation : for a flow it is
    %the new value of state variables
    base = [base eqnChildren(1)];
    %eqn is the right member of the equation : for a flow it is
    %the dynamic system of the form Ax+b (check, maybe the form
    %should be Ax+Bu+b0 with u non-deterministic variables.
    eqn=[eqn eqnChildren(2)];
end

%equationsToMatrix transform equation to matrix form Ax+b=0 by
%returning matrices A and b.
% sym order the name of the variables !!!
[A,b0]=equationsToMatrix(eqn,sym(states(:)));
[Abase,~]=equationsToMatrix(base,sym(states(:)));

% Equations might be in an order different of the one used for
% the state vector. For the base, the form is A*x+0 = 0. A is
% orthogonal and is a base transformation matrix. So to get the
% matrices in the correct base : (to check...)
A = Abase' * A ;
b0 = - Abase' * b0;

% Few equations might be undefined. We have to complete the
% matrix A to implement the missing equations as x = x.
for iRow = 1:1:size(A,1)
    % TO DO : find a way to complete the A matrix correctly...
    % in case of omitted equations...
    if(isequaln(A(iRow,:),zeros(1,size(A,2))) && isequaln(b0(iRow),0));
        A(iRow,iRow) = 1;
    end
end

%%% non deterministic inputs : to correct once we know how to
%%% distinguish input and state variables (controlled or uncontrolled
%%% variables)
[resA,resb]=equationsToMatrix(b0,sym(inputs(:)));

B = [resA , -resb];

% B = eye(size(A,1));

% print the flow
% Transform the symbolic
strA = char(A);
strb0 = char(b0);
strB = char(B);

% Extract from the string a matlab representation of a matrix
% that can be usable
if(~isempty(strfind(strA,'matrix')))
    strA([1:8, end-1:end]) = [];
end
if(~isempty(strfind(strB,'matrix')))
    strB([1:8, end-1:end]) = [];
end
if(~isempty(strfind(strb0,'matrix')))
    strb0([1:8, end-1:end]) = [];
end
% Remove useless spaces
strA = strrep(strA, ' ', '');
strB = strrep(strB, ' ', '');
strb0 = strrep(strb0, ' ', '');
% Replace '],[' by ';'
strA = strrep(strA, '],[', ';');
strB = strrep(strB, '],[', ';');
strb0 = strrep(strb0, '],[', ';');
% Finally print the matlab way to write matrix for A and b and
% print the call to the constructor of a flow
fprintf(fileID, 'A = %s;\n',strA);
fprintf(fileID, 'B = %s;\n',strB);
fprintf(fileID, 'flow=linearSys(''linearSys'',A,B);\n\n');
end