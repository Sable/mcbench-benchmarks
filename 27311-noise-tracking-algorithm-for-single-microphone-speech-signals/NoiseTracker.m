function [LABDA_D,PRIOR_SNR,s_hat]=NoiseTracker(noisy_file,alphaSE)       
%function [LABDA_D,PRIOR_SNR,s_hat]=NoiseTracker(noisy_file,alphaSE)
% Implements the noisetracker described in
% J.S. Erkelens and R. Heusdens, "Tracking of nonstationary noise based on
% data-driven recursive noise power estimation", IEEE Trans. Audio,
% Speech & Lang. Proc., Vol. 16, No. 6, pp. 1112-1123, August 2008.
%
% See also:
% J.S. Erkelens and R. Heusdens, "Fast noise tracking based on recursive
% smoothing of MMSE noise power estimates", ICASSP 2008.
%
% INPUT VARIABLES:
% noisy_file : name of .wav file containing noisy speech signal.
% alphaSE : smoothing parameter in decision-directed prior SNR estimator
%           (used for enhancement).
%           0.98 is used in the papers.
%
% The Gain tables that are used are loaded below from the file
% GainTables.mat and are tabulated: the first index is the prior SNR
% parameter and the second index the posterior SNR. The parameters are
% assumed to be quantized in steps of 1 dB.
% Range_prior : range of the prior SNR parameter, e.g, [-19 40] (as used in the
% papers) means that the prior SNR parameters $\xi_{SE}$ and $\xi_{NT}$ are
% quantized between -19 dB and 40 dB in steps of 1 dB. The same range is
% used for both prior SNR parameters. Change this if you like.
% Range_post: range of the posterior SNR. In the papers [-30 40] is used,
% meaning that the gain tables G_A, G_A2, and G_D2 are matrices with
% dimensions 60-by-71, where
% G_A : Gain function for clean speech amplitude estimation.
% G_A2 : Gain function for clean speech power estimation (used in the 
%        decision-directed prior SNR estimator).
% G_D2 : Gain function for noise power estimation
%        (used in the noise tracker).
%
%
% OUTPUT VARIABLES:
% LABDA_D : matrix of noise variance estimates (for the positive DFT
% frequencies only). Each row is an estimated noise spectrum of a time
% frame. Btw, time frames are overlapping by 50%.
% PRIOR_SNR : matrix of prior SNR estimates.
% s_hat : enhanced speech (i.e., noise reduction has been applied) using
% the noise variance estimates from the tracker.
%
% Copyright 2008-2011: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 16-5-2011.

load GainTables %loads G_A G_A2 G_D2
global Rprior Rpost
% NOTE: all gain tables in 'GainTables.mat' use the same range for prior
% and posterior SNR parameters.
Rprior=Range_prior;Rpost=Range_post;
% Load the noisy signal
[noisy,Fs]=wavread(noisy_file);
% Make sure the noisy speech is a row vector.
noisy=noisy(:)';
% Min. value of prior SNR parameters 
prior_min=10^(-1.9);% -19 dB
% Smoothing factors prior SNR parameter noise tracking
alphaNT=0.98;
% Smoothing factors noise tracking
alphap=0.1;alphad=0.85;
% Framelength in samples (32 ms) rounded to an even number
N=2*round(256*Fs/16000);
alphas=alphad*ones(1,N/2+1);% frequency dependent, updated every time frame
% Threshold speech presence decision
T=4;
% speech presence probability estimate
Psp=zeros(1,N/2+1);
% speech presence binary decision
Isp=zeros(1,N/2+1);
% Length of window for minimum tracking used in the safety net (in seconds)
Tw=0.8;
% Window length, but now in number of frames.
Lmin=round((Tw*Fs-N/2)*2/N);
% Declare (smoothed) noisy power spectrum (used in safety net)
Psm=zeros(Lmin,N/2+1);
% and the corresponding smoothing factor
eta=0.1;
% Correction factor in safety net
B=1.5;
% M is number of overlapping frames that fits into the length of noisy
Nx=length(noisy);
M=floor(2*Nx/N-1);
% Initialization of enhanced signal.
s_hat=zeros(1,(M+1)*N/2);
% Create |cos|-analysis window
t=0:N-1;H=cos(t*pi/N).^2;
H=circshift(H,[0 N/2]);
H=sqrt(H);
% Rectangular synthesis window
Hsynth=H;
% Initalize noise variance (freq. bins 0 t/m fs/2)
labda_d=zeros(1,N/2+1);
% Initialize noise variance from first K frames
% (assuming there is only noise present there) 
K=8;
for k=1:K
   y=noisy((k-1)*N/2+1:(k+1)*N/2).*H;
   X=fft(y);X=X(1:N/2+1);
   labda_d=labda_d+abs(X).^2;
