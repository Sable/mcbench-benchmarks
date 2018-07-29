function [ Xupper,Yupper,Zupper,Xlower,Ylower,Zlower ] = ...
    createOuterBars( radius )
%CREATEOUTERBARS Creates the red motionless supporting bar

[Xupper,Yupper,Zupper] = cylinder(radius);
Zupper=Zupper.*5;
Zupper=Zupper+5.9;
[Xlower,Ylower,Zlower] = cylinder(radius);
Zlower=Zlower.*5;
Zlower=Zlower-10.9;
