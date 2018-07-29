function Closed_Logarithmic_Nyquist(sys,n)

% Closed_Logarithmic_Nyquist makes a polar plot of the open loop transfer  
% function sys: the amplitude M=|sys| is converted in a logarithmic scale 
% and the diagram is entirely contained in a circle.
% 
% The amplitude M is transformed by the following function: 
%         _
%        |   M^(log10(n))       if M < 1  
% L_n(M)=|
%        |_  2-M^(-log10(n))    if M > 1    
%         
% The best base n of the transformation in our opinion is n=2
% 
% September 2013
% Roberto Zanasi, Federica Grossi
% Department of Engineering "Enzo Ferrari", 
% University of Modena and Reggio Emilia, 
% Modena, ITALY. 
%
% May be distributed freely for non-commercial use, 
% but please leave the above info unchanged, for
% credit and feedback purposes.
%
% ***********************************************
% System examples for copying and pasting on the
% MATLAB command line:
% -------------------
% s=tf('s');
% sys=1/(s+1);
% sys=1/(s*(s+1));
% sys=1/(s^2*(s+1));
% sys=200*(1+3*s)*(1+2*s)/(s*(1+50*s)*(1+10*s)*(1+0.5*s)*(1+0.1*s));
% sys=20*(s/10+1)/(s*(s/3+1)*(s/2+1));
% sys=1/(s^5*(s+1));

if nargin<2; n=2; end  % Base of the Ln function
%%%%%%%%%
Lw=0.8;         % Linewidth
Nd=4;           % Number of level lines
NgPlot=1;       % Negative Plot=1 complete Nyquist plot, 0 only positive frequency 
clear XD
XD.c='r'; XD.Lw=Lw; XD.NgPlot=NgPlot; XD.gs=sys;


%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
plot(2*exp(1i*(0:0.01:1)*2*pi),'-')
hold on
grid on
plot(exp(1i*(0:0.01:1)*2*pi),'-')
plot(exp(1i*pi),'*r')
text(-1.05,-0.05,'-1')
xx=1*exp(1i*pi/4);
text(real(xx),imag(xx),[num2str(0) 'dB'])
for ii=1:Nd
    plot(1/(n^ii)*exp(1i*(0:0.01:1)*2*pi),':')
    plot((2-1/(n^ii))*exp(1i*(0:0.01:1)*2*pi),':')
    if ii<3
        xx=1/(n^ii)*exp(1i*pi/4);
        text(real(xx),imag(xx),[num2str(-ii*20) 'dB'])
        xx=(2-n^(-ii))*exp(1i*pi/4);
        text(real(xx),imag(xx),[num2str(ii*20) 'dB'])
    end
end
for ii=1:12 % plot of sectors of pi/6
    ps=2*exp(1i*ii*pi/6);
    plot([0 real(ps)],[0 imag(ps)],':')
end
plot([-1 1]*3,[-1 1]*0,':')
plot([-1 1]*0,[-1 1]*3,':')
axis equal
axis([-1 1 -1 1]*2.2)
% 
% plot([-1 1]*3,[-1 1]*0,':')
% text(2.4,-0.05,'Real')
% plot([-1 1]*0,[-1 1]*3,':')
% text(-0.2,2.4,'Imag')
% axis equal
% axis([-2.5 2.5 -2.5 2.5])
%
[RE,IM,W] = nyquist(XD.gs,logspace(-Nd,Nd,1000));
NY=(RE(:,:)+1i*IM(:,:));
%%%%%%%%%%%%%%%%%%%%%
NY_L2=CLN(NY,n);
plot(NY_L2,XD.c,'LineWidth',Lw)
% Arrows
pp=[150 480 600 800 ];
for jj=pp % arrows for w>0
    arrowc(real(NY_L2(jj)),imag(NY_L2(jj)),real(NY_L2(jj+1)),imag(NY_L2(jj+1)),0.1,0.1,'r')
end
if XD.NgPlot==1    % plot for w<0 and complete
    Complete_Ny(NY_L2,XD);
    plot(conj(NY_L2),'Color',XD.c,'Linewidth',XD.Lw,'Linestyle','--')
pp=[150 480 600];
for jj=pp % arrows for w<0
    arrowc(real(conj(NY_L2(jj))),imag(conj(NY_L2(jj))),real(conj(NY_L2(jj-1))),imag(conj(NY_L2(jj-1))),0.1,0.1,'r')
end
end
grid on
title('Closed Logarithmic Nyquist Plot')
xlabel('real')
ylabel('imag')


%**************************************************************************
function h=Complete_Ny(NY,X)
Np_origin=length(find(pole(X.gs)==0)); % Number of poles at the origin
vv=(angle(conj(NY(1))):-0.02:angle(conj(NY(1)))-Np_origin*pi);
delta_spiral=0.003*(Np_origin>2);
if X.NgPlot
    xx=abs(NY(1))*(1-delta_spiral*vv).*exp(1i*vv);
    plot(xx,'Color',X.c,'Linewidth',X.Lw,'Linestyle','--')
    plot([real(xx(end)) real(NY(1))],[imag(xx(end)) imag(NY(1))],'Color',X.c,'Linewidth',X.Lw,'Linestyle','-')
    Nr_arrow=2*Np_origin; % Number of arrows     
    if Nr_arrow>0
    for jj=[1:Nr_arrow]
        pp=jj*round(size(xx,2)/(Nr_arrow+1));
        arrowc(real(xx(pp)),imag(xx(pp)),real(xx(pp+1)),imag(xx(pp+1)),0.1,0.1,'r')
    end
    end
end
h=xx;
return 

%**************************************************************************
function f = arrowc(x0,y0,x,y,rx,ry,c)
% Plots an arrow at (x,y) along vector dx=x-x0, dy=y-y0. The length of the arrow 
% is rx and ry in the directions x and y. The arrow color is c.
Lw=0.8;         % Linewidth
dx=(x-x0)/rx;
dy=(y-y0)/ry;
dxy=sqrt(dx^2+dy^2);
fx=-dx/dxy;
fy=-dy/dxy;
rotpiu=[rx,0;0,ry]*[cos(pi/6), -sin(pi/6); sin(pi/6), cos(pi/6) ]*[fx,fy]';
rotmeno=[rx,0;0,ry]*[cos(pi/6), sin(pi/6); -sin(pi/6), cos(pi/6) ]*[fx,fy]';
plot([x0,x],[y0,y],'-')
plot([x,x+rotpiu(1)],[y,y+rotpiu(2)],c,'LineWidth',Lw)
plot([x,x+rotmeno(1)],[y,y+rotmeno(2)],c,'LineWidth',Lw)
return

%**************************************************************************
function Ln=CLN(NY,n) 
RE=real(NY);
IM=imag(NY);
MD=sqrt(RE.^2+IM.^2);   % Modulo
PH=atan2(IM,RE);        % Fase
MD2=MD.^(log10(n));     

ind=find(MD2>1);
MD2(ind)=2-1./MD2(ind);

Ln=MD2.*exp(1i*PH);
return