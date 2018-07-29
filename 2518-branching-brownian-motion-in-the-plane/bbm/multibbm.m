function [pt_conf, fmat]=multibbm(nu, lambda, van_pr, maxt, dt, ...
			    domain) 
% MULTIBBM Simulate a branching Brownian motion in the plain and make
%   an animation. 
%
%   Initially particles are distributed according to a Poisson
%   process in the plain with the scaled Lebesgue mean measure. The
%   particle follows a Brownian motion in the plane and has
%   exp(lambda) distributed lifetime. When the lifetime ends, the 
%   particle either divides into two particles with probability 1-van_pr
%   or dies with probability van_pr.
%
% [pt_conf]=multibbm(nu, lambda, van_pr, maxt
%                    [, dt, domain]) 
% 
% Inputs: 
%   nu - intensity of the Poisson process for the initial
%     configuration 
%   lambda - parameter of the exponential distribution
%     of the lifetime (note that expectation=1/lambda)
%   van_pr - probability for a particle to vanish
%   maxt - time interval
%   dt - time discretisation step. Optional, default dt=0.01.
%   domain - bounds for the region. A 4-dimensional vector in
%     the form [x_min x_max y_min y_max]. Optional, default value
%     [0 10 0 10].
%
% Outputs:
%   pt_conf - "configuration of the particles". A cell array
%     describing the system dynamics. An element k is a N_k x 2
%     matrix with the coordinates of the particles alive after time
%     k*dt. 
%

% Authors: R.Gaigalas, I.Kaj
% v1.8 Created 07-Nov-01
%      Modified 24-Nov-05 Changed variable names and comments
%      Modified 10-Jan-06 Corrected the bug with maxt and
%        parenthesis in l114

 if (nargin<1) % default parameter values
   nu = 0.7; % intensity of the Poisson process
   lambda = 20.0; % parameter of the lifetime distribution
   van_pr = 0.5;  % probability to vanish
   maxt = 0.7;   % time interval
 end

 if (nargin<5) % default parameter values 
   dt = 0.01;
   domain = [0 10 0 10];
 end

 disp('Generating BBM');
 
 xmin = domain(1); % bounds of the initial domain
 xmax = domain(2);
 ymin = domain(3);
 ymax = domain(4);
 clear domain;
   
 % initial number of particles Poisson distributed
 % with intensity proportional to the area
 area = (xmax-xmin)*(ymax-ymin); 
 ini_part = poissrnd(nu*area)

 % given the number of particles, coordinates are uniformly
 % distributed in the plain
 pt_coor = rand(ini_part, 2);
 pt_coor(:, 1) = pt_coor(:, 1)*(xmax-xmin)+xmin;
 pt_coor(:, 2) = pt_coor(:, 2)*(ymax-ymin)+ymin;

 % remaining lifetime - exp(lambda) distributed
 pt_life = -1/lambda*log(rand(ini_part, 1)); 
 % create the first frame for the movie
 pt_conf = cell(1, 1); 
 pt_conf{1} = pt_coor; 

 extinct = 0; % flag for the whole process
 nsteps = round(maxt/dt)+1; 

 c_step = ceil(nsteps/100);
   
 for t=2:nsteps
   
   % shorten the remaining lifetime by dt
   pt_life = pt_life-dt;
   
   % generate new coordinates for the particles alive:
   %     add the increment of BM
   i_alive = find(pt_life>0);
   pt_coor(i_alive, :) = pt_coor(i_alive, :) ...
                         +randn(length(i_alive), 2)*dt^0.5;  
   
   % find dying particles and decide if they will die 
   % or will divide
   i_dying = find(pt_life<=0);
   runi = rand(1, length(i_dying));
   % set the vanished particles to NaN
   pt_life(i_dying(find(runi<=van_pr))) = NaN; 
   
   % replicate the particles that need that
   i_rep = i_dying(find(runi>van_pr)); 
   nrep = length(i_rep);
   % generate new lifetimes for the parents
   pt_life(i_rep) = -1/lambda*log(rand(nrep, 1));
   % generate lifetimes for the children and add to the array
   pt_life = [pt_life; -1/lambda*log(rand(nrep, 1))];

   % add the coordinates of one of the newborn particles to the
   % array 
   pt_coor = [pt_coor; pt_coor(i_rep, :)];   

   % create a new frame
   pt_conf = [pt_conf cell(1, 1)];
   % add the particles alive and the "second child" particles
   pt_conf{t} = [pt_coor(i_alive, :); pt_coor(i_rep, :)];
   
   % test if there are any particles alive
   if all(isnan(pt_life))
     extinct = 1;
     break;
   end

   % display the progress
   if (rem(t, c_step)==0)
      fprintf('\r %i%% done', t/c_step);
   end
 end

 fprintf(1, '\r 100%% done\n');
   
 if (extinct)
   fprintf('\nExtinct after t=%f\n',(t-1)*dt);  
 else
   fprintf('\n%d particles alive after t=%f\n', ...
           size(pt_conf{nsteps}, 1), maxt);   
 end
 
 % animate
 figure(1)
 fmat = bbmplot(pt_conf);
 
