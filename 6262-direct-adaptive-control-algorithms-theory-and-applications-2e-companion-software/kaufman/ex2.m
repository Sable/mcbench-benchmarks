%ex2 simulates the example of Section 3.4.3
%	_______________________________________________________________________
%  /Program:  ex2.m								\
% / Description:  This program runs the simulation of the Rhors example     \
%|  	found in sections 3.4.3 of the text.  The program allows the user	 |
%|  	to choose between the three algorithms defined in the text and 		 |
%|	between the stable or unstable examples.  The program prompts the    |
%|	prompts the user to enter values for the variables that are adjusted | 
%|	within the text.  This program calls and requires the fex2.m file.	 |
% \
%  \_______________________________________________________________________/

 
%Copyright

% Programmed Summer 1996 by Kenyon Thayer, RPI, Troy, NY
	
global am bm cm ap bp cp Af Bf Cf Df T Tbar G Qp Qf algor a b u

clear yp ym kpe kpf
temp=exist('Af');
if temp==1
	Af_old=Af;
	Bf_old=Bf;
	Cf_old=Cf;
	Df_old=Df;
	G_old=G;
	Qp_old=Qp;
	Qf_old=Qf;
else
	Af_old=0;
	Bf_old=-10;
	Cf_old=1;
	Df_old=0;
	G_old=-5.714;
	Qp_old=57.14;
	Qf_old=20;
end;

am=-3;bm=1;cm=3;

disp('   **This program simulates the text book example 3.4.3**');

algor=input('Which algorithm do you wish to model? 1,2,3: ');
ch2=input('Is this the stable example? Y/N: ','s');


if ch2=='n' | ch2=='N'
	%example 2 (unstable)
	ap=[-7 -92 100;1 0 0;0 1 0];bp=[1;0;0];cp=[0 0 200];
else
	%example 1 (rohrs)
	ap=[-31 -259 -229;1 0 0;0 1 0];bp=[1;0;0];cp=[0 0 458];
end;
% Initial Conditions
% ************************************************************
xp0=[0 0 0];xm0=0;yf0=0;ki0=[0 0 0 0];x0=[xp0,xm0,yf0,ki0]';
t0=0;tfinal=20;tol=1.e-6;
Af=input(sprintf('Enter a value for Af (default is %5.3f):  ',...
	Af_old));
if isempty(Af)
	Af=Af_old;
end	
Bf=input(sprintf('Enter a value for Bf (default is %5.3f):  ',...
	Bf_old));
if isempty(Bf)
	Bf=Bf_old;
end	
Cf=input(sprintf('Enter a value for Cf (default is %5.3f):  ',...
	Cf_old));
if isempty(Cf)
	Cf=Cf_old;
end	
Df=input(sprintf('Enter a value for Df (default is %5.3f):  ',...
	Df_old));
if isempty(Df)
	Df=Df_old;
end
G=input(sprintf('Enter a value for G (default is %5.3f):  ',...
	G_old));
if isempty(G)
	G=G_old;
end	
Qp=input(sprintf('Enter a value for Qp (default is %5.3f):  ',...
	Qp_old));
if isempty(Qp)
	Qp=Qp_old;
end	
Qf=input(sprintf('Enter a value for Qf (default is %5.3f):  ',...
	Qf_old));
if isempty(Qf)
	Qf=Qf_old;
end	

T=1;Tbar=1;

[tout,xout]=ode45('fex2',t0,tfinal,x0,tol,0);

for i=1:length(tout)
	yp(i)=cp*xout(i,[1:3])'; 
	ym(i)=cm*xout(i,4) ;
	yf=Cf*xout(i,5);
	eyp(i)=ym(i)-yp(i);
	xm=xout(i,4);
	um=0.3;
	if tout(i)>10
		um=-0.3;
	end;
	[ng,ng]=size(G);
	rvec=[eyp(i);-yf;xm;um];
	v1=Qp*eyp(i)-Qf*yf;
	up=inv(eye(ng)-G*rvec'*Tbar*rvec)*(xout(i,[6:9])+v1*rvec'*Tbar)*rvec;
	v=v1+G*up;
	kp=v*rvec'*Tbar;
	kpe(i)=kp(1,1);
	kpf(i)=kp(1,2);
end;

z=max(length(tout),length(ym(1,:)));
if z>length(tout)
	for i=length(tout):length(ym(1,:))
		tout(i,:)=tout((length(tout)),:);
	end;
end;
figure(1)
plot(tout,yp,tout,ym,'--')
axis([0 20 -.5 .5])
text(.41, 1.05, 'Ym', 'color', [1 0 1], 'FontSize', 12, 'Units', 'normal');
text(.51, 1.05, 'Yp', 'color', [1 1 0], 'FontSize', 12, 'Units', 'normal');
