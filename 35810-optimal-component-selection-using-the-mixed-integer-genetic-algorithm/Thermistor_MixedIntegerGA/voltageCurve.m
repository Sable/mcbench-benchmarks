function Vdata = voltageCurve(Tdata,x,Res,ThVal,ThBeta)
%% Calculate Voltage Curve given Indices (x)
% Copyright (c) 2012, MathWorks, Inc.
%% Index into Resistor and Thermistor arrays to extract component values
y(1) = Res(x(1));
y(2) = Res(x(2));
y(3) = Res(x(3));
y(4) = Res(x(4));
y(5) = ThVal(x(5));
y(6) = ThBeta(x(5));
y(7) = ThVal(x(6));
y(8) = ThBeta(x(6));

%% Calculate temperature curve for a particular set of components
Vdata = tempCompCurve(y, Tdata);