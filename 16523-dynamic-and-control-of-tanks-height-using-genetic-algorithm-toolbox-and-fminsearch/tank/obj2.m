% Author: Housam Binous

% Dynamic and control of a tank using the genetic algorithm toolbox

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function f=obj2(par)

global sys

% real PID controller's transfer function

num=[par(2) 1];
den=[par(2) 0];

pid1=tf(num,den);

num=[par(3) 1];
den=[0.1*par(3) 1];

pid2=tf(num,den);

pid=par(1)*pid1*pid2;

% response to change in set point
% set point for tank's height is equal to 2

sys_series=series(pid,sys);

sys_controlled=feedback(sys_series,1);

u=2*ones(501,1);

[y1 t3]=lsim(sys_controlled,u,0:0.01:5);

% objective function to be minimized by
% genetic algorithm in order to obtain
% real PID controller's parameters

f=0;

for i=1:201
    f=f+abs(2-y1(i))*t3(i);
end

