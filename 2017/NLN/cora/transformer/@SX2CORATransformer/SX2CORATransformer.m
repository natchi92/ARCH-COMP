classdef SX2CORATransformer
    %SX2CORATRANSFORMER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        %% CONSTRUCTOR
        function obj = SX2CORATransformer()
        end
        
        %% GENERATE
        mFilename = generate(obj, xmlFilename)
        
        %% XML2STRUCT
        xmlStruct = xml2struct(obj, xmlFilename)
        
        %% GENERATEMAIN
        mFilename = generateMainFunction(obj, xmlFilename, xmlStruct)
        
        %% FINDROOT
        root = findRoot(obj,xmlStruct)
        
        %% REGISTERCOMPONENTS
        componentRegister = registerComponents(obj, xmlStruct)
        
        %% GENERATESYSTEM
        generateSystem(obj, fileID, xmlStruct, rootComponents)
        
        %% FINDINCOMPONENTREGISTER
        component = findInComponentRegister(obj, xmlStruct, componentRegister, componentName)
        
        %% GENERATECOMPONENT
        generateComponent(obj,component)
        
        %% GETPARAMTYPE
        [sVariables, sConstants] = getParamType(obj,component)
        
        %% GENERATE BIND
        generateBind(obj,fileID, bind, constantsList)
        
        %% GENERATE LOCATION
        generateLocation(obj, fileID, location, variables)
        
        %% GENERATE FLOWS
        generateFlows(obj, fileID, flow, variables)
        
        %% GENERATE INVARIANT
        generateInvariant(obj, fileID, invariant, variables)
        
        %% GENERATE GUARD
        generateGuard(obj, fileID, guard, variables)
        
        %% GENERATE ASSIGNMENT
        generateAssignment(obj, fileID, assignment, variables)
        
        %% GENERATE TRANSITION
        generateTransition(obj, fileID, transition, variables)
        
        %% HANDLE EQUATION
        [equations,nEqn] =handleEquations(obj, charEquation)
    end
    
end

