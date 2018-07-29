%______________________________________________________________23/06/07___
%|First-Order Degree Linear Differential E.|    H.C.Eng.Ali Özgül (C)(R)  |
%|_____(Integration multipler Ig=x^a*y^b)__|______________________________|
%|Sub Function Application                                                |
%|                                                                        |
%| [Solution]=DIfactor([M(x,y),N(x,y)],flag)                              |
%|                                                                        |
%| M(x,y): possible a function f(x,y)                                     |
%| N(x,y): possible a function f(x,y)                                     |
%| flag  : if flag=1 than perceived all solution application else         |
%|         solution be small.                                             |
%|                                                                        |
%| if flag =1 than display all solution step  results                     |
%| if flag<>1 than display directly solution  result                      |
%|________________________________________________________________________|

clc
clear

syms x y real

%% Example-1.1 & Flag<>1 
DIfactor([8*y+4*x^2*y^4,8*x+5*x^3*y^3],0)

%% Example-1.2 & Flag==1 
DIfactor([8*y+4*x^2*y^4,8*x+5*x^3*y^3],1);

%% Example-2
DIfactor([3*y^3-x*y,-x^2-6*x*y^2],1);

%% Example-3
DIfactor([2*x^3*y^4-5*y,x^4*y^3-7*x],1);

%% Example-4
DIfactor([2*y+3*x*y^2,x+2*x^2*y],1);

%% Example-5
DIfactor([y^3-2*x^2*y,2*y^2*x-x^3],1);

%% Example-6
DIfactor([4*y*x+3*y^4,2*x^2+5*x*y^3],1);

%% Example-7
DIfactor([2*y+3*x*y^2,x+2*x^2*y],1);

