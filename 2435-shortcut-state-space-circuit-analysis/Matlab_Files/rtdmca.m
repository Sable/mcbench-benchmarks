% File: c:\M_files\short_updates\rtdskewmca.m
% MCA of rtd circuit with normal and skewed input; 
% uses circuit function G2a.m
% updated 11/19/06
clc;clear;tic;
R1=4.53;R2=34.8;R3=132;R4=9.09;R5=9.09;E1=5;
R6=4.53;R7=27.4;R8=20;R9=20;RT=1.915;
Nom=[R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1];
Nc=length(Nom);
disp('Nominal output');
disp(' ');
Vo=G2a(Nom);
disp(Vo);
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
T(1,10)=Trlo;T(2,10)=Trhi;T(1,11)=Treflo;T(2,11)=Trefhi;
%
Nk=5000; % <<<<<<<<<<<<<<<<<<<<< Nk
%
nb=30; % Number of bins in histograms
Ng=50; % Number of points in ideal Gaussian curve
randn('state',sum(100*clock)); % Normal RNG seed
rand('state',sum(100*clock)); % Uniform RNG seed
Vn=zeros(Nk,1);Vu=zeros(Nk,1);
RN=randn(Nk,Nc); % random array (Normal) 
RU=rand(Nk,Nc); % random array (Uniform)
%
% Get tolerance constants independent of samples k
p=1:Nc;tu1=T(2,:)-T(1,:);tu2=T(1,:)+1;
tn1=tu1/6;
%
for k=1:Nk
%
   Ru(k,:)=Nom.*(tu1.*RU(k,:)+tu2);
   Rn(k,:)=Nom.*(tn1.*(RN(k,:)+3)+tu2);
%      
   Vn(k)=G2a(Rn(k,:));
   Vu(k)=G2a(Ru(k,:));
end
%
Vs1=std(Vn);Vavg1=mean(Vn);
h1=hist(Vn,nb)/Nk;VL1=min(Vn);VH1=max(Vn);
intv1=(VH1-VL1)/nb;
q=1:nb;bin1(q)=VL1+intv1*(q-1);
% h1 is OUTPUT (Vn) with normal dist input
% Ideal Gaussian curve
intvn1=(VH1-VL1)/Ng;
c1=intv1/(Vs1*sqrt(2*pi));
for q=1:Ng
   x1(q)=intvn1*(q-1)+VL1;
   y1(q)=c1*exp((-(x1(q)-Vavg1)^2/(2*Vs1^2)));
end
%
% Get histograms from only one row (1) of RN(Nc,Nk) array
%
h2=hist(RN(:,1),nb)/Nk; % h2 is INPUT normal dist
VL2=min(RN(:,1));VH2=max(RN(:,1));
intv2=(VH2-VL2)/nb;
q=1:nb;bin2(q)=VL2+intv2*(q-1);
Vsr=sprintf('%2.3f\n',3*Vs1);
Vavgr=sprintf('%2.3f\n',Vavg1);
% Ideal Gaussian curve
intvn2=(VH2-VL2)/Ng;
c2=intv2/(1*sqrt(2*pi));
for q=1:Ng
   x2(q)=intvn2*(q-1)+VL2;
   y2(q)=c2*exp((-(x2(q)-0)^2/(2*1)));
end
%
Vs2=std(Vu);Vavg2=mean(Vu);
h3=hist(Vu,nb)/Nk; % h3 is OUTPUT (Vu) with uniform input
VL3=min(Vu);VH3=max(Vu);
intv3=(VH3-VL3)/nb;
q=1:nb;bin3(q)=VL3+intv3*(q-1);
% Ideal Gaussian curve
intvn3=(VH3-VL3)/Ng;
c3=intv3/(Vs2*sqrt(2*pi));
for q=1:Ng
   x3(q)=intvn3*(q-1)+VL3;
   y3(q)=c2*exp((-(x3(q)-Vavg2)^2/(2*Vs2^2)));
end
%
% Get histograms from only one row (1) of RS(Nc,Nk) array
%
h4=hist(RU(:,1),nb)/Nk;
VL4=min(RU(:,1));VH4=max(RU(:,1));
%VL4=0;VH4=1;
intv4=(VH4-VL4)/nb;
q=1:nb;bin4(q)=VL4+intv4*(q-1);
% Ideal Gaussian curve
intvn4=(VH4-VL4)/Ng;
c4=intv4/(1*sqrt(2*pi));
for q=1:Ng
   x4(q)=intvn4*(q-1)+VL4;
   y4(q)=c4*exp((-(x4(q)-0)^2/(2*1)));
end
%
Vsu=sprintf('%2.3f\n',3*Vs2);
Vavgu=sprintf('%2.3f\n',Vavg2);
% h4 is INPUT uniform dist
% 
% Plots
%
subplot(2,2,1)
h=bar(bin2,h2,1,'y');
set(h,'LineWidth',1);
hold on
h=plot(x2-intv2/2,y2,'k');
set(h,'LineWidth',1);
set(gca,'FontSize',8);
grid off;hold off
title('Normal dist input','FontSize',8);
axis([-3 3 0 0.2]);
xlabel('Sigma');
XT=linspace(-3,3,7);
set(gca,'xtick',XT);
text(-2.7,0.15,['Nk = ',num2str(Nk)],'FontSize',8);
%
subplot(2,2,2)
h=bar(bin4,h4,1,'y');
%hold on
set(h,'LineWidth',1);
%h=plot(x4-intv4/2,y4,'k');
set(h,'LineWidth',1);
set(gca,'FontSize',8);
%hold off;
grid off;xlabel('Unif Dist');
title('Uniform dist input','FontSize',8);
axis([0 1 0 0.1]);
%
subplot(2,2,3)
h=bar(bin1,h1,1,'y');
hold on
set(h,'LineWidth',1);
h=plot(x1-intv1/2,y1,'k');
set(h,'LineWidth',1);
title('RTD Output, Normal dist','FontSize',8);
grid off;hold off
xlabel('Volts dc');
%axis auto
axis([3.9 4.7 0 0.2]);
XT=linspace(3.9,4.7,5);
set(gca,'FontSize',8);
set(gca,'xtick',XT);
text(4.02,0.15,['Vavg = ',Vavgr],'FontSize',8);
text (4.02,0.13,['3s = ',Vsr],'FontSize',8);
%
subplot(2,2,4)
h=bar(bin3,h3,1,'y');
set(h,'LineWidth',1);
hold on
h=plot(x3-intv3/2,y3,'k');
set(h,'LineWidth',1);
title('RTD Output, Uniform dist','FontSize',8);
grid off;hold off
set(gca,'FontSize',8);
%axis auto
axis([3.9 4.7 0 0.2]);
xlabel('Volts dc');
XT=linspace(3.9,4.7,5);
set(gca,'xtick',XT);
text(4.02,0.15,['Vavg = ',Vavgu],'FontSize',8);
text (4.02,0.13,['3s = ',Vsu],'FontSize',8)
%
figure(1)
ET=toc

