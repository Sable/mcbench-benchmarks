% this generates figures 4 and 5 of Tresadern and Reid, IVC 2008, based on
% the outputs of noise_expt.m
%
% © Copyright Phil Tresadern, University of Oxford, 2006

clear all; close all; clc;
addpath('./toolbox');

% load errors computed by noise_expt.m
load('./data/noise/newerrors.mat','sigmas','errorstats');

% define (and create if necessary) the folder for figures
figpath = './figs/synth_run/';
if ~exist(figpath,'dir')
	mkdir(figpath);
end

% plot of angle between rotation axes with respect to noise
% (Figure 4a, Tresadern and Reid, IVC 2008)
graph(1); clf; hold on; dim = 4;
	plot(sigmas,errorstats.lieb.mean(1:end,dim),'-','color',[0,0,1]);
	plot(sigmas,errorstats.min.mean(1:end,dim),'--','color',[1,0,0]);
	plot(sigmas,errorstats.abundle.mean(1:end,dim),':','color',[0,0.5,0]);
	plot(sigmas,errorstats.pbundle.mean(1:end,dim),'-.','color',[0.75,0,0.75]);
	xlabel('\sigma (pixels)');
	ylabel('\phi (rad)');
	legend('L&C','Minimal','A.B.A.','P.B.A.','location','NorthEast');
	set(gca,'Box','on');
	exportfig([figpath,'phi_err']);

% plot of rotation angle about axes with respect to noise
% (Figure 4b, Tresadern and Reid, IVC 2008)
graph(1); clf; hold on; dim = 5;
	plot(sigmas,errorstats.lieb.mean(1:end,dim),'-','color',[0,0,1]);
	plot(sigmas,errorstats.min.mean(1:end,dim),'--','color',[1,0,0]);
	plot(sigmas,errorstats.abundle.mean(1:end,dim),':','color',[0,0.5,0]);
	plot(sigmas,errorstats.pbundle.mean(1:end,dim),'-.','color',[0.75,0,0.75]);
	xlabel('\sigma (pixels)');
	ylabel('\omega_{err} (rad)');
	legend('L&C','Minimal','A.B.A.','P.B.A.','location','NorthWest');
	set(gca,'Box','on');
	exportfig([figpath,'omega_err']);

% plot of segment length error with respect to noise
% (Figure 5a, Tresadern and Reid, IVC 2008)
graph(1); clf; hold on; dim = 2;
	plot(sigmas,errorstats.lieb.mean(1:end,dim),'-','color',[0,0,1]);
	plot(sigmas,errorstats.min.mean(1:end,dim),'--','color',[1,0,0]);
	plot(sigmas,errorstats.abundle.mean(1:end,dim),':','color',[0,0.5,0]);
	plot(sigmas,errorstats.pbundle.mean(1:end,dim),'-.','color',[0.75,0,0.75]);
	xlabel('\sigma (pixels)');
	ylabel('RMS joint angle error (rad)');
	legend('L&C','Minimal','A.B.A.','P.B.A.','location','NorthWest');
	set(gca,'Box','on');
	exportfig([figpath,'rms_joint']);

% plot of joint angle error with respect to noise
% (Figure 5b, Tresadern and Reid, IVC 2008)
graph(1); clf; hold on; dim = 3;
	plot(sigmas,errorstats.lieb.mean(1:end,dim),'-','color',[0,0,1]);
	plot(sigmas,errorstats.min.mean(1:end,dim),'--','color',[1,0,0]);
	plot(sigmas,errorstats.abundle.mean(1:end,dim),':','color',[0,0.5,0]);
	plot(sigmas,errorstats.pbundle.mean(1:end,dim),'-.','color',[0.75,0,0.75]);
	xlabel('\sigma (pixels)');
	ylabel('Relative segment length error (%)');
	legend('L&C','Minimal','A.B.A.','P.B.A.','location','NorthWest');
	set(gca,'Box','on');
	exportfig([figpath,'length_err']);
