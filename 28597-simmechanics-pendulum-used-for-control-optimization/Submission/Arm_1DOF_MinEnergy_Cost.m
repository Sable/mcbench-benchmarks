function [a,b]=SimMechanics1Cos(x)
a=0;%x.nodes(end);
b=sum(x.controls.^2,1);
