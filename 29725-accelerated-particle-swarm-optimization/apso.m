% ============================================================= % 
% Files of the Matlab programs included in the book:            %
%     Xin-She Yang, Nature-Inspired Metaheuristic Algorithms,   %
%     Second Edition, Luniver Press, (2010).   www.luniver.com  %
% ============================================================= %   
% The Accelerated Particle Swarm Optimization:                  %              
% For detail, section Chapter 5 (section 5.3) in the book by    %
% Xin-She Yang, Nature-Inspired Metaheuristic Algorithms,       %
% First Edition, Luniver Press, (2008). Also in Chapter 8       %
% (section 8.3, page 65) of the second edition (2010).          %
% ------------------------------------------------------------- %

% =============================================================
% Usage: apso(number_of_particles,timesteps)
%  eg:   best=apso(20,10);
%  where best=[xbest ybest zbest]  %a n by 3 matrix
% ------------------------------------------------------------- 
function [best]=apso(n,timesteps)
% n=number of particles 
% timesteps=total number of time steps
if nargin<2,   timesteps=15;  end
if nargin<1,   n=20;         end
% -------------------------------------------------------------
% Michalewicz Function f*=-1.8013 at [2.20319, 1.57049]
funstr='-sin(x)*(sin(x^2/pi))^20-sin(y)*(sin(2*y^2/pi))^20';
f=inline(vectorize(funstr));
% Lb=[xmin  ymin] and Ub=[xmax ymax];
Lb=[0 0]; Ub=[4 4]; 
% -------------------------------------------------------------                                
% Setting  parameters alpha, beta
% Randomization amplitude of roaming particles alpha=[0,1]
% alpha=gamma^t=0.7^t;
% Speed of convergence (0->1)=(slow->fast); % beta=0.5 
beta=0.5;
% -------------------------------------------------------------
% Grid values for show the topology of the function 
% to be optimized. For display only, not used for optimization.
Ngrid=100; % Ngrid=100;
dx=(Ub(1)-Lb(1))/Ngrid;
dy=(Ub(2)-Lb(2))/Ngrid;

[x,y]=meshgrid(Lb(1):dx:Ub(1),Lb(2):dy:Ub(2));
% get the shape of the function
% you can define any function to be optimized in 'fun(x,y)'
% funflag=1 or 2 or 3 choose a function from a list

z=f(x,y);

% Display the shape of the function to be optimized
figure(1);
surfc(x,y,z); 
% -----------------------------------------------------------
best=zeros(timesteps,3); 

% ===========================================================
% ------------- Start Particle Swarm Optimization -----------
% generating the initial locations of n particles
[xn,yn]=init_pso(n,Lb,Ub);
% Display the paths of particles in a figure with  
% contours of the function to be optimized 
   figure(2);

% Time-marching or iterations 
for i=1:timesteps,     %%%%% start time-stepping
   % Show the contour of the function 
  contour(x,y,z,15); hold on;
  colormap cool;

% Find the current best location (xo,yo)
zn=f(xn,yn);
zn_min=min(zn);
xo=min(xn(zn==zn_min));
yo=min(yn(zn==zn_min));
zo=min(zn(zn==zn_min));

% Trace the paths of all roaming particles 
% Display these roaming particles
plot(xn,yn,'.',xo,yo,'d','markersize',10,'markerfacecolor','g');

% The accelerated PSO alpha=alpha_0* gamma^t with alpha_0=1
  gamma=0.7; alpha=gamma.^i;
% Move all particle to new locations  
  [xn,yn]=pso_moving(xn,yn,xo,yo,alpha,beta,Lb,Ub);  
  drawnow;
  
% If you keep "hold on", then the paths of particles are displayed 
	hold off;
% History
   best(i,1)=xo; best(i,2)=yo; best(i,3)=zo;
% Output the results (xo,yo) to screen
   str=strcat('Best estimates: =',num2str([xo yo]));
   str=strcat(str,'  fmin='); str=strcat(str,num2str(best(i,3)));
   str=strcat(str,'  Iteration='); str=strcat(str,num2str(i));
   disp(str);
end   %%%%% end of time-stepping

% Postprocessing & display best
bestsolution=best(end,1:2)
fmin=best(end,3)
% -----------------------------------------------------------------
% All subfunctions are listed here 
% -----------------------------------------------------------------
% Intial locations of particles
function [xn,yn]=init_pso(n,Lb,Ub)
xn=rand(1,n)*(Ub(1)-Lb(1))+Lb(1);
yn=rand(1,n)*(Ub(2)-Lb(1))+Lb(2);

% Move all the particles toward (xo,yo)
function [xn,yn]=pso_moving(xn,yn,xo,yo,alpha,beta,Lb,Ub)
% Get the number of particles
nn=size(yn,2);
xn=xn.*(1-beta)+xo.*beta+alpha.*randn(1,nn);
yn=yn.*(1-beta)+yo.*beta+alpha.*randn(1,nn);
[xn,yn]=findrange(xn,yn,Lb,Ub);

% Make sure the particles are not outside of the range
function [xn,yn]=findrange(xn,yn,Lb,Ub)
nn=length(yn);
for i=1:nn,
   if xn(i)<=Lb(1), xn(i)=Lb(1); end
   if xn(i)>=Ub(1), xn(i)=Ub(1); end
   if yn(i)<=Lb(2), yn(i)=Lb(2); end
   if yn(i)>=Ub(2), yn(i)=Ub(2); end
end
% End of the APSO -------------------------------------------------


