function freesmd_sim(t,x)
%Animation function for a horizontal spring/mass/damper
%Written by T. Nordenholz, Fall 05
%To use, type free_sim(t,x) where t and x are the time (sec) and
%displacement (m) arrays 
%Geometrical and plotting parameters can be set within this program

% set geometric parameters 
W=.05; %width of mass
H=.1; %height of mass
L0=.2;%unstretched spring length
Wsd=.5*H; %spring width
xrect=[-W/2,-W/2,W/2,W/2,-W/2]; % plotting coordinates of mass
yrect=[0,H,H,0,0];

%set up and initialize plots
%x vs t plot
Hf=figure('Units','normalized','Position',[.1,.1,.8,.8]);
Ha_f2a1=subplot(2,1,1);
Hls_f2plot1=plot(t(1),x(1));axis([0,t(end),-L0,L0]),grid on,...
   xlabel('t (sec)'),ylabel('x (m)') 

% animation plot
Ha_f2a2=subplot(2,1,2);
% create mass
Hp_f2rect=fill(xrect+x(1),yrect,'b');axis([-L0,L0,-H,2*H]),grid on
Hl_cm=line(x(1),H/2,'Marker','O','MarkerSize',8,'MarkerFaceColor','k');
% create spring/damper 
Hgt_springdamp=hgtransform;
Hl_Lend=line([0,.1],[0,0],'Color','k','Parent',Hgt_springdamp);
Hl_Rend=line([.9,1],[0,0],'Color','k','Parent',Hgt_springdamp);
Hl_Lbar=line([.1,.1],Wsd*[-1,1],'Color','k','Parent',Hgt_springdamp);
Hl_Rbar=line([.9,.9],Wsd*[-1,1],'Color','k','Parent',Hgt_springdamp);
Hl_spring=line(linspace(.1,.9,9),Wsd*[1,2,1,0,1,2,1,0,1],'Color','k','Parent',Hgt_springdamp);
Hl_dampL=line([.1,.4],Wsd*[-1,-1],'Color','k','Parent',Hgt_springdamp);
Hl_dampLpist=line([.4,.4],Wsd*[-1.3,-.7],'Color','k','Parent',Hgt_springdamp);
Hl_dampR=line([.6,.9],Wsd*[-1,-1],'Color','k','Parent',Hgt_springdamp);
Hl_dampRcyl=line([.55,.6,.6,.55],Wsd*[-.5,-.5,-1.5,-1.5],'Color','k','Parent',Hgt_springdamp);
% set initial length
L=L0+x(1)-W/2;
set(Hgt_springdamp,'Matrix',[L,0,0,-L0;0,1,0,H/2;0,0,1,0;0,0,0,1]);
text(0,1.5*H,'|-> x');
% draw and hold for 1 second
drawnow
tic;while toc<1,end
tic

% Animate by looping through time and x arrays 
% and redrawing at each value
for n=1:length(t)
   L=L0+x(n)-W/2;   
   set(Hls_f2plot1,'XData',t(1:n),'YData',x(1:n));
   set(Hp_f2rect,'XData',xrect+x(n));
   set(Hl_cm,'XData',x(n));
   set(Hgt_springdamp,'Matrix',[L,0,0,-L0;0,1,0,H/2;0,0,1,0;0,0,0,1]);
   while toc<t(n),end;
   drawnow;   
end