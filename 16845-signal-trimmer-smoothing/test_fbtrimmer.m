%   This example contain a sample servo system data which are differentiated
%   and applied for the "fbtrim.m" for refinement.

%   Author(s): Farhad Bayat, 
%   Email: fbayat@ee.iust.ac.ir
%   Copyright 2000-2008 

% clear;
% close all; 
% 
% uiopen('TestData.mat'); % Select the existing sample data: TestData.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%   Test 0:   %%%%%%%%%%%%%%%%%%%%
param=[0.3,1,0.01,5,5]; % [NPF,CF,MSV,LCF,Nd]
dy0=fbtrim(Data0,param);
figure(1);
t0=[1:length(dy0)]';
plot (t0,Data0 ,'blue',t0,dy0 ,'red');
xlabel('Sample'); ylabel('Data_0');
Title(' Test-0 ');
legend('Noisy Data','Trimmed Data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%   Test 1:   %%%%%%%%%%%%%%%%%%%%
dy1=fbtrim(Data1);
figure(2);
t1=[1:length(dy1)]';
plot (t1,Data1 ,'blue',t1,dy1 ,'red');
xlabel('Sample'); ylabel('Data_1');
Title(' Test-1 ');
legend('Noisy Data','Trimmed Data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%   Test 2:   %%%%%%%%%%%%%%%%%%%%
dy2=fbtrim(Data2);
figure(3);
t2=[1:length(dy2)]';
plot (t2,Data2 ,'blue',t2,dy2 ,'red');
xlabel('Sample'); ylabel('Data_2');
Title(' Test-2  ');
legend('Noisy Data','Trimmed Data');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%   Test 3:   %%%%%%%%%%%%%%%%%%%%
dy3=fbtrim(Data3);
figure(4);
t3=[1:length(dy3)]';
plot (t3,Data3 ,'blue',t3,dy3 ,'red');
xlabel('Sample'); ylabel('Data_3');
Title(' Test-3  ');
legend('Noisy Data','Trimmed Data');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%   Test 4:   %%%%%%%%%%%%%%%%%%%%
dy4=fbtrim(Data4);
figure(5);
t4=[1:length(dy4)]';
plot (t4,Data4 ,'blue',t4,dy4 ,'red');
xlabel('Sample'); ylabel('Data_4');
Title(' Test-4  ');
legend('Noisy Data','Trimmed Data');
