% program demo_simple.m
clc
close all

disp('Compute and select time series models from a signal file called data,') 
disp('with asel and bsel as parameters of the selected model.')
disp(' ')
disp('If no file called "data" is available in the workspace,')
disp('20 AR(1) observations are generated. ')
disp(' ')
disp('Only four statements are required to estimate ')
disp(' ')
disp('-  a time series model for the data')
disp('-  the spectrum of the data')
disp('-  the autocorrelation functions of the data')
disp('-  the distance of the selected model to any other model with parameters a, b') 
disp(' ')
disp('The four statements are:')
disp(' ')
disp('  [asel bsel] = armasel(data)')
disp('  [psd fas]   = arma2psd(asel,bsel);')
disp('  cor         = arma2cor(asel,bsel,50);')
disp('  ME          = moderr(asel,bsel,a,b,length(data))')
disp(' ')
disp('The parameter vectors asel and bsel of the selected model are: ')

if ~exist('data')
    data  = simuarma([1 -.9],1,20);
end

[asel bsel] = armasel(data)
 
% Compute and plot the autocorrelation functions and spectra of the
% generating true model and the ARMAsel selected model.
% gain is the power gain or the ratio between output and input variance of ARMA process
% The length of the correlation function is chosen as 50.

cor = arma2cor(asel,bsel,50);
[psd fas] = arma2psd(asel,bsel);

% Compute the accuracy of the estimated model in comparison with 
% the white noise process with the parameter vectors a=1, b=1

disp(' ')
disp('The distance to the process with the parameter vectors a=1 and b=1 is:')

a=1;
b=1;
ME = moderr(asel,bsel,a,b,length(data))

figure(1),
plot(data),
xlabel('\rightarrow time axis [s]')
title('data')

figure(2),
plot(0:50,cor,'r')
title('Estimated autocorrelation function')
xlabel('\rightarrow time lag [s]')

figure(3),

semilogy(fas,psd,'r')
title('Estimated spectrum with logarithmic scale')
xlabel('\rightarrow normalized frequency \it{f/f_s}'),
ylabel('Log scale for PSD'),
axis tight 

disp(' ')
disp('Figure 1 shows the data')
disp('Figure 2 shows the estimated autocorrelation function')
disp('Figure 3 shows the estimated power spectral density (PSD)')
