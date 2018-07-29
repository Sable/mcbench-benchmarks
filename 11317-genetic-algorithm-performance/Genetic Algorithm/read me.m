% Genetic Algorithm(real coding)
% By: Javad Ivakpour
% E-mail: javad7@gmail.com
% May 2006


% This function is a simple GA with real coding of variables that can be
% used for maximization of any function
% befor using this function please read these annotations: 
% The value of var (in the main function) must be equal to dimension of
% x in the function that introduced in fun00.m
% for example for optimization of this function:
%        z=-(100*(x(1)^2-x(2))^2+(1-x(1))^2);
% change var=2 in line 19 function GA and replace this function in 
% file fun00.m and if var=2 then change the function in plot00.m to see 
% accurate results (e.g. for this function) in file plot00(line 2) replace:
%        ezmesh('-(100*(x^2-y)^2+(1-x)^2)',cx)  
% when you run a function if var=2 you can see the location of each
% individual in each generation else you can see the development of GA vs. 
% number of generations.
% for comparison the performance of random search is plotted in each
% figure.
% in line 49 number of diffrent termination criteria used for terminate
% algorithm.
% in line 57 for each 10 generation the number of random mutation is 
% reduced by one. you can set or eliminate this operation if you want.
% also in line 52 the sigma values are reduced in each generation. you 
% can tune this operation too.

%  
%   example:
%   for find the maximum of function:
%    z=(-sin(0.005*x(1))*(x(2)^3+1)*sin(0.01*x(2)))*(2000-x(1))*...
%       (2000-x(2))*(2000-x(3))*x(3)*x(4)*(2000-x(5)*sin(((x(6)/1000)^2)));
%     that 0<x(i)<2000 for i=1 to 6
%    1- replace this function with function that exist in fun00.m file
%    2- set var=2 in line 19 GA.m file or line 19 GAconstrain.m file
%    3- set valuemin=ones(1,var)*0; in line 29 GA.m file or line 29 
%     GAconstrain.m
%    4- set valuemax=ones(1,var)*2000; in line 30 GA.m file or line 30 
%     GAconstrain.m
%    5- tune the GA parameters in lines 22-28 GA.m file and GAconstrain.m
%    6- run the file
%    7- if the function is a constrained problem set A and B in 
%       GAconstrain.m lines 31 & 32 so that Ax+B>0
%
