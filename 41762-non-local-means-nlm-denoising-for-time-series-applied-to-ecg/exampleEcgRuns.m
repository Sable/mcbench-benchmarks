
% EXAMPLES of calling NLM code
% run portion of waveform 100 from Physionet database
% www.physionet.org

% Physionet citation:
%  Goldberger AL, Amaral LAN, Glass L, Hausdorff JM, 
%  Ivanov PCh, Mark RG, Mietus JE, Moody GB, Peng CK, 
%  Stanley HE. PhysioBank, PhysioToolkit, and PhysioNet: 
%  Components of a New Research Resource for Complex Physiologic 
%  Signals. Circulation 101(23):e215-e220 [Circulation Electronic 
%  2000 (June 13). PMID: 10851218; doi: 10.1161/01.CIR.101.23.e215


% Algorithm reference:
%  Brian Tracey and Eric Miller, "Nonlocal means denoising of ECG signals",  
%  IEEE Transactions on Biomedical Engineering, Vol 59, No 9, Sept
%  2012, pages 2383-2386.  

% load the data
ecg100=load('ecg100.txt');
ix=1:length(ecg100);  % vector of time samples, for plotting

% set parameters - see Tracey & Miller for a discussion
PatchHW=10;  % patch half-width; ~ size of smallest feature, in samples
P = 1000;    % neighborhood search width; wider=more computation but more
             % channces to find a similar patch

% set bandwidth for NLM - here set by an "eyeball estimate" 
lambda = 0.6*.02;

% now denoise 
[dnEcg,debugEcg]= NLM_1dDarbon(ecg100,lambda,P,PatchHW);


% now, create a signal with 10 dB SNR
[noisySig,targetNoiseSigma] = createSignalPlusNoise(ecg100,10);

% since we know sigma here, use that to set NLM bandwidth parameter
lambda=0.6*targetNoiseSigma;  

% and denoise....
dnEcg2= NLM_1dDarbon(noisySig,lambda,P,PatchHW);

%% plot results

xlim_vals = [1000 2000];

figure,
subplot(221),
plot(ix,ecg100)
xlim(xlim_vals)
title('Original ECG100 data')

subplot(223),
plot(ix,dnEcg,'r')
xlim(xlim_vals)
xlabel('Time, samples')
title('Denoised ECG100')

subplot(222),
plot(ix,noisySig)
xlim(xlim_vals)
title('ECG100 +  noise')


subplot(224),
plot(ix,dnEcg2,'r')
xlim(xlim_vals)
xlabel('Time, samples')
title('Denoised ECG100 + noise')


