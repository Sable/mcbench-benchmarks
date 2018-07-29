function [ Xbar1,Ybar1,Zbar1,Xbar2,Ybar2,Zbar2 ] = ...
    createInnerBars( bar1R1,bar1R2,bar2R1,bar2R2)
%CREATEINNERBARS Creates the bars of the inner (blue) ring
%
%   bar[i]R[j]: There are two bars which are perpendicular to each other.
%   They are melted with the inner ring, so the ring together with the bars
%   form the inner part of the top. 
%   R1 always describes the radius of the bar itself. Additionally, both
%   bars have two attatched weigths each. Both of the attatched weigths are
%   cylinders of R2.

[Zbar1,Ybar1,Xbar1]=cylinderWeights(bar1R1,bar1R2);
Xbar1=Xbar1-0.5;
Xbar1=Xbar1*10;
[Xbar2,Ybar2,Zbar2]=cylinderWeights(bar2R1,bar2R2);
Zbar2=Zbar2-0.5;
Zbar2=Zbar2*10;