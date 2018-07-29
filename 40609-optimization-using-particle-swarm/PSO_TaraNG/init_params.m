%% Intialise Parameters
function init_params()
global El_lim_low El_lim_up LB UB El_range PopulationSize P Generations iteration;
global El vel NumVer pbest_loc gbest_loc pbest_val EV gbest_val_record;
global FitVal gbest_val ev av d n p t delta_t k_pb_i k_pb_f k_gb_i k_gb_f w
El_lim_low(1,1:NumVer)=LB;
El_lim_up(1,1:NumVer)=UB;
El_range(1,1:NumVer)= El_lim_up - El_lim_low;
P=PopulationSize;% number of particles
iteration=Generations;% number of iterations
% Intialise Pbest of all agents & Gbest
El =zeros(1,NumVer,P);
vel =zeros(1,NumVer,P);
pbest_loc=zeros(1,NumVer,P);
gbest_loc=zeros(1,NumVer);
pbest_val=zeros(P);
EV=P*iteration;
gbest_val_record(1:EV) = 0; 
FitVal = 0.0;                            
gbest_val = 0.0;                     
ev = 0;
av = 0;
d=0; n=0; p=0; t=0;
delta_t=1;
% Set parameters of the optimization problem
k_pb_i = 2.5;
k_pb_f = 0.5;
k_gb_i = 0.5;
k_gb_f = 2.5;
w = 0.9;
end