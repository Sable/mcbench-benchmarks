clc; clear all; close all;
% syms m1 m2 m3 m4 m5 m6 m7 k1 k2 k3 k4 k5 k6 k7 k8 k9 k10 real

alpha = 0.002;
beta = 0;

% m = [m1 m2 m3 m4 m5 m6 m7];
% k = [k1 k2 k3 k4 k5 k6 k7 k8 k9 k10];
m = [.15 .3 .2 .6 .3 .2 .7]';
k = [800 575 1200 200 150 450 100 1200 600 200]';

m_con = {[1,2,4],[2,3],[4,5,6,7,8],7,[8,9],[9,10],[3,6,10]};
k_con = {1;[1,2];[2,7];[1,3];3;[3,7];[3,4];[3,5];[5,6];[6,7]};

[M,D,K] = MDK(m,k,m_con,k_con,alpha,beta);