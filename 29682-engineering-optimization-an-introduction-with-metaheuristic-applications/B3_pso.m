% -----------------------------------------------------------------  %
% Matlab Programs included the Appendix B in the book:               %
%  Xin-She Yang, Engineering Optimization: An Introduction           %
%                with Metaheuristic Applications                     %
%  Published by John Wiley & Sons, USA, July 2010                    %
%  ISBN: 978-0-470-58246-6,   Hardcover, 347 pages                   %
% -----------------------------------------------------------------  %
% Citation detail:                                                   %
% X.-S. Yang, Engineering Optimization: An Introduction with         %
% Metaheuristic Application, Wiley, USA, (2010).                     %
%                                                                    % 
% http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html % 
% http://eu.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html  %
% -----------------------------------------------------------------  %
% ===== ftp://  ===== ftp://   ===== ftp:// =======================  %
% Matlab files ftp site at Wiley                                     %
% ftp://ftp.wiley.com/public/sci_tech_med/engineering_optimization   %
% ----------------------------------------------------------------   %

% Particle Swarm Optimization (by X-S Yang, Cambridge University)
% Usage: B3_pso(number_of_particles,Num_iterations)
%  eg:   best=B3_pso(20,15);
% where best=[xbest ybest zbest]  %an n by 3 matrix

function [best]=B3_pso(n,Num_iterations)
% n=number of particles; Num_iterations=number of iterations
if nargin<2,   Num_iterations=15;  end
if nargin<1,   n=20;          end
% Michaelwicz Function f*=-1.801 at [2.20319,1.57049]
fstr='-sin(x)*(sin(x^2/pi))^20-sin(y)*(sin(2*y^2/pi))^20';
% Converting to an inline function and vectorization
f=vectorize(inline(fstr));
% range=[xmin xmax ymin ymax];
range=[0 4 0 4];
% ----------------------------------------------------
% Setting the parameters: alpha, beta
alpha=0.2; beta=0.5;
% ----------------------------------------------------
% Grid values of the objective for visualization only
Ndiv=100;
dx=(range(2)-range(1))/Ndiv;dy=(range(4)-range(3))/Ndiv;
xgrid=range(1):dx:range(2); ygrid=range(3):dy:range(4);
[x,y]=meshgrid(xgrid,ygrid);
z=f(x,y);
% Display the shape of the function to be optimized
figure(1); surfc(x,y,z);
% ---------------------------------------------------
best=zeros(Num_iterations,3);   % initialize history
% ----- Start Particle Swarm Optimization -----------
% generating the initial locations of n particles
[xn,yn]=init_pso(n,range);
% Display the particle paths and contour of the function
 figure(2);
% Start iterations
for i=1:Num_iterations,
% Show the contour of the function
  contour(x,y,z,15); hold on;
% Find the current best location (xo,yo)
zn=f(xn,yn);
zn_min=min(zn);
xo=min(xn(zn==zn_min));
yo=min(yn(zn==zn_min));
zo=min(zn(zn==zn_min));
% Trace the paths of all roaming particles
% Display these roaming particles
plot(xn,yn,'.',xo,yo,'*'); axis(range);
% Move all the particles to new locations
[xn,yn]=pso_move(xn,yn,xo,yo,alpha,beta,range);
drawnow;
% Use "hold on" to display paths of particles
hold off;
% History
best(i,1)=xo; best(i,2)=yo; best(i,3)=zo;
end   %%%%% end of iterations
% ----- All subfunctions are listed here -----
% Intial locations of n particles
function [xn,yn]=init_pso(n,range)
xrange=range(2)-range(1); yrange=range(4)-range(3);
xn=rand(1,n)*xrange+range(1);
yn=rand(1,n)*yrange+range(3);
% Move all the particles toward (xo,yo)
function [xn,yn]=pso_move(xn,yn,xo,yo,a,b,range)
nn=size(yn,2);  %a=alpha, b=beta
xn=xn.*(1-b)+xo.*b+a.*(rand(1,nn)-0.5);
yn=yn.*(1-b)+yo.*b+a.*(rand(1,nn)-0.5);
[xn,yn]=findrange(xn,yn,range);
% Make sure the particles are within the range
function [xn,yn]=findrange(xn,yn,range)
nn=length(yn);
for i=1:nn,
   if xn(i)<=range(1), xn(i)=range(1); end
   if xn(i)>=range(2), xn(i)=range(2); end
   if yn(i)<=range(3), yn(i)=range(3); end
   if yn(i)>=range(4), yn(i)=range(4); end
end
