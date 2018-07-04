function [equations,nEqn] =handleEquations(obj, charEquation)
%XMLINVARIANT creates a structure conataining seperated equations.
% Equations could be of invariants, flow, guards, assignments

%Input: char_eqn:  equation in character format
%Output: equations: structure containing seperated equations
%        nEqn:    number of seperated equations
%
% Last edit : 8/8/2015

% Compute the number of equation contained in the char_eqn
% Equations are separated by the char &

nEqn = sum(charEquation == '&') + 1;

equations = strsplit(charEquation, '&');

end