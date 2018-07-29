%% Setting Inputs
fun  = 'x^3 - 3*x -5';
start = 3;
iter = 100;
%% Function Call
x = newtonraphson(fun,start,iter);
x
%% eof