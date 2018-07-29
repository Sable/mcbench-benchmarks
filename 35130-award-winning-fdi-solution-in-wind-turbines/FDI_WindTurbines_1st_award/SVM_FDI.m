%%  SVM FOR FAULT DIAGNOSIS 
% Script containing the SVM models of the various faults, and the measures data you wish to test,
% and get results of the fault diagnosis method.By Nassim laouti, Date 13.11.2010.
% Latest modification 16.02.2012.
%%

clear all
close all
clc

global st1 st2 st3 st5 st6 st7 st8 st9 st10 st11 st12 st13 st14 st15 st16 st17 st18 theta

%% Parameters
% Constants using in the preprocessing block
c3=10;c4=1000;wr0=1;wg0=100;omega_n=11.11;xi=0.6;P_r=4.8e6;
T1=0.6;T2=0.02;T3=0.06;T4=0.08;T5=0.04;

% Simple time and time
Ts=1/100
Time=Ts:Ts:4400;

%% Load the data_test that contains all measures and the controller output 
% data_test=[v_hub_m;omega_r_m1;omega_r_m2;omega_g_m1;omega_g_m2;Tau_g_m;P_g_m;Beta_1_m1;Beta_1_m2;Beta_2_m1;Beta_2_m2;Beta_3_m1;Beta_3_m2;Tau_g_r;Beta_r]

load data_test_3;
measures=measures';
wr0=measures(1,3);wg0=measures(1,5);

%% Load SVM models of the various faults
% Load the svm model of the sensor fault beta1m1 type fixed value
load model_cap1_beta1m1 

% Load the svm model of the sensor fault beta1m2 type fixed value
load model_cap1_beta1m2 

% Load the svm model of the sensor fault beta2 type gain factor
load model_cap_beta2_t2

% Load the svm model of the sensor fault omega_r_m1 type fixed value
load model_cap1_wr1 

% Load the svm model of the sensor fault omega_r_m2 type fixed value
load model_cap1_wr2 

% Load the svm model of the sensor fault omega_r_m2 type gain factor
load model_cap_wr2_t2 

% Load the svm model of the sensor fault omega_r_m1 type gain factor
load model_cap_wr1_t2 

% Load the svm model of the sensor fault omega_g_m1 type fixed value
load model_cap1_wg1 

% Load the svm model of the sensor fault omega_g_m2 type fixed value
load model_cap1_wg2 

% Load the svm model of the sensor fault omega_g_m2 type gain factor
load model_cap_wg2_t2 

% Load the svm model of the sensor fault omega_g_m1 type gain factor
load model_cap_wg1_t2 

% Load the svm model of the actuator fault Tau_g type offset 
load model_act_couple 

% Load the svm model of the system fault
load model_system 

% Load the svm model of the sensor fault omega_g type gain factor
load model_cap_wg_t2 

% Load the svm model of the sensor fault omega_r type gain factor
load model_cap_wr_t2 

% Load the svm model of the sensor fault beta2m2 type gain factor
load model_cap_beta2m2_t2 

% Load the svm model of the sensor fault beta2m2 type gain factor
load model_cap_beta2m1_t2 

%% Simulation 

 open_system('FDI_SVM_WT.mdl');
 
 tic
 sim('FDI_SVM_WT.mdl',Time(end));
 toc



