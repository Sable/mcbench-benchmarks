%% Using RF Toolbox Smith Chart for Impedance Matching.
%  Copyright 2006-2013 The Mathworks, Inc.
%  Dick Benson
%  Topology:  Pi match    source-> shunt C -> series L ->shunt C -> load
   clear all; close all; clc;
   
   f     = 150e6;         % frequency
   Zl    = 250 + -j*100;  % given load
   Zin   = 50 +   j*10;   % desired input Z
   Zo    = 50;            % characteristic impedance of system
   Q     = 8;             % desired matching loaded Q

%% Normalize Impedances and compute reflection coefficients pl and pin
zl =  Zl/Zo;
pl = (zl-1)/(zl+1);
zin = Zin/Zo;
pin = (zin-1)/(zin+1);

%% Draw smith chart and mark normalized Zin and Zl (pin and pl)
[hls,hs]=smithchart;
set(gcf,'Name','Pi Match')
hold on
plot(real(pin), imag(pin),'o','MarkerSize',8,'markerfacecolor',[0 1  0]);
text(real(pin)+.05, imag(pin)+.05, 'z_{in}', 'FontSize', 12, 'FontUnits', 'normalized')
plot(real(pl), imag(pl),'o','MarkerSize',8,'markerfacecolor',[0 1  0]);
text(real(pl)+.05, imag(pl)+.05, 'z_{l}', 'FontSize', 12, 'FontUnits', 'normalized')

%% Plot Constant Q Contours 
%  keep X/R a constant
x = -5:.01:5;
z = Q*j*x + abs(x);
pcurveQ = (z-1)./(z+1);
hlQ     = plot(real(pcurveQ),imag(pcurveQ),'-','linewidth',2,'color',[1 0 0]);


%% Follow constant conductance curve from Zl by changing susceptance 
%  Parallel Cap adds susceptance
ydelta  = (0:0.1:3)*j;
y       = 1/zl + ydelta;
pcurveC = (1-y)./(y+1);
hl1=plot(real(pcurveC),imag(pcurveC),'-','linewidth',2);

%%   Find intersection with Q curve
[xint1,yint1]=curveintersect(hl1,hlQ);
h = plot(xint1,yint1,'o','color',[1 0 0]);
set(h,'markerfacecolor',[1 0 0]);
pint1 = xint1+j*yint1;
zint1 = (pint1+1)/(1-pint1);   % map reflection coefficient back to impedance

%% Add reactance from series L to follow constant resistance curve  
zdelta  = +(0:0.1:2)*j; 
z       = zint1+zdelta;
pcurveL = (z-1)./(z+1);
hl2=plot(real(pcurveL),imag(pcurveL),'-','linewidth',2,'color',[0 1 0]); % green

%% Work back from Zin adding suseptance due to shunt C along constant
% conductance curve
ydelta  = -(0:0.1:5)*j;
y       = 1/zin + ydelta;
pcurveC = (1-y)./(y+1);
hl3=plot(real(pcurveC),imag(pcurveC),'-','linewidth',2, 'color',[0 1 1]);

%% Find intersection of series inductance and suseptance
[xint2,yint2]=curveintersect(hl2,hl3);
h = plot(xint2,yint2,'o','color',[1 0 0]);
set(h,'markerfacecolor',[1 0 0]);
pint2 = xint2 + j*yint2;      % 
zint2 = (pint2+1)/(1-pint2);   % map reflection coefficient back to impedance

%% Determine the values for the shunt C (x2) and series L 
            
yC   =  imag(1/zin-1/zint2);  % compute how much susceptance had to change to get to intersection
Cin_pF = (yC*(1/Zo)/(2*pi*f))*1e12

zL   =  -imag(zint1-zint2);     % compute how much reactance had to change to get to intersection
L_nH = (Zo*zL)/(2*pi*f)*1e9

           % 
yC   = imag(1/zint1-1/zl);
Cl_pF = (yC*(1/Zo)/(2*pi*f))*1e12


%% Use RF toolbox functions for a sanity check on the matching network

fs=f;
hL = rfckt.seriesrlc('R',0,'L',1e-9*L_nH,'C',inf);
hCin = rfckt.shuntrlc('R',inf,'L',inf,'C',1e-12*Cin_pF);
hCl  = rfckt.shuntrlc('R',inf,'L',inf,'C',1e-12*Cl_pF);
hnl= rfckt.cascade('Ckts',{hCin,hL,hCl});
%                 Zl   Zs  Zo
analyze(hnl,fs,   Zl,  50, 50);     
h  =  smith(hnl,'GammaIn');
set(h,'Marker','o','markersize',8,'markerfacecolor',[0 0 1]);
legend([hl1,hl2,hl3],'Shunt Cl', 'Series L','Shunt Cin'); drawnow

