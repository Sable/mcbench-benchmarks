% File rtdskewmca.m
% MCA of RTD circuit with normal and skewed input; 
% File: c:\Mfiles\bookupdate\rtdskewmca.m
% uses MATLAB function G2a.m
% Improved version 11/08/06
% Aligned histograms with Gaussian ideal curves
%
clc;clear;tic;format short g
R1=4.53;R2=34.8;R3=132;R4=9.09;R5=9.09;E1=5;
R6=4.53;R7=27.4;R8=20;R9=20;RT=1.915;
Nom=[R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1];
disp('Nominal output');
Vo=G2a(Nom)
%
% "Real world" tolerances
%
Tinit=0.001;Tlife=0.002;ppm=1e-6;
TC1=50*ppm;TC2=25*ppm;
Thi=Tinit+Tlife+35*TC1;Tlo=-Tinit-Tlife-80*TC1;
Trhi=8.1*1e-4;Trlo=-Trhi;Trefhi=0.02+35*TC2;
Treflo=-0.02-80*TC2;
%
p=1:9;T(1,p)=Tlo;T(2,p)=Thi;
T(1,10)=Trlo;T(1,11)=Treflo;
T(2,10)=Trhi;T(2,11)=Trefhi;
%
Nc=size(T,2); % Number of components
%
Nk=10000; % <<<<<<<<<<<<<<<<<<<<<<< Nk
%
nb=20; % Number of bins in histograms
Ng=50; % Number of points in ideal Gaussian curve
randn('state',sum(100*clock)); % Normal RNG seed
Vn=zeros(Nk,1);Vu=zeros(Nk,1);
RN=randn(Nk,Nc); % normal distribution
%
% This routine is slow but is necessary for creation of skewed input
%
for k=1:Nk
   for p=1:Nc
      RS(k,p)=3.3*(rand^3+randn/8)-7/8; % skewed distribution
   end
end
%
for k=1:Nk
   Rn(k,:)=Nom.*(((T(2,:)-T(1,:))/6).*(RN(k,:)+3)+T(1,:)+1);
   Rz(k,:)=Nom.*(((T(2,:)-T(1,:))/6).*(RS(k,:)+3)+T(1,:)+1);
   Vn(k)=G2a(Rn(k,:));Vu(k)=G2a(Rz(k,:));
end
%
% h1 is OUTPUT (Vn) with normal dist input
%
Vs1=std(Vn);Vavg1=mean(Vn);
h1=hist(Vn,nb)/Nk;VL=min(Vn);VH=max(Vn);
intv=(VH-VL)/nb;
q=1:nb;bin1(q)=VL+intv*(q-1)+intv/2;
% Ideal Gaussian curve
intvn=(VH-VL)/Ng;
c1=intv/(Vs1*sqrt(2*pi));
for q=1:Ng
   x1(q)=intvn*(q-1)+VL;
   y1(q)=c1*exp((-(x1(q)-Vavg1)^2/(2*Vs1^2)));
end
%
% Get histograms from only one row (1) of RN(Nc,Nk) array
% h2 is INPUT normal dist
h2=hist(RN(:,1),nb)/Nk;VL=min(RN(:,1));VH=max(RN(:,1));
intv=(VH-VL)/nb;
q=1:nb;bin2(q)=VL+intv*(q-1)+intv/2;
Vsr=sprintf('%2.3f\n',Vs1);
Vavgr=sprintf('%2.3f\n',Vavg1);
% Ideal Gaussian curve
intvn=(VH-VL)/Ng;
c2=intv/(1*sqrt(2*pi));
for q=1:Ng
   x2(q)=intvn*(q-1)+VL;
   y2(q)=c2*exp((-(x2(q))^2/2));
end
%   
% h3 is OUTPUT (Vu) with skewed input
Vs2=std(Vu);Vavg2=mean(Vu);
h3=hist(Vu,nb)/Nk;VL=min(Vu);VH=max(Vu);
intv=(VH-VL)/nb;
q=1:nb;bin3(q)=VL+intv*(q-1)+intv/2;
% Ideal Gaussian curve
intvn=(VH-VL)/Ng;
c3=intv/(Vs2*sqrt(2*pi));
for q=1:Ng
   x3(q)=intvn*(q-1)+VL;
   y3(q)=c2*exp((-(x3(q)-Vavg2)^2/(2*Vs2^2)));
end
%
% Get histograms from only one row (1) of RS(Nk,Nk) array
% h4 is INPUT skewed dist
%
h4=hist(RS(:,1),nb)/Nk;VL=min(RS(:,1));VH=max(RS(:,1));
intv=(VH-VL)/nb;
q=1:nb;bin4(q)=VL+intv*(q-1)+intv/2;
% Ideal Gaussian curve
intvn=(VH-VL)/Ng;
c4=intv/(1*sqrt(2*pi));
for q=1:Ng
   x4(q)=intvn*(q-1)+VL-intvn/1;
   y4(q)=c4*exp((-(x4(q))^2/2));
end
Vsu=sprintf('%2.3f\n',Vs2);
Vavgu=sprintf('%2.3f\n',Vavg2);
%
%
subplot(2,2,1)
bar(bin2,h2,1,'y');
set(gca,'FontSize',8);
hold on
h=plot(x2,y2,'k');
grid off;hold off
title('Normal dist input');
%axis auto
axis([-4 4 0 0.2]);
%
subplot(2,2,2)
bar(bin4,h4,1,'y');
hold on
set(gca,'FontSize',8);
h=plot(x4,y4,'k');
hold off
grid off;
title('Skewed dist input');
%axis auto
axis([-4 4 0 0.2]);
%
subplot(2,2,3)
bar(bin1,h1,1,'y');
set(gca,'FontSize',8);
hold on
h=plot(x1,y1,'k');
title('RTD Output, Normal dist');
xlabel('Volts DC');
grid off;hold off
%axis auto
axis([3.9 4.7 0 0.2]);
XT=linspace(3.9,4.7,5);
set(gca,'xtick',XT);
text(3.95,0.15,['Vavg=',Vavgr],'FontSize',8);
text (3.95,0.1,['Vs=',Vsr],'FontSize',8);
%
subplot(2,2,4)
bar(bin3,h3,1,'y');
set(gca,'FontSize',8);
hold on
h=plot(x3,y3,'k');
title('RTD Output, Skewed dist');
xlabel('Volts DC');
grid off;hold off
%axis auto
axis([3.9 4.7 0 0.2]);
XT=linspace(3.9,4.7,5);
set(gca,'xtick',XT);
text(3.95,0.15,['Vavg=',Vavgu],'FontSize',8);
text (3.95,0.1,['Vs=',Vsu],'FontSize',8)
figure(1)
ET=toc
