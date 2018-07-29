function [shat, noise_psd_matrix,T]=noise_psd_tracker(noisy,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%This m-file containes an implementation of the noise PSD tracker
%%%%presented in the article: "MMSE BASED NOISE PSD TRACKING WITH LOW COMPLEXITY", by R. C.  Hendriks, R. Heusdens and J. Jensen published at the
%%%%IEEE International Conference on Acoustics, Speech and Signal
%%%%Processing, 03/2010, Dallas, TX, p.4266-4269, (2010).
%%%%Input parameters:   noisy:  noisy signal
%%%%                     fs:   sampling frequency of noisy signal
%%%%
%%%% Output parameters:  noisePowMat:  matrix with estimated noise PSD for each frame
%%%%                    shat:      estimated clean signal
%%%%                    T:      processing time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Author: Richard C. Hendriks, 15/4/2010
%%%%%%%%%%%%%%%%%%%%%%%copyright: Delft university of Technology
%%%%%%%%%%%%%%%%%%%%% update 14-11-2011: tabulatede special function to
%%%%%%%%%%%%%%%%%%%%% speed up computations.


%%


%% Initialisation
MIN_GAIN =eps;
gamma=1;
nu=0.6;
[g_dft,g_mag,g_mag2]=Tabulate_gain_functions(gamma,nu); %% tabulate the gain function used later on
%%%%%%%%%%%%%
%The tabulated gain functions compute the estimator based on the papers published in
%
%
%[1] J.S. Erkelens, R.C. Hendriks, R. Heusdens, and J. Jensen,
%"Minimum mean-square error estimation of discrete Fourier coefficients with generalized gamma priors",
%IEEE Trans. on Audio, Speech and Language Proc., vol. 15, no. 6, pp. 1741 - 1752, August 2007.
%
%[2] J.S. Erkelens, R.C. Hendriks and R. Heusdens
%"On the Estimation of Complex Speech DFT Coefficients without Assuming Independent Real and Imaginary Parts",
%IEEE Signal Processing Letters, 2008.
%
%[3] R.C. Hendriks, J.S. Erkelens and R. Heusdens
%"Comparison of complex-DFT estimators with and without the independence assumption of real and imaginary parts",
%ICASSP, 2008.

ALPHA= 0.98; %% this is the smoothing factor used in the decision directed approach
SNR_LOW_LIM=eps;
frLen  = 256*fs/8000;
fShift   = frLen/2; 
nFrames =  floor((length(noisy) - 2*frLen)/fShift );
anWin  = sqrt(hanning(frLen ));
synWin = sqrt(hanning(frLen ));
clean_est_dft_frame=[];
fft_size=frLen;
shat=zeros(size(noisy));
noise_psd   =init_noise_tracker_ideal_vad(noisy,frLen,fft_size,fShift, anWin); % This function computes the initial noise PSD estimate. It is assumed
% that the first 5 time-frames are noise-only.
min_mat=zeros(fft_size/2+1,floor(0.8*fs/fShift));
noise_psd_matrix = zeros(frLen/2+1,nFrames);
Rprior=-40:1:100;% dB
[tabel_inc_gamma ]=tab_inc_gamma(Rprior,2);
%%%%%%%%%%%%%%Algorithm
tic
for indFr=1:nFrames
    indices     = (indFr-1)*fShift+1:(indFr-1)*fShift+frLen;
    noisy_frame = anWin.*noisy(indices);
    noisyDftFrame = fft(noisy_frame,frLen);
    noisyDftFrame = noisyDftFrame(1:frLen/2+1);
    noisy_dft_frame_p=abs(noisyDftFrame).^2;
    clean_est_dft_frame_p=abs(clean_est_dft_frame).^2;
    [a_post_snr_bias,a_priori_snr_bias]=estimate_snrs_bias(noisy_dft_frame_p,fft_size ,noise_psd, SNR_LOW_LIM,  ALPHA  ,indFr,clean_est_dft_frame_p)   ;
    speech_psd=a_priori_snr_bias.*noise_psd;
    [noise_psd ]=noise_psdest_tab1(noisy_dft_frame_p, indFr, speech_psd,noise_psd,tabel_inc_gamma);
    
    
    min_mat=[min_mat(:,end-floor(0.8*fs/fShift)+2:end),noisy_dft_frame_p(1:fft_size/2+1)    ];
    noise_psd=max(noise_psd,min(min_mat,[],2));
    
    [a_post_snr,a_priori_snr   ]=estimate_snrs(noisy_dft_frame_p,fft_size, noise_psd,SNR_LOW_LIM,  ALPHA   ,indFr,clean_est_dft_frame_p)   ;
    [gain]= lookup_gain_in_table(g_mag,a_post_snr,a_priori_snr,-40:1:50,-40:1:50,1);
    gain=max(gain,MIN_GAIN);
    noise_psd_matrix(:,indFr) = noise_psd;
    clean_est_dft_frame=gain.*noisyDftFrame(1:fft_size/2+1);
    shat(indices)=shat(indices)+  synWin.*real(ifft( [clean_est_dft_frame;flipud(conj(clean_est_dft_frame(2:end-1)))]));
end
T=toc;
