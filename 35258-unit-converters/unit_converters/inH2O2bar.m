function [bar] = inH2O2bar(inH2O)
% Convert pressure from inches of water column at 4 degrees to bar
% Chad Greene 2012
bar = inH2O*0.00249089;