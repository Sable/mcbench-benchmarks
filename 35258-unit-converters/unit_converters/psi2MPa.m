function [MPa] = psi2MPa(psi)
% Convert units of pressure from pounds per square inch to megapascals. 
% Chad Greene 2012
MPa = psi*0.00689476;