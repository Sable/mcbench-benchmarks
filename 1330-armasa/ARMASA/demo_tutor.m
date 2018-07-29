% program demo_tutor.m
%
% P.M.T. Broersen, July 2004
%                  June 2005 
% P.M.T. Broersen, November 2007

% see also demo_armasa for extensive example
%          demo_simple for basic example PSD and autocorrelation computation   
%
%   Background information can be found in

%   Book:
%   Piet M.T. Broersen
%   Automatic Autocorrelation and Spectral Analysis
%   Springer-Verlag,London, 2006.
%   ISBN 1-84628-328.

%   Journal paper:
%   P. M. T. Broersen, Automatic Spectral Analysis with
%   Time Series Models, IEEE Transactions on Instrumentation
%   and Measurement, Vol. 51, No. 2, April 2002, pp. 211-216.
% 
%   and many papers given in ARMASA info.txt

clc,
close all
clear all
echo on 

% Generate stationary AR en MA polynomials a and b from reflection coefficients smaller than 1
% By taking reflection coefficients between -1 and +1, stationary invertible
% models are guaranteed with all poles and zeros inside the unit circle
% Reflection coefficients are transformed into parameters with rc2arset:
%

a = rc2arset([1 .3 .3])

b = rc2arset([1 -.9])

% From reflection coefficients to parameters and vice versa
[dum rc] = ar2arset(a)

N = 500;   

% Generating data by starting with initial zeros is a poor idea.
% Simuarma generates N stationary data, with the asymptotical properties 
% applicable from the first observation

data = simuarma(a,b,N);

% Compute and select time series models, 
% with asel and bsel as parameters of the selected model
% Compute the accuracy of the selected model type and the best alternative
% model types and put them in sellog
 
[asel bsel sellog] = armasel(data)
 
% Compute the accuracy of the estimated model in comparison with 
% the true process with the parameters a and b

ME = moderr(asel,bsel,a,b,N)

% Compute and plot the autocorrelation functions and spectra of the
% generating true model and the ARMAsel selected model.
% gain is the power gain or the ratio between output and input variance of ARMA process
% The length of the correlation function is chosen as 50.
%
[cortrue gain] = arma2cor(a,b,50);
corsel = arma2cor(asel,bsel,50);
[psdtrue fas] = arma2psd(a,b);
psdsel = arma2psd(asel,bsel); 

echo off

figure(1),
plot(data),
xlabel('\rightarrow time axis [s]')
title([int2str(N),' ARMA(2,1) observations'])

figure(2),
plot(0:50,cortrue,0:50,corsel,'r')
title('True and estimated autocorrelation function')
xlabel('\rightarrow time lag [s]')
legend('true','estimated')

figure(3),
subplot(121),
plot(fas,psdtrue,fas,psdsel,'r')
title('True and estimated spectrum')
xlabel('\rightarrow normalized frequency \it{f/f_s}'),
legend('true','estimated',2)
ylabel('Lineair scale for PSD'),
axis tight
subplot(122),
semilogy(fas,psdtrue,fas,psdsel,'r')
title('True and estimated spectrum')
xlabel('\rightarrow normalized frequency \it{f/f_s}'),
legend('true','estimated',4)
ylabel('Log scale for PSD'),
axis tight, 
subplot,

figure(4),
echo on

% The spectra on a linear scale are hardly to discern for high frequencies.
% That improves with a logaritmic scale.
% The frequency axis is between 0 and fs/2, where fs is the sampling frequency.
% Very often, fs is taken as 1 without mentioning it.
%
% Investigate the accuracy as estimated by ARMAsel for all models
% That accuracy is stored in sellog in pe_est files
% The accuracy of all models can be interpreted as the language of random data
%
% This example demonstrates how axis can be generated automatically for a
% properly scaled plot of the prediction errors
%
plot(sellog.ar.cand_order,sellog.ar.pe_est)
title('Estimated model accuracies as a function of model order and type')
xlabel('\rightarrow model order \itr')
ylabel('\rightarrow normalized model accuracy')
minar=min(sellog.ar.pe_est); 
as2=axis; 
as2(3)=.9*minar; 
as2(4)=sellog.ar.pe_est(end);
axis(as2);
hold on, 
plot(sellog.ma.cand_order,sellog.ma.pe_est,'r')
plot(sellog.arma.cand_ar_order,sellog.arma.pe_est,'g')
legend('AR(\itr\rm)','MA(\itr\rm)','ARMA(\itr,r\rm-1)',4), 
hold off,   

