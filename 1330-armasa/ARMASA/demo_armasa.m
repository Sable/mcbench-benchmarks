% DEMO_ARMASA demonstration of some ARMASA toolbox features
%
%   DEMO_ARMASA is a program script that can be invoked from the command 
%   prompt to perform a signal analysis experiment, showing general use 
%   of several main ARMASA functions.
%   
%   The experiment shows:
%   
%   - Generation of data
%   - Selection of model type, AR, MA or ARMA, and model order
%   - Assessing the accuracy of the estimated model
%   - Computation of autocorrelations and power spectral density of data

% Initializations
% ---------------

clear,clc
warn_state = warning;
if ischar(warn_state)
    warn_recov_comm = ['warning ' warn_state];
else
    warn_recov_comm = ['warning(warn_state);'];
end
warning off

% Generation of data
% ------------------

% The use of reflection coefficients less than one gives a stationary process.
% 'rc2arset' transforms reflection coefficients in parameters.
ar_true=rc2arset([1 -.8  .6 -.4]);
ma_true=rc2arset([1 .7  -.5 ]);

disp(' ')
disp('==============================================================================')
disp('=          DEMO_ARMASA demonstration of some ARMASA toolbox features         =')
disp('==============================================================================')
disp(' ')
disp('  Note: DEMO_ARMASA is a program script. All variables are created in the base')
disp('        workspace and can directly be accessed in the command window.')
disp(' ')
disp(' ')
disp('  The parameters of a stationary and invertible ARMA(3,2) process are used')
disp('  to generate the data. The true AR parameters are,')
ar_true
disp('  and the true MA parameters are,')
ma_true 
disp('  The data used for the experiment are generated with simuarma')
disp('  That gives the exact probability density for a finite record')
disp('  It is better than generating a long transient')
disp('  because that remains an approximation for AR processes')

disp(' ')
disp('  Every time this demo runs, new sequences of random numbers are generated.')

n_obs=1000; %number of observations
data=simuarma(ar_true,ma_true,n_obs);

% Selection of model type AR, MA or ARMA, and model order
% -------------------------------------------------------

disp(' ')
disp('  A time series model is automatically estimated and selected from the data')
disp('  using:')
disp(' ')
disp('[ar_est ma_est sellog] = armasel(data);')
disp(' ')
disp('  Please wait ...')
pause(1)
disp(' ')

[ar_est ma_est sellog] = armasel(data);

disp('  The estimated AR parameters are,')
ar_est
disp('  and the estimated MA parameters are,')
ma_est
disp('  The structure variable ''sellog'' provides additional information on the')
disp('  selection process.')
sellog
disp('  The field ''comp_time'' shows the overall computing time, which is:')
disp(' ')
disp(['  ****   ' num2str(sellog.comp_time) ' seconds   ****'])
disp(' ')
disp('  Information on the preselection stage, where AR, MA and ARMA models are')
disp('  selected, is nested in the fields ''ar'', ''ma'' and  ''arma'' of ''sellog''.')
disp('  For example, showing this information concerning the selection of an')
disp('  optimal AR-model from the data results in,')
disp(' ')
disp('sellog.ar =')
disp(' ')
disp(sellog.ar)
disp(' ')
disp('  and retrieving the estimated AR parameter vector provides,')
disp(' ')
disp('sellog.ar.ar =')
disp(' ')
disp(sellog.ar.ar)
disp(' ')

% This example demonstrates how to limit computing time if some knowledge is 
% present about the data to be analyzed.
disp('  For this simple process, the same final selection result can be obtained')
disp('  using a limited set of AR, MA and ARMA models as possible candidates for')
disp('  selection. For example, let us limit the maximum order models to AR(100),')
disp('  MA(20) and ARMA(10,9). To do this we use,')
disp(' ')
disp('[ar_alt ma_alt sellog_alt] = armasel(y,0:100,0:20,0:10);')
disp(' ')
disp('  since candidate orders are optional input arguments for ''armasel''.') 
disp(' ')

[ar_alt ma_alt sellog_alt]=armasel(data,0:100,0:20,0:10);

disp('  The estimated parameters and the computing time can be compared with the')
disp('  previous results. The estimated AR parameters are,')
ar_alt
disp('  and the estimated MA parameters are,')
ma_alt
disp('  The computing time is now reduced to:')
disp(' ')
disp(['  ****   ' num2str(sellog_alt.comp_time) ' seconds   ****'])

% Assessing the accuracy of the estimated model
% ---------------------------------------------

disp(' ')
disp('  The model error ME is a measure for the accuracy of the estimated model.')
disp('  The ME measures the difference between the estimated model and the true')
disp('  process by,')
disp(' ')
disp('ME = moderr(ar_est,ma_est,ar_true,ma_true,n_obs);')
disp(' ')
disp('  which results in,')
disp(' ')

ME=moderr(ar_est,ma_est,ar_true,ma_true,n_obs)

disp('  The theoretical asymptotic expectation of the ME is equal to the number of ')
disp([' parameters in the model, which equals ' ...
      num2str(length(ar_true)+length(ma_true)-2) ' in this example.'])

