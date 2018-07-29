function [N,K,D,L,var,w_max,w_min,c1,c2,position,p_best,g_best,fitness,p_best_fit,...
    Num_func,Min_Max_flag,Gl_Lo_flag]=initialize
N = 50;    % N is the number of the particles
K = 1000;  %K is the number of iteration
var = 5; % var is number of variables
L = 15 ; % L is the lenght for each variable
D = L*var; % D is the dimension of each particle
w_min=0.1;w_max=0.6;c1=2;c2=2;% w is the inertia factor and c1 & c2 are learning factors
position = rand(N,D)>0.5; % Generates initial population
fitness=0;
p_best = rand(N,D)>0.5;
g_best = rand(N,D)>0.5;
p_best_fit = ones(N,1);
Num_func = 1 ; % Select the number of function to be evaluated
Min_Max_flag = 1 ;  % 1 if the function must be minimized  ....  2 if the function must be maximized
Gl_Lo_flag = 1  ;   % 1 if the search is global ...............  2 if the search is local
return