% PURPOSE: demo of chowlin_co()
%          Temporal disaggregation with indicators.

% 		  Chow-Lin method, rho derived via Cochrane-Orcutt
%-------------------------------------------------------------
% USAGE: chowlin_co_d
%-------------------------------------------------------------

close all; clear all; clc;

% Low-frequency data: Bournay-Laroque (1979)
% Y: Output. Textile industries at 1956 prices. Unit: FF.
% Sample: 1949-1959

Y = [18664
    21049
    22472
    21831
    23011
    24045
    24621
    26037
    28195
    27702
    27273 ];
  
% High-frequency data: Bournay-Laroque (1979)
% x: Index of Industrial Production. Textile industries. Unit: base 1952=100
% Sample: 1949.1 - 1960.4
 x = [94
    93
    92
    95
    101
    104
    108
    108
    107
    111
    108
    106
    105
    99
    97
    99
    97
    101
    105
    108
    108
    110
    114
    112
    109
    107
    105
    106
    108
    113
    113
    120
    124
    127
    128
    128
    130
    124
    119
    112
    106
    117
    118
    123
    124
    125
    125
    128 ];

% ---------------------------------------------

% Inputs for td library

% Type of aggregation
ta=1;   

% Frequency conversion 
sc=4;    

% Intercept
opC = -1;

% Name of ASCII file for output
file_sal='td.sal';   

% Calling the function: output is loaded in a structure called res
res=chowlin_co(Y,x,ta,sc,opC);

% Calling printing function
tdprint(res,file_sal);

edit td.sal;

% Calling graph function
tdplot(res);