end
labda_d=labda_d/K;
% Initialisation first term priorSE and priorNT
X=abs(fft(noisy(1:N).*H));
X=X(1:N/2+1);
% Rprev is used in first term of priorNT as well
Rprev=abs(X);
postSNR=Rprev.^2./labda_d;
priorSE=max(postSNR-1,prior_min);
% Apply G_A2 to Rprev.^2 to get A2hat
A2hat=GainR2(G_A2,priorSE,postSNR,Rprev);
% Declaration of arrays of noise spectrum estimates and prior SNRs
LABDA_D=zeros(M,N/2+1);
PRIOR_SNR=LABDA_D;
% Process all the frames
for k=1:M
   y=noisy((k-1)*N/2+1:(k+1)*N/2).*H;
   X=fft(y);X=X(1:N/2+1);
   % Compute noisy amplitude and phase
   R=abs(X);theta=angle(X);
   % Update window with smoothed noisy spectrum values
   Psm=UpdatePsm(Psm,R,eta);
   % compute posterior SNR
   postSNR=R.^2./labda_d;
   % -1 correction in second term priorSE
   post_1=postSNR-1;
   priorNT=max(alphaNT*(Rprev.^2)./labda_d+(1-alphaNT)*postSNR,prior_min);
   priorSE=max(alphaSE*A2hat./labda_d+(1-alphaSE)*post_1,prior_min);
   % calculate A2hat
   A2hat=GainR2(G_A2,priorSE,postSNR,R);
   % Update noise variance estimate
   % Compute noise power estimate
   D2hat=GainR2(G_D2,priorNT,postSNR,R);
   Pmin=min(Psm);
   % Smoothing the posterior SNR over 3 neigboring frequency bins
   Mpost=freqsmooth(postSNR,1);
   % Hard decision about speech presence
   Isp=(Mpost>T);
   % Speech presence prob. esimation
   Psp=alphap.*Psp+(1-alphap).*Isp;
   % Compute the smoothing parameter
   alphas=alphad+(1-alphad).*Psp;
   labda_d=alphas.*labda_d+(1-alphas).*D2hat;
   % Safety net
   % labda_d too small?
   I=find(Pmin./labda_d>1/B);
   if ~isempty(I)
       Psp(I)=0;
       labda_d(I)=B*Pmin(I);
       D2hat(I)=max(labda_d(I),D2hat(I));
       alphas(I)=0;
       labda_d(I)=alphas(I).*labda_d(I)+(1-alphas(I)).*D2hat(I);
   end
   LABDA_D(k,:)=labda_d;
   % Recompute prior SNR and posterior SNR on the basis of the new labda_d
   % (to estimate clean speech)
   postSNR=R.^2./labda_d;post_1=postSNR-1;
   priorSE=max(alphaSE*A2hat./labda_d+(1-alphaSE)*post_1,prior_min);
   PRIOR_SNR(k,:)=priorSE;
   % Estimate clean speech amplitude
   Ahat=GainR(G_A,priorSE,postSNR,R);
   % Compute A2hat for the next time frame for the first term of priorSE
   A2hat=GainR2(G_A2,priorSE,postSNR,R);
   % Transform back to time domain and overlap-add to get estimated speech
   Fy=Ahat.*exp(i*theta);
   Fy=[Fy conj(Fy(end-1:-1:2))];
   yr=real(ifft(Fy));
   s_hat((k-1)*N/2+1:(k+1)*N/2)=s_hat((k-1)*N/2+1:(k+1)*N/2)+yr.*Hsynth;
   % Update Rprev
   Rprev=R;
end

function Amplitude=GainR(Gmatrix,priorSNR,postSNR,R)
global Rprior Rpost
% Look up gainvalue and compute Amplitude=G.*R
dBprior=10*log10(priorSNR);
dBpost=10*log10(postSNR);
Iprior=min(max(round(dBprior),Rprior(1)),Rprior(2))-Rprior(1)+1;
Ipost=min(max(round(dBpost),Rpost(1)),Rpost(2))-Rpost(1)+1;
%index=1:length(Iprior);
L=size(Gmatrix);L=L(1);
Grec=Gmatrix(Iprior+L*(Ipost-1));
Amplitude=Grec.*R;

function Amplitude2=GainR2(Gmatrix,priorSNR,postSNR,R)
global Rprior Rpost
% Look up gainvalue and compute Amplitude=G.*(R.^2)
dBprior=10*log10(priorSNR);
dBpost=10*log10(postSNR);
Iprior=min(max(round(dBprior),Rprior(1)),Rprior(2))-Rprior(1)+1;
Ipost=min(max(round(dBpost),Rpost(1)),Rpost(2))-Rpost(1)+1;
%index=1:length(Iprior);
L=size(Gmatrix);L=L(1);
Grec=Gmatrix(Iprior+L*(Ipost-1));
Amplitude2=Grec.*(R.^2);

function mx=freqsmooth(x,w)
% Smoothing over 2*w+1 neighboring frequency bins
L=length(x);mx=zeros(size(x));
for k=1:L
    i1=max(k-w,1);i2=min(k+w,L);
    mx(k)=sum(x(i1:i2))/(i2-i1+1);
end

function Psm=UpdatePsm(Psm,R,eta)
% Update the window of smoothed noisy spectral values
% Shift it
Psm(1:end-1,:)=Psm(2:end,:);
% Update last one
Psm(end,:)=eta*Psm(end-1,:)+(1-eta)*R.^2;