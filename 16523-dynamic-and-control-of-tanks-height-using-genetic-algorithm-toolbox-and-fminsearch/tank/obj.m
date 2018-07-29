% Author: Housam Binous

% Dynamic and control of a tank using the genetic algorithm toolbox

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

function f=obj(par)

global t1 h

% step response and transfer function of the tank

A=par(1);
B=par(2);

num=[1];
den=[A,B];
sys=tf(num,den);

[y t2]=step(sys,0:1:500);

% function to be minimized by fminsearch in order
% to obtain the first order transfer function of 
% the tank

f=0;

for i=1:500
    f=f+(h(i)-y(i))^2;
end

end
