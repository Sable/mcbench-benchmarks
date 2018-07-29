function [t,z,cptim]=runchain
% See Article 8.9 of the text
% ~~~~~~~~~~~~~~~~~~~~
%      DYNAMIC SIMULATION OF AN ELASTIC CHAIN
% This program simulates the dynamics of an elastic
% chain modeled by a series of mass particles joined
% by elastic springs. The outer springs at each end
% are connected to foundations moving on circular 
% paths at constant speed. The system is released from
% rest in a horizontal position. Forces on the system
% include gravity, linear viscous drag, and foundation
% motion. If the last spring in the chain is assigned
% zero stiffness, then the last particle is freed from
% the foundation and a swinging chain with the upper
% end  shaken is analyzed. The principal variables for
% the problem are listed below. Different data choices
% can be made by changing function chaindata.
%
% tlim    - vector of time values at which the 
%           solution is computed 
% m       - vector of mass values for the particles
% k       - vector of stiffness values for springs
%           connecting the particles. If the last 
%           spring constant is set to zero, then the
%           right end constraint is removed
% L       - vector of unstretched spring lengths
% zend    - complex position coordinate of the outer 
%           end of the last spring (assuming the outer
%           end of the first spring is held at z=0)
% zinit   - vector of complex initial displacement 
%           values for each mass particle. Initial 
%           velocity values are zero.
% fext    - vector of constant complex force components
%           applied to the individual masses
% c       - vector of damping coefficients specifying
%           drag on each particle linearly proportional
%           to the particle velocity
% tolrel  - relative error tolerance for function ode45
% tolabs  - absolute error tolerance for function ode45
% t       - vector of times returned by ode45
% z       - matrix of complex position and velocity 
%           values returned by ode45. A typical row 
%           z(j,:) gives the system position and 
%           velocity for time t(j). The first half of 
%           the row contains complex position values 
%           and the last half contains velocity values
% omega   - frequency at which the ends of the chain 
%           are shaken
% yend    - amplitude of the vertical motion of the 
%           chain ends. If this is set to zero then 
%           the chain ends do not move 
% endmo   - the function defining the end motion of
%           the chain
% spreqmof - the function defining the equation of 
%            motion to be integrated using ode45
%
% User m functions called:  chaindata, spreqmof,
%                           endmo, plotmotn
%----------------------------------------------

global zend omega Rend; close
  
%fprintf('\nDYNAMICS OF A FALLING ELASTIC CHAIN\n\n')
%disp('Give a file name to define the data. Try')
%datname=input('chaindata as an example > ? ','s');
datname='chaindata';
eval(['[n,tmax,nt,fixorfree,rend,omega,cdamp]=',...
        datname,';']);

% The following data values are scaled in terms of
% the parameters returned by the data input function

% Time vector for solution output  
tmin=0; tlim=linspace(tmin,tmax,nt)'; 

% Number of masses, gravity constant, mass vector    
g=32.2; len0=1; mas=1/g; m=mas*ones(n,1);

% Spring lengths and spring constants
L=len0*ones(n+1,1); ksp=5*mas*g*(n+1)/(2*len0);    
k=ksp*ones(n+1,1); 

% If the far end of the chain is free, then the
% last spring constant is set equal to zero
 k(n+1)=fixorfree*k(n+1); 

% Viscous damping coefficients
c=cdamp*sqrt(mas*ksp)/40*ones(n,1);   

% Chain end position and initial position of 
% each mass. Parameters concerning the end 
% positions are passed as global variables.
% global zend omega Rend
zend=len0*(n+1); zinit=cumsum(L(1:n)); 
Rend=rend*zend; 

% Function name giving end position of the chain
re=@endmo;

% Gravity forces and integration tolerance
fext=-i*g*m; tolrel=1e-6;  tolabs=1e-8; 

% Initial conditions for the ode45 integrator
n=length(m); r0=[zinit;zeros(n,1)];

% Integrate equations of motion
options = odeset('reltol',tolrel,'abstol',tolabs);
%fprintf('\nPlease Wait While the Equations\n')
%fprintf('of Motion Are Being Integrated\n')
% pause(1), tic;

[t,r]=ode45(@spreqmof,tlim,r0,options,...
                        m,k,L,re,fext,c);

%cptim=toc; cpt=num2str(fix(10*cptim)/10);
%fprintf(...
%['\nComputation time was ',cpt,' seconds\n'])

% Extract displacement history and add 
% end positions
R=endmo(t); z=[R(:,1),r(:,1:n)];
if k(n+1)~=0, z=[z,R(:,2)]; end
X=real(z); Y=imag(z); 

% Show animation or motion trace of the response.
% disp('Press [Enter] to continue'), pause 
disp(' ')
%disp('The  motion can be animated or a trace')
%disp('can be shown for successive positions')
%disp(['between t = ',num2str(tmin),...
%      ' and t = ',num2str(tmax)])
titl=['ELASTIC CHAIN MOTION FOR ',...
     '[cdamp,omega] = [',num2str(cdamp),' , ',...
num2str(omega),' ]  and T = '];

