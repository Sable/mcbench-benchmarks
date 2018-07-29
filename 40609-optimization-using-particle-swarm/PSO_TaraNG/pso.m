%%
% Auther : Gaul Swapnil Narhari,
% Developed @ IIT Kharagpur, India.
% In collaborationwith TaraNG, India.


%%
%[El,fval] = pso(PROBLEM) finds the minimum for PROBLEM. PROBLEM is a structure
%   that has the following INPUT fields:
%       fitnessfcn: <Fitness function>
%            nvars: <Number of design variables>
%               lb: <Lower bound on X>
%               ub: <Upper bound on X>
%       Genrations: <Number of iterations>
%       Population: <Number of swarms(particles) used for optimization>
%           DispWB: <whether to disply waitbar or not '1' to display>
%                   waitbar is having gbest value displayed on it
%    OUTPUT fields:
%               EL: <The values of optimized parameters>
%             fval: <Fitness value after optimization>

% Example: 
% First, create a file to evaluate fitness function say,'simple_fitness.m' as follows:
%
%       function y = simple_fitness(x)
%       y = 100*(x(1)^2 - x(2))^2 + (1 - x(3))^2 + abs(0.4 - x(2));
%
% To minimize the fitness function, user need to pass a function handle to the fitness function
% as the first argument to the pso function, as well as other parameters of
% PROBLEM as stated above in pso(PROBLEM),
%
%       ObjectiveFunction = @simple_fitness;
%       nvars = 3;      % Number of variables
%       LB = [0 0 0];   % Lower bound
%       UB = [3 5 10];  % Upper bound
%       Popln=200;      % Number of particles
%       Genrtn=50;      % Number of iterations
%       WByn=1;         % '1' = waitbar is ON
%   [x,fvalue] = pso(ObjectiveFunction,'NumVar',nvars,'LowerBound',LB,'UpperBound',UB,...
%                       'Population',Popln,'Genrations',Genrtn,'IncludeWB',WByn);
%
%Reference:J. Robinson and Y. Rahmat-Samii, “Particle swarm optimization in electromagnetics,” 
%          IEEE Transactions on Antennas and Propagation, vol. 52, no. 2,
%          397 pages, 2004.
%
%%


function [OptimizedElem,fval] = pso(fhandle,~,NumVer,~,LB,~,UB,~,PopulationSize,~,Generations,~,DispWB)
warning('off');
% global pbest_loc;
% global gbest_loc;
% global pbest_val;
% global gbest_val;
% global iteration;
% global gbest_val_record;
% global El_range El_lim_low El_lim_up vel P EV p n ev DispWB
% global NumVer fhandle
% global k_pb_i  k_pb_f  k_gb_i k_gb_f w delta_t;
% global El_lim_low El_lim_up LB UB El_range PopulationSize P Generations iteration;
% global El vel NumVer pbest_loc gbest_loc pbest_val EV gbest_val_record;
% global FitVal gbest_val ev av d n p t delta_t k_pb_i k_pb_f k_gb_i k_gb_f w


global gbest_loc;
global gbest_val;
global iteration;
global P EV p n ev DispWB
global NumVer fhandle
global LB UB  PopulationSize P Generations iteration;
global NumVer  gbest_loc  EV ;
global gbest_val ev n p       

if (DispWB==1)
wb = waitbar(0,'1','Name','TaraNG - Optimizer :',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(wb,'canceling',0);
end

%% Intialise Parameters
init_params();
%%
%% Intialise position & velocity of all agents %ini_posi_vel()
intialise();
%%
for n=1:iteration
for p=1:P
ev=ev+1;
%% update fitness for each particle and iteration
update_fit();
%% update pbest & gbest;
update_pbest_gbest();
%% update_vel_pos(p,n);
update_vel_pos();
%% 
if (DispWB==1)
waitbar(ev/EV,wb,sprintf('%12.9f',gbest_val));
end
end
end
OptimizedElem=gbest_loc(1,1:NumVer);
fval=gbest_val;
if(DispWB==1)
delete(wb);
end
end
