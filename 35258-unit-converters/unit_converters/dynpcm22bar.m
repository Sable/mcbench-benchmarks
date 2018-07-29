function [bar] = dynpcm22bar(dynpcm2)
% Convert pressure from dynes per square centimeter to bar
% Chad Greene 2012
bar = dynpcm2*0.00000100000;