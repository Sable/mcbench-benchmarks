% File c:\M_files\shortcuts\rtdbimod.m
% mca of rtd circuit using pre-screened (bi-modal) inputs; 
% uses MATLAB function G2a.m
% Revised and updated 3/10/04
% Since this is a DC circuit, SS arrays A,B,D,E are not used.
clc;clear
% Component values
R1=4.53;R2=34.8;R3=132;R4=9.09;R5=9.09;E1=5;
R6=4.53;R7=27.4;R8=20;R9=20;RT=1.915;
Nom=[R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1];
Vo=G2a(Nom);
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
Nk=10000; % Number of Monte Carlo samples
%
Nc=length(Nom); % Number of components
nb=30; % Number of bins in histograms
Ng=50; % Number of point in ideal Gaussian curve  
randn('state',sum(100*clock)); % randomize normal RNG seed
Yn=zeros(Nk,Nc);sp=0.5; % sp is 1/2 of gap width
Rn=zeros(Nk,Nc);
% Get tolerance constants independent of samples k
p=1:Nc;tr1=(T(2,:)-T(1,:))/6;tr2=T(1,:)+1;
%
for w=1:Nc
	k=0;
	while k < Nk
		z=randn;
		if (z<-sp)|(z>sp) % accept only rv's outside of -sp to +sp gap
			k=k+1; % next rv
			Yn(k,w)=z; % store in Yn array
		end
	end
end
for k=1:Nk
   Rn(k,:)=Nom.*(tr1.*(Yn(k,:)+3)+tr2);
   Vm(k)=G2a(Rn(k,:));
end
%
% get Nc input histograms
%
for p=1:Nc
	Vav(p)=mean(Yn(:,p));
	Vsd(p)=3*std(Yn(:,p));
	hin(p,:)=hist(Yn(:,p),nb)/Nk;
	VL1(p)=min(Yn(:,p));VH1(p)=max(Yn(:,p));
	intv1(p)=(VH1(p)-VL1(p))/nb;
	q=1:nb;bin1(p,q)=VL1(p)+intv1(p)*(q-1);
end
%
% get output histogram
%
Vs=std(Vm);Vavg=mean(Vm);
hout=hist(Vm,nb)/Nk;VL2=min(Vm);VH2=max(Vm);
intv2=(VH2-VL2)/nb;
q=1:nb;bin2(q)=VL2+intv2*(q-1);
% Ideal Gaussian curve
intvn2=(VH2-VL2)/Ng;
c1=intv2/(Vs*sqrt(2*pi));
for q=1:Ng
   x1(q)=intvn2*(q-1)+VL2;
   y1(q)=c1*exp((-(x1(q)-Vavg)^2/(2*Vs^2)));
end
%
Vhi2=Vavg+Vs;Vlo2=Vavg-Vs;
Vsr=sprintf('%2.3f\n',3*Vs);Vavgr=sprintf('%2.3f\n',Vavg);
%
subplot(2,1,1)
set(gca,'FontSize',8);
bar(bin1(1,:),hin(1,:),1,'y');
%stairs(bin1(1,:),hin(1,:),'k');
%hold on
%stairs(bin1(2,:),hin(2,:),'b');stairs(bin1(3,:),hin(3,:),'g');
%stairs(bin1(4,:),hin(4,:),'k');stairs(bin1(5,:),hin(5,:),'k');
%stairs(bin1(6,:),hin(6,:),'k');stairs(bin1(7,:),hin(7,:),'k');
%stairs(bin1(8,:),hin(8,:),'k');hold off;
%title('8 of 11 Pre-screened inputs');
title('1 of 11 Pre-screened inputs');
grid off
xlabel('Sigma');
axis([-4 4 0 0.2]);
%
subplot(2,1,2)
bar(bin2,hout,1,'y');
set(gca,'FontSize',[8]);
hold on
h=plot(x1-intv2/2,y1,'k');
hold off
title('RTD output');xlabel('Volts dc')
xlabel('Volts DC');
axis([4.0 4.6 0 0.15]);
text(4.1,0.1,['Vavg=',Vavgr],'FontSize',8); 
text(4.1,0.08,['3s=',Vsr],'FontSize',8);
text(4.1,0.06,['Nk = ',num2str(Nk)],'FontSize',8);
%
figure(1)