disp(' ')
disp('  The model error ME can also be used to measure the distance between ')
disp('  two arbitrary estimated models. Here the difference between the selected ')
disp('  ARMA and AR models from the same data is shown.')
disp(' ')
disp('ME_dif_ARMA_AR = moderr(sellog.arma.ar,sellog.arma.ma,sellog.ar.ar,1,n_obs);')
disp(' ')
ME_dif_ARMA_AR = moderr(sellog.arma.ar,sellog.arma.ma,sellog.ar.ar,1,n_obs)

% Computation of autocorrelations and power spectral density of data
% ------------------------------------------------------------------

disp(' ')
disp('  The Power Spectral Densities of true and estimated models will now be')
disp('  compared. To plot the spectrum of the true process,')
disp(' ')
disp('arma2psd(ar_true,ma_true);')
disp(' ')
disp('  is invoked without output arguments.')
disp(' ')

hold off
figure(1)
arma2psd(ar_true,ma_true);

disp(' ')
disp('  After turning on the hold status, a second graph can be plotted in the')
disp('  figure using ''arma2psd'', while line colors are automatically varied.')
disp(' ')

hold

disp(' ')
disp('  The spectrum of the estimated model is added to the figure using,')
disp(' ')
disp('arma2psd(ar_est,ma_est);')

arma2psd(ar_est,ma_est);
handles = get(gca,'children');
handles = [handles(6);handles(3)];
legend(handles,'true','estimated',3);
title('True and estimated Power Spectral Density ( log-scale )')
hold off;

disp(' ')
disp('  In addition, 50 values of the estimated autocorrelation function and 129')
disp('  values of the estimated power spectral density are determined numerically')
disp('  with,')
disp(' ')
disp('psd_est = arma2psd(ar_est,ma_est);')
disp('cor_est = arma2cor(ar_est,ma_est,50);')
disp(' ')
disp('  The same is done for the parameter vectors of the true process.') 

% Computation of Power Spectral Density
% Use the default number of 129 frequencies for evaluation of Power Spectral Density
[psd_true frequencies]=arma2psd(ar_true,ma_true);
psd_est=arma2psd(ar_est,ma_est);
% Computation of 50 autocorrelations
cor_est=arma2cor(ar_est,ma_est,50);
[cor_true]=arma2cor(ar_true,ma_true,50);

disp(' ')
disp('  The results of the experiment are displayed in four figures:')
disp(' ')
disp('  Figure 1 shows the true spectrum and the estimated time series spectrum.')
disp('  Figure 2 shows the true and the estimated autocorrelations.')
disp('  Figure 3 shows estimated accuracies of all estimated models.')
disp('  Figure 4 compares the raw periodogram with the time series spectrum.')

corLP=convolrev(data,50);
figure(2)
plot(0:50,cor_true,0:50,cor_est,0:50,corLP/corLP(1))
title('True and estimated autocorrelation functions')
xlabel('\rightarrow time shift')
ylabel('\rightarrow normalized autocorrelation')
legend('true','estimated with time series model','estimated with lagged products')

figure(3)
plot(sellog.ar.cand_order,sellog.ar.pe_est)
title('Estimated model accuracy as a function of the model order and type')
xlabel('\rightarrow model order r')
ylabel('\rightarrow normalized model accuracy')
asnew=axis;
asnew(3)=0.9*min(sellog.ar.pe_est);
asnew(4)=1.1*sellog.ar.pe_est(end);
axis(asnew)
hold on
plot(sellog.arma.cand_ar_order,sellog.arma.pe_est,'g')
plot(sellog.ma.cand_order,sellog.ma.pe_est,'r')
legend('AR(r)','ARMA(r,r-1)','MA(r)',4)
hold off

% comparison with raw periodogram
periodogram=abs(fft(data).^2);
periodogram=periodogram/std(data).^2/n_obs;

figure(4)
clf
subplot(121)
semilogy(frequencies,psd_true,[0:1:n_obs/2]/n_obs,periodogram(1:n_obs/2+1),'g')
as=axis;
as(2)=.5;
axis(as);
set(gca,'xtick',[0 0.1 0.2 0.3 0.4 0.5]);
legend('true','periodogram',3)
title('Raw periodogram ')
xlabel('\rightarrow normalized frequency')
ylabel ('\rightarrow logarithmic power spectral density')
subplot(122)
semilogy(frequencies,psd_true,frequencies,psd_est)
axis(as);
set(gca,'xtick',[0 0.1 0.2 0.3 0.4 0.5]);
legend('true','time series estimate',3)
title('Time series estimate')
xlabel('\rightarrow normalized frequency')

eval(warn_recov_comm);
clear('handles','as','warn_state','warn_recov_comm','ans')
who

disp('==============================================================================')
disp('=                           End of DEMO_ARMASA                               =')
disp('==============================================================================')

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2001 3 14 22 5 14]    P.M.T. Broersen        p.broersen@xs4all.nl
% [2003 4  2 15 0  0]    W.Wunderink            
