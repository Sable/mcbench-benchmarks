% The following MATLAB script plots the Moody Chart
% using the iterative Colebrool-White friction factor. 
% The Colebrook-White correlation can be used for
% transitional and turbulent Reynolds numbers above 4000.
% The plot is generated between 4000 and 100.000.000.
% Called function: ffcw(RE, DH, ERH) (written by T.Balint)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

clear
% Set the Reynolds numbers
rn1=50;
rn2=50;
rn3=300;
rn=rn1+rn2+rn3;

Re1=linspace(400,2300,rn1);
Re2=linspace(2300,4000,rn2);
Re3=linspace(4000,100000000,rn3); 
Re=[Re1 Re2 Re3];

%Re=linspace(400,100000000,300); 

% Set the hydraulic diameter in meters.  This is arbitrary, since
% the Moody chart uses relative roughness, which is the ratio of the
% equivalent roughness and the hydraulic diameter
Dh=0.01;  

% Set the relative roughness values according to the ones 
% reported on the textbook Moody chart. The relative roughness
% is calculated as the ratio between the equivalent roughness
% and the hydraulic diameter
rr=[0.05 0.04 0.03 0.02 0.015 0.01 0.008 0.006 0.004 0.002 0.001 ...
      0.0008 0.0006 0.0004 0.0002 0.0001 0.00005 0.00001 0.000005 0.000001];

% Set the equivalent roughness height in m. (The function to
% calculate the Colebrook-White friction factor uses equivalent
% roughness height and diameter. The Moody Chart was reverse engineered.)
eqrough=rr.*Dh;

% Calculate the friction factors
for j=1:20    % set the outer loop size to the number of rel.roughness values
   for i=1:rn  %set the inner loop size to the number of Reynolds numbers
   fcw(i,j)=ffrough(Re(i), Dh, eqrough(j));
 end
end

% Plot the Moody Chart
figure(1);
h=get(0,'CurrentFigure');
set(h,'Name','MOODY CHART','NumberTitle','off');
orient landscape;
loglog(Re,fcw(:,1),Re,fcw(:,2),Re,fcw(:,3),Re,fcw(:,4),Re,fcw(:,5),Re,fcw(:,6),...
   Re,fcw(:,7),Re,fcw(:,8),Re,fcw(:,9),Re,fcw(:,10),Re,fcw(:,11),Re,fcw(:,12),...
   Re,fcw(:,13),Re,fcw(:,14),Re,fcw(:,15),Re,fcw(:,16),Re,fcw(:,17),Re,fcw(:,18),...
   Re,fcw(:,19),Re,fcw(:,20));
set(findobj('Type','line'),'Color','k','LineWidth',1.2);  %set all the lines black, and the line width to 1.2 from 0.5 (default)
grid on;
axis ([400 10^8 0.008 0.1]);
set(gca,'ytick',[0.008 0.009 0.01 0.015 0.02 0.025 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1]);
xlabel('{\bf Reynolds number} {\it ( Re={UD_h}/\nu )}');
ylabel('{\bf Friction factor} {\it ( f_{cw} )}');
title ('{\bf MOODY CHART}','FontSize',13);
text(2.5*10^8,0.018,'{\bf Relative roughness} {\it ( \epsilon / D_h )}','FontSize',8,'Rotation',90);
text(1.05*10^8,0.072,'\it0.05','FontSize',7);
text(1.05*10^8,0.065,'\it0.04','FontSize',7);
text(1.05*10^8,0.056,'\it0.03','FontSize',7);
text(1.05*10^8,0.048,'\it0.02','FontSize',7);
text(1.05*10^8,0.044,'\it0.015','FontSize',7);
text(1.05*10^8,0.038,'\it0.01','FontSize',7);
text(1.05*10^8,0.035,'\it0.008','FontSize',7);
text(1.05*10^8,0.032,'\it0.006','FontSize',7);
text(1.05*10^8,0.028,'\it0.004','FontSize',7);
text(1.05*10^8,0.0232,'\it0.002','FontSize',7);
text(1.05*10^8,0.0196,'\it0.001','FontSize',7);
text(1.05*10^8,0.0186,'\it0.0008','FontSize',7);
text(1.05*10^8,0.0174,'\it0.0006','FontSize',7);
text(1.05*10^8,0.016,'\it0.0004','FontSize',7);
text(1.05*10^8,0.0138,'\it0.0002','FontSize',7);
text(1.05*10^8,0.012,'\it0.0001','FontSize',7);
text(1.05*10^8,0.0106,'\it0.00005','FontSize',7);
text(1.05*10^8,0.0083,'\it0.00001','FontSize',7);
text(1.5*10^7,0.0083,'\it0.000005','FontSize',7);
text(5*10^6,0.0083,'\it0.000001','FontSize',7);
text(5000,0.0125,'{\it To be used for laminar, transitional and}','FontSize',8);
text(5000,0.0115,'{\it turbulent flows, for the full range of Reynolds numbers}','FontSize',8);
text(1.1*10^5,0.0175,'{\it  Smooth pipes}','FontSize',7,'Rotation',-36);
text(10^7,0.006,'MATLAB script by Tibor Balint, March 1998','FontSize',6);
% ----------------- end of the script ------------------------------------
