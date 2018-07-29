function [X,Y,Z] = cylinderWeights(r1,r2) 
%CYLINDERWEIGHTS creates the innermost blue bars with heavy looking cylinders 
%representing attatched weights.
t=0:0.01:1;
x=t;

for i=1:numel(t)
    if ((i>10 && i<20) || (i>80 && i<90))
        x(i)=r2;
    else
        x(i)=r1;
    end
end
[X,Y,Z]=cylinder(x,30);
