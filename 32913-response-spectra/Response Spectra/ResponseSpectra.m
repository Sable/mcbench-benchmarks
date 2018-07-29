% To plot the Response Spectra of given Seismic Input
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save if
% any data present before running the code !!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%-------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                |
%                   Senior Research Fellow                                |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
%          http://sites.google.com/site/kolukulasivasrinivas/             |
%-------------------------------------------------------------------------
%
clear ; clc ;
load EINS.dat ;  % load the Seismic data
t = EINS(:,1) ;  % time intervel
a = EINS(:,2) ;  % acceleration for respective time step
%--------------------------------------------------------------------------
% Plot the Accelerogram
%--------------------------------------------------------------------------
h = figure ;
set(h,'name','Accelerogram','numbertitle','off')
plot(t,a) ;
grid ;
title('EL centro Earthquake') ;
xlabel('time (Sec)') ;
ylabel('acceleration (g)') ;

a = a*9.8 ; % Changing Acceleration to m/s/s
%--------------------------------------------------------------------------
% Plot the Response of a SDOF system to the Seismic input
%--------------------------------------------------------------------------
xi = 2/100 ; % Relative damping
Tn = 5.;    % Natural period of SDOF system
y0 = [0;0] ; % Initial Conditions
% Response of SDOF System
[t,Y] = ode45(@odefun,t,y0,[],xi,Tn,t,a) ;
h = figure ;
set(h,'name','SDOF','numbertitle','off')
plot(t,Y(:,1)) ;
grid ;
title('Response of SDOF system to the Seismic Input') ;
ylabel('displacement (m)')
xlabel('time (s)')
axis tight ;
%--------------------------------------------------------------------------
% Plot the Response Spectra of the given Seismic Input
%--------------------------------------------------------------------------
disp('Please wait, it will take time to plot the response spectra ')
TnInitial = 0.01 ;
TnFinal = 10. ;
stepTn = 0.005 ;
Tn = TnInitial:stepTn:TnFinal ; % Natural periods of SDOF oscillator's
xi = 5/100 ;
y0 = [0;0] ;
Ymax = zeros(1,length(Tn)) ;
nsdof = 1 ;
for Tn = TnInitial:stepTn:TnFinal
    %Response of each SDOF system to the given Seismic Input
    [t,Y] = ode45(@odefun,t,y0,[],xi,Tn,t,a);  
    ymax = max(abs(Y(:,1))); % max. displacement
    Ymax(nsdof) = ymax;
    nsdof = nsdof+1 ;
end
Tn = TnInitial:stepTn:TnFinal ;
h = figure ;
set(h,'name','ResponseSpectrum','numbertitle','off')
plot(Tn,Ymax);
grid;
title('Displacement Response Spectrum of EL Centro Earthquake')
ylabel('displacement (m)')
xlabel('T (s)')
axis tight ;
%
% Plot Response Spectrum on loglog scale
h = figure ;
set(h,'name','Log ResponseSpectrum','numbertitle','off')
loglog(Tn,Ymax,'r');
grid;
title('Displacement Response Spectrum of EL Centro Earthquake')
ylabel('displacement (m)')
xlabel('T (s)')
axis tight ;
%--------------------------------------------------------------------------   
% Pseudo-velocity response spectrum
h = figure ;
set(h,'name','PseudoVelocity','numbertitle','off')
V = (2*pi./Tn).*Ymax;
plot(Tn,V);
grid;
title('PseudoVelocity Response Spectrum EL Centro Earthquake')
ylabel('PseudoVelocity (m/s)')
xlabel('T (s)')
axis tight ;
%
% Pseudo-velocity response spectrum on log scale
h = figure ;
set(h,'name','Log PseudoVelocity','numbertitle','off')
loglog(Tn,V,'r');
grid;
title('PseudoVelocity Response Spectrum of EL Centro Earthquake')
ylabel('PseudoVelocity (m/s)')
xlabel('T(s)')
axis tight ;

%--------------------------------------------------------------------------
% Pseudo-acceleration response spectrum
h = figure ;
set(h,'name','PseudoAcceleration','numbertitle','off')
A = (2*pi./Tn).*V;
plot(Tn,A);
grid;
title('PseudoAcceleration Response Spectrum of EL Centro Earthquake')
ylabel('PseudoAcceleration (m/s/s)')
xlabel('T (s)')
axis tight ;
%
% Pseudo-acceleration response spectrum on log scale
h = figure ;
set(h,'name','Log PseudoAcceleration','numbertitle','off')
loglog(Tn,A,'r');
grid;
title('PseudoAcceleration Response Spectrum of EL Centro Earthquake')
ylabel('Pseudo Acceleration (m/s/s)')
xlabel('T (s)')
axis tight ;    

%--------------------------------------------------------------------------
    
    
    
    
    
    