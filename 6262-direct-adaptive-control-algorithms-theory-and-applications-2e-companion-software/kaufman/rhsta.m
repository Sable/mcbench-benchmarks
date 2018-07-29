%rhsta simulates the examples of Sections 3.2.3 and 3.3.4	
%    ____________________________________________________________________
%  /Program:  rhsta.m													   \
% / Description:  This program runs the simulation of the Rhors example     \
%|  	found in sections 3.2.3 and 3.3.4 of the text.  The program allows	 |
%|  	the user to choose between the example of feedforward around 		 |
%|	plant or feedforward in both the plant and model.  The program 	     |
%|	prompts the user to enter values for the variables that are adjusted | 
%|	within the text.													 |
%|	This program requires the simulink diagram rhsim.m in order to run   |
% \ 		/
%  \_______________________________________________________________________/

 
%Copyright

% Programmed Summer 1996 by Kenyon Thayer, RPI, Troy, NY
	

a=exist('D');
if a==1
	D_old=D;
	tau_old=tau;
	Ti_old=Ti;
	Tp_old=Tp;
else
	D_old=0.1;
	tau_old=0.2;
	Ti_old=10;
	Tp_old=10;
end

disp('  **This programs simulates the text book examples 3.2.3 and 3.3.4.**');
disp('  ');
disp('Note: example 3.2.3 is feedforward in the plant only');
disp('      example 3.3.4 is feedforward in the plant and model');

str=input('Is this feedforward in both plant and model? Y/N: ','s');
if str=='Y' | str=='y'
	ff=1;
else
	ff=0;
end
% State space form of a Model
% **************************
num1=[3];den1=[1 3];
[Am,Bm,Cm,Dm]=tf2ss(num1,den1);

% Initial Conditions
% *************************************
Key0=0;
Kx0=0;
Ku0=0;
Ki0=[Key0 Kx0 Ku0];
xm0=0;

% State space form of a FF Compensator
% *************************************
D=input(sprintf('Enter a value for D (default value is %5.3f): ',D_old));
if isempty(D)
	D=D_old;
end

tau=input(sprintf('Enter a value for tau (default value is %5.3f): ',...
	tau_old));
if isempty(tau)
	tau=tau_old;
end

Ti=input(sprintf('Enter a value for Ti (default value is %d): ',...
	Ti_old));
if isempty(Ti)
	Ti=Ti_old;
end

Tp=input(sprintf('Enter a value for Tp (default value is %d): ',...
	Tp_old));
if isempty(Tp)
	Tp=Tp_old;
end

numc=D;
denc=[tau 1];
[Af,Bf,Cf,Df]=tf2ss(numc,denc);
xf0=[0];

% State space form of a Plant
%*****************************
a=30.0;
nump=[458];denp=[1 (a+1) (a+229) 229];
[Ap,Bp,Cp,Dp]=tf2ss(nump,denp);
xp0=[0 0 0]';

%************ Ti and Tp ************
Tie=Ti;Tix=Ti;Tiu=Ti;   
Tpe=Tp;Tpx=Tp;Tpu=Tp;

%*********************************************
%[t,x,y]=gear('rhsim',40);
[t,x,y]=rk45('rhsim',40,[],[1e-6,1e-2,1]);
%[t,x,y]=linsim('rhsim',10,[],[1e-5,1e-2,1-2]);

plot(t,y(:,1),'--',t,y(:,2))
axis([0 40 -.4 .4])
text(.41, 1.05, 'Ym', 'color', [1 0 1], 'FontSize', 12, 'Units', 'normal');
text(.51, 1.05, 'Yp', 'color', [1 1 0], 'FontSize', 12, 'Units', 'normal');