% A similar result in one line can be obtained with plotpe(sellog),
% where sellog is the third output argument of armasel

plotpe(sellog)

% Retrieve the reflection coefficients of the longest AR model that has been used in ARMAsel
% The longest AR model is allways saved as ASAglob_rc!!
%
% Recent versions of ARMASA (after 2008) save that model additionally as sellog.ar.rcarlong
%
rcarlong = ASAglobretr('ASAglob_rc');

% Determine the highest AR order that has been estimated with ARMAsel. 
% Transform reflection coefficients rcarlong into a parameter vector.
% Plot spectrum (PSD) and autocorrelation function of selected and of long model.
%
% The correlation function and the PSD of the long model arlong
% are very irregular.
% Selection of the model order and type gives results with only
% statisatically significant details included.
%
maximum_order = length(rcarlong)-1
arlong = rc2arset(rcarlong);   
corlang = arma2cor(arlong,1,50);
psdlang = arma2psd(arlong,1); echo off

% In arma2cor and arma2psd, 1 is used as the second parameter vector. 
% That is the MA vector for true AR processes.
% The programs expect both an AR and a MA parameter vector.
% The first element of the parameter vector must always be 1.
% That can be the only parameter of the vector.

figure,
plot(0:50,cortrue,0:50,corsel,0:50,corlang)
title('True and estimated autocorrelation function')
xlabel('\rightarrow time lag [s]'),
legend('true','estimated','ARlong')

% Linear and logarithmic spectra of the same data demonstrate a strong 
% preference for logarithmic plots of the PSD (power spectral density)

figure,
subplot(121),
plot(fas,psdtrue,fas,psdsel,fas,psdlang)
title('True and estimated spectrum')
xlabel('\rightarrow normalized frequency \it{f/f_s}'),
legend('true','estimated','ARlong',2)
ylabel('Linear scale for PSD'),
axis tight
subplot(122),
semilogy(fas,psdtrue,fas,psdsel,fas,psdlang)
title('True and estimated spectrum')
xlabel('\rightarrow normalized frequency \it{f/f_s}'),
legend('true','estimated','ARlong',4)
ylabel('Log scale for PSD'),
axis tight, 
subplot 

echo on

% Demo of variation of input variables for candidate orders
% Computation of models with prescribed type and order
%
echo off
disp('AR(10) with ar10 = armasel(data,10,0,0)')
ar10 = armasel(data,10,0,0),           % AR(10)
disp(' ')
disp('AR selected from orders between 2 and 20 with arselect= armasel(data,2:20,0,0)')
arselect = armasel(data,2:20,0,0),    % AR(selected between candidate orders 2 and 20)
disp(' ')
disp('AR(10) with ar10fromarlong = rc2arset(rcarlong,10)')
ar10fromarlong = rc2arset(rcarlong,10) % AR(10) computed with first 10 reflection coefficients
disp(' ')
disp('MA(6) model with ma6 = armasel(data,0,6,0)')
[dummy ma6] = armasel(data,0,6,0),     % MA(6)
disp(' ')
disp('ARMA(2,1) model with  armasel(data,0,0,2)')
[ar2 ma1] = armasel(data,0,0,2),       % ARMA(2,1)  
disp(' ')
disp('ARMA(4,3) model with  armasel(data,0,0,4)')
[ar4 ma3] = armasel(data,0,0,4),       % ARMA(4,3)
disp(' ')
disp('Selection between candisdates AR(2), MA(3) and ARMA(5,4) with  armasel(data,2,3,5)')
[arx brx] = armasel(data,2,3,5)        % selects between the candidates AR(2), MA(3) and ARMA(5,4) 
disp(' ')

