function generateTransition(obj, fileID, transition, paramTypeStruct)

states = paramTypeStruct{3};

if(isfield(transition, 'assignment'))
    obj.generateAssignment(fileID, transition.assignment{1}, states);
else% TO DO : dimension may change
    nVariables=length(states);
    fprintf(fileID,'assignment.A=eye(%d);\n',nVariables);
    fprintf(fileID,'assignment.b=zeros(%d,1);\n\n',nVariables);
end

if(isfield(transition, 'guard'))
    obj.generateGuard(fileID, transition.guard{1}, states);
else% TO DO : dimension may change
    %                 fprintf(fileID,'A=[];\n');
    %                 fprintf(fileID,'b=[];\n');
    %                 fprintf(fileID,'guard=mptPolytope(A,b);\n\n');
    fprintf(fileID,'guard=[];\n\n');
end
% Generate transition

source = transition.Attributes.source;
target = transition.Attributes.target;

if(isfield(transition, 'label'))
    label = ['''' transition.label{1}.Text ''''];
else
    label = ['''' 'noLabel' ''''];
end

fprintf(fileID, 'trans{%s}= [ trans{%s}, {transition(guard,assignment,%s,%s,%s)}];\n\n',source, source, target, label, label);

end