% Plot the position for different times limits
%while 1
%  disp(' '), disp(...
%  ['Choose a plot option (1 <=> animate, ',...
%   ' 2 <=> trace,'])
%  opt=input('3 <=> stop)  > ? ');
%  if opt==3, break, end
%  disp(' '), disp(...
%  'Give a time vector such as 0:.1:15')
%  Tp=input('Time vector > ? ','s'); 
%  if isempty(Tp), break, end
%  tp=eval(Tp); tp=tp(:); T=[titl,Tp];
%  xp=interp1q(t,X,tp); yp=interp1q(t,Y,tp);
%  if opt ==1, plotmotn(xp,yp,T)
%  else, plotmotn(xp,yp,T,1), end
% end

Tp='0:.12:1.92'; T=[titl,Tp]; tp=eval(Tp)';
xp=interp1q(t,X,tp); yp=interp1q(t,Y,tp);
plotmotn(xp,yp,T), 
plotmotn(xp,yp,T,1)
return

fprintf('\nAll Done\n')

%=====================================

function [n,tmax,nt,fixorfree,rend,omega,...
                            cdamp]=chaindata
%                        
% [n,tmax,nt,fixorfree,rend,omega,...
%                           cdamp]=chaindata
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This example function creates data defining
% the chain. The function can be renamed and 
% modified to handle different problems.

n=8;          % Number or point masses
tmax=2;      % Maximum time for the solution
nt=401;       % Number of time values from 0 to tmax
fixorfree=0;  % Determines whether the right end 
              % position is controlled or free. Use
              % zero for free or one for controlled.
rend=0.0;    % Amplitude factor for end motion. This
              % can be zero if the ends are fixed.
omega=0;      % Frequency at which the ends are 
              % rotated.
cdamp=1;      % Coefficient regulating the amount of
              % viscous damping. Reduce cdamp to give
              % less damping.
              
%=====================================

function rdot=spreqmof(t,r,m,k,L,re,fext,c)
%
% rdot=spreqmof(t,r,m,k,L,re,fext,c)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function forms the two-dimensional equation
% of motion for a chain of spring-connected particles. 
% The positions of the ends of the chain may be time
% dependent and are computed from a function named in
% the input parameter re. The applied external loading 
% consists of constant loads on the particles and
% linear viscous damping proportional to the particle
% velocities. Data parameters for the problem are
% defined in a function file specified by the user.
% Function chaindata gives a typical example. 
%
% t    - current value of time
% r    - vector containing complex displacements in
%        the top half and complex velocity components
%        in the bottom half
% m    - vector of particle masses
% k    - vector of spring constant values
% L    - vector of unstretched spring lengths
% re   - name of a function which returns the time
%        dependent complex position coordinate for
%        the ends of the chain
% fext - vector of constant force components applied 
%        to the spring
% c    - vector of viscous damping coefficients for 
%        the particles

N=length(r); n=N/2; z=r(1:n); v=r(n+1:N);
R=feval(re,t); 
zdif=diff([R(1);z;R(2)]); len=abs(zdif);
fsp=zdif./len.*((len-L).*(len-L>0)).*k; fdamp=-c.*v; 
accel=(fext+fdamp+fsp(2:n+1)-fsp(1:n))./m;
rdot=[v;accel];

%=====================================

function rends=endmo(t)
%
% rends=endmo(t)
% ~~~~~~~~~~~~~
% This function specifies the varying end positions.
% In this example the ends rotate at frequency omega
% around circles of radius Rend.
%
% User m functions called:  none
%----------------------------------------------

global zend Rend omega
 
s=Rend*exp(i*omega*t); rends=[s,zend-conj(s)];

%=============================================

function plotmotn(x,y,titl,isave)
%
% plotmotn(x,y,titl,isave)
% ~~~~~~~~~~~~~~~~~~~~
% This function plots the cable time 
% history described by coordinate values 
% stored in the rows of matrices x and y.
%
% x,y   - matrices having successive rows 
%         which describe position 
%         configurations for the cable
% titl  - a title shown on the plots
% isave - parameter controlling the form 
%         of output. When isave is not input, 
%         only one position at a time is shown
%         in rapid succession to animate the
%         motion. If isave is given a value,
%         then successive are all shown at
%         once to illustrate a kinematic 
%         trace of the motion history.
%
% User m functions called:  none
%----------------------------------------------

% Set a square window to contain all 
% possible positions
[nt,n]=size(x); 
if nargin==4, save =1; else, save=0; end
xmin=min(x(:)); xmax=max(x(:));
ymin=min(y(:)); ymax=max(y(:)); 
w=max(xmax-xmin,ymax-ymin)/2;
xmd=(xmin+xmax)/2; ymd=(ymin+ymax)/2;  
hold off; clf; axis('normal'); axis('equal'); 
range=[xmd-w,xmd+w,ymd-w,ymd+w];
title(titl)
xlabel('x axis'); ylabel('y axis')
if save==0
  for j=1:nt
    xj=x(j,:); yj=y(j,:);
    plot(xj,yj,'-b',xj,yj,'ob');
    axis(range), axis off
    title(titl)
    figure(gcf), %drawnow
    pause(.1)
  end
  pause(2)
else
  hold off; clf
  for j=1:nt
    xj=x(j,:); yj=y(j,:);
    plot(xj,yj,'-b',xj,yj,'ob');
    axis(range), axis off, hold on
  end
  title(titl)
  figure(gcf), 
  %drawnow
  hold off, pause(2)
end