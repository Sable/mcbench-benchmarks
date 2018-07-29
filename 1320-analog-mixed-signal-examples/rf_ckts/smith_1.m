%% Using RF Toolbox Smith Chart for Impedance Matching.
% Copyright 2006-2013 The Mathworks, Inc.
% Dick Benson
%  Topology:  L match   source -> series L ->shunt C -> load
   clear all; close all; clc
   f     = 145e6;
   Zl    = 150 + j*100; % given load
   Zin   = 50 +  j*20;  % desired input Z
   Zo    = 50;          % characteristic impedance of system

%% Normalize Impedances and compute reflection coefficients pl and pin
zl =  Zl/Zo;
pl = (zl-1)/(zl+1);
zin = Zin/Zo;
pin = (zin-1)/(zin+1);

%% Draw smith chart and mark normalized Zin and Zl (pin and pl)
[hls,hs]=smithchart;
set(gcf,'Name','L Match')
hold on
plot(real(pin), imag(pin),'o','MarkerSize',8,'markerfacecolor',[0 1  0]);
text(real(pin)+.05, imag(pin)+.05, 'z_{in}', 'FontSize', 12, 'FontUnits', 'normalized')
plot(real(pl), imag(pl),'o','MarkerSize',8,'markerfacecolor',[0 1  0]);
text(real(pl)+.05, imag(pl)+.05, 'z_{l}', 'FontSize', 12, 'FontUnits', 'normalized')

%% Follow constant conductance curve from Zl by changing only susceptance 
%  Parallel Cap adds susceptance
% 
ydelta  = (0:0.01:2)*j;
y       = 1/zl + ydelta;
pcurveC = (1-y)./(y+1);
hl1=plot(real(pcurveC),imag(pcurveC),'-','linewidth',2);

%% Follow constant resistance curve from Zin by changing reactance
%  Working backwards (negative sign) from Zin adding inductance 
zdelta  = -(0:0.01:9)*j; 
z       = zin+zdelta;
pcurveL = (z-1)./(z+1);
hl2=plot(real(pcurveL),imag(pcurveL),'-','linewidth',2, 'color', [0 1 0]);

%% Find intersection of two curves
%  Uses curveintersect function by Sebastian Holz on MATLAB Central
[xint,yint]=curveintersect(hl1,hl2);
h = plot(xint,yint,'o','color',[1 0 0]);
set(h,'markerfacecolor',[1 0 0]);
pint = xint + j*yint;      % 
zint = (pint+1)/(1-pint);   % map reflection coefficient back to impedance


%% Determine the value for the shunt C and series L 
yint = 1/zint;      % intersection point in admittance 
yC   =  imag(yint - 1/zl);  % compute how much susceptance had to change to get to intersection
C_pF = (yC*(1/Zo)/(2*pi*f))*1e12
zL   =  -imag(zint-zin);     % compute how much reactance had to change to get to intersection
L_nH = (Zo*zL)/(2*pi*f)*1e9

%% Use RF toolbox functions for a sanity check on the matching network
% The goal is to provide Zin ohm input Z when driving a load of Zl
fs=f;
hL = rfckt.seriesrlc('R',0,'L',1e-9*L_nH,'C',inf);
hC = rfckt.shuntrlc('R',inf,'L',inf,'C',1e-12*C_pF);
hnl= rfckt.cascade('Ckts',{hL,hC});
%                 Zl   Zs    Zo
analyze(hnl,fs,   Zl,  50,   50);     
h  =  smith(hnl,'GammaIn');
set(h,'Marker','o','markersize',8,'markerfacecolor',[0 0 1]);
legend([hl1,hl2],'Shunt C', 'Series L')

