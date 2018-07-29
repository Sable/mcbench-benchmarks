% the following script calculates and plots
% the skin friction factors for smooth pipes for
% laminar, turbulent and transitonal flows
% for Reynnolds number up to 100000
%  CALLED FUNCTION: ffsmooth
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

clear
format long g;                  % set the format of the calculations
n=2000; %number of points to be plotted

RE=linspace(600,100000,n);

for i=1:n
   ffsm(i)=ffsmooth(RE(i)); %calculate the friction factors
end

figure(1)
h=get(0,'CurrentFigure');
set(h,'Name','Friction Factor for Smooth Pipes','NumberTitle','off');
orient landscape;
loglog(RE,ffsm)
%plot(RE,ffsm)
set(findobj('Type','line'),'Color','k','LineWidth',1.2);  %set all the lines black, and the line width to 1.2 from 0.5 (default)
grid on;
axis ([600 10^5 0.015 0.1]);
%axis tight;
xlabel('{\bf Reynolds number} {\it ( Re={UD_h}/\nu )}');
ylabel('{\bfFriction factor} {\it f}');
title ('{\bf FRICTION FACTOR FOR SMOOTH PIPES}','FontSize',13);
set(gca,'ytick',[0.015 0.02 0.025 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1]);
text(1.05*10^7,0.032,'\it0.006','FontSize',7);
text(1000,0.0205,'{\it To be used for laminar, transitional and turbulent flows,}','FontSize',8);
text(1000,0.0195,'{\it  in smooth pipes at Reynolds numbers below 100000}','FontSize',8);
text(0.99*10^3,0.06,'{\it Laminar flow}','FontSize',8,'Rotation',-62);
text(1.05*10^4,0.0295,'{\it Turbulent flow}','FontSize',8,'Rotation',-28);
text(2400,0.031,'{\it Flow Transition}','FontSize',8,'Rotation',50);
text(4*10^4,0.013,'MATLAB script by Tibor Balint, April 1998','FontSize',6);
return
% -------------- end of the script ----------------------