% Accuracy of these models and of the selected model

disp(['ARMAsel selected from all candidates for N = ',int2str(N),' observations: ARMA(', ...
    int2str(length(asel)-1),',',int2str(length(bsel)-1),')']) 
ME_selected = moderr(asel,bsel,a,b,N)
ME_ar10 = moderr(ar10,1,a,b,N)
ME_ma6 = moderr(1,ma6,a,b,N)
ME_arma21 = moderr(ar2,ma1,a,b,N)
ME_arma43 = moderr(ar4,ma3,a,b,N)
ME_arlong = moderr(arlong,1,a,b,N)

echo on,

% Prediction of the observations after the data with the selected model with arma2pred 
% Lpred is the prediction horizon
% Normalizing the accuracy with the power gain
% Take care because the mean has been subtracted automatically, 
% it should be added again for a correct prediction of the future 
% pred_acc is the variance of the predictions
% asel and bsel have been found before with armasel in line 35
%
Lpred = 15
[pred pred_acc] = arma2pred(asel,bsel,data,Lpred);
[corsel gainsel]= arma2cor(asel,bsel)
pred_acc = pred_acc*std(data)^2/gainsel; echo off

figure, 
plot(0:Lpred,[data(end) pred+mean(data)],'r*',1:Lpred, ...
    pred+1.96*sqrt(pred_acc)+mean(data),1:Lpred,pred-1.96*sqrt(pred_acc)+mean(data))
title('Prediction for \it{t > N} \rmof continuation of data \it{x_n}\rm , with 95 % confidence interval')
xlabel('\rightarrow Prediction starting with the last observation \it{x_N} \rmof the data') 

echo on,

%
% Using reduced statistics 
%
% REDUCED STATISTICS REDUCED STATISTICS REDUCED STATISTICS REDUCED STATISTICS
%_____________________________________________________________________________
%
% Computes the best model for the data if only a long AR model is available
% and the sample size N of the observations that were used to compute the long AR model 
% Generally, there is a only small difference between ARMA models estimated from data and 
% ARMA models estimated with reduced statistics.
% 
%
% S. de Waele 
% Automatic Spectral Analysis,
% This and more extensions of ARMASA can be found under 
% spectral analysis at the download address
% http: www.mathworks.com/matlabcentral/fileexchange/

% Also programs for equidistant data where some data are missing can be
% found and programs for irregular data, all at various places in 
% http: www.mathworks.com/matlabcentral/fileexchange/
% by the authors Piet Broersen and Stijn de Waele
%
% An error message can be found if the additional software is not down loaded
%
echo off

try
    disp('The model selected from armasel applied to the data was')
    asel
    bsel
    disp(' ')
    disp('    [asel_rs bsel_rs sellog_rs] = armasel_rs(arlong,N)  gives:')
    disp(' ')
    [asel_rs bsel_rs sellog_rs] = armasel_rs(arlong,N)
    disp(' ')
    disp('   The accuracy of the selected reduced statistics model')
    ME_rs = moderr(asel_rs,bsel_rs,a,b,N)
    disp(' ')
    disp('  The difference between the selected data model and the reduced statistics model')
    ME_dif = moderr(asel_rs,bsel_rs,asel,bsel,N)

    disp(' ')
    disp(' Computation of the ARMA(3,2) model with the reduced statistics algorithm')
    disp(' ')
    [a_rs b_rs sellog32_rs] = armasel_rs(arlong,N,0,0:1,3) %ARMA(3,2)
    disp(' ')
    disp('   The accuracy of the ARMA(3,2) model')
    ME_arma32_rs = moderr(a_rs,b_rs,a,b,N)

    % some care is required for giving a fixed MA or ARMA order in armasel_rs
    % using only candidate order 0 might give error messages
    % the example shows how those messages are suppressed
catch
    disp(' The program armasel_rs requires additional software of Stijn de Waele')
    disp(' Automatic Spectral Analysis')
    disp(' This can be found under spectral analysis at the download address')
    disp(' http: www.mathworks.com/matlabcentral/fileexchange/')
end



