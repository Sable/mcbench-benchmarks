function s_inv = compute_inverse_filter(s,f1,f2,fs,opt)

%--------------------------------------------------------------------------
%
%       s_invs = compute_inverse_filter(s,f1,f2,fs,opt)
%
% This function computes the inverse filter corresponding to the
% exponential sweep sine s.
%
% Inputs:
%   s : Original exponential sweep sine
%   f1 : Starting frequency of the sweep
%   f2 : End frequency of the sweep
%   fs : Sampling frequency
%   opt : Filter option (string expected). By default 'TFB_linear' is
%   chosen.
%       - 'TFB_square': FTT based filter with a square window and
%         regularization (see [1])
%       - 'TFB_linear': FTT based filter with a square window with continuous
%         linear borders and regularization (see [1])
%       - 'TFB_gevrey': FTT based filter with a square window with infinitely
%         continuous gevrey borders and regularization (see [1])
%
% Outputs:
%   s_inv : Inverse filter
%
% References:
%
% [1] M. Rébillat, R. Hennequin, E. Corteel, B.F.G. Katz, "Identification
% of cascade of Hammerstein models for the description of non-linearities
% in vibrating devices", Journal of Sound and Vibration, Volume 330, Issue
% 5, Pages 1018-1038, February 2011.
%
%
% Marc Rébillat & Romain Hennequin - 02/2011
% marc.rebillat@limsi.fr / romain.hennequin@telecom-paristech.fr
%
%--------------------------------------------------------------------------

if nargin<5
    opt = 'TFB_linear' ;
end


% Fourier transform of the signal
tf = fft(s);
Nfft = length(s);
w1 = f1/fs*2*pi;
w2 = f2/fs*2*pi;

% Keeping only positive frequencies (real valued signal)
tf = tf(1:floor(Nfft/2)+1);

% Index of bounds of the frequency range
n1 = ceil(w1/(pi)*(Nfft/2+1));
n2 = floor(w2/(pi)*(Nfft/2+1));

% Margin for epsilon (can be changed)
alpha =1.1;
margin1 = round(alpha*n1);
margin2 = round(n2/alpha);

% Safety function: epsilon
if strcmp(opt,'TFB_square')
    epsilon = ones(size(tf));
    epsilon(n1:n2) = 0;
elseif strcmp(opt,'TFB_linear')
    epsilon = ones(size(tf));
    epsilon(n1:n2) = 0;
    epsilon(n1:margin1) = (1:-1/(margin1-n1):0);
    epsilon(margin2:n2) = (0:1/(n2-margin2):1);
elseif strcmp(opt,'TFB_gevrey')
    epsilon = gene_gevrey(w1/(2*pi)*fs,w2/(2*pi)*fs,alpha,fs,length(tf));
end

% Regularisation
weight = sum(abs(tf).^2) ;
epsilon = epsilon.*weight;

% Computation of the Fourier transform of the inverse
tfinv = conj(tf)./(abs(tf).^2+epsilon);

% Computation of the inverse
if mod(Nfft,2) == 0
    s_inv = real(ifft([tfinv, conj(tfinv(end-1:-1:2))]));
else
    s_inv = real(ifft([tfinv, conj(tfinv(end:-1:2))]));
end


function epsilon = gene_gevrey(fb,fh,trans,fs,Nfft)
%--------------------------------------------------------------------------
%
% [epsilon] = gene_gevrey(fb,fh,trans,fs,Nfft)
%
% Generattion of epsilon using a Gevrey function
%
% fb = lower cut-off frequency
% fh = higher cut-off frequency
% trans = transition width in log_scale (octave, decade,...)
% fs= sampling frequency
% Nfft = number of points of the FFT
%
% Marc Rébillat & Romain Hennequin -  02/2011
%
%--------------------------------------------------------------------------

% Frequency vector
freq = (1:Nfft)/Nfft*fs ;

% Transition frequencies
n1b = ceil(fb/sqrt(trans)/fs*Nfft) ;
n1h = ceil(n1b*trans) ;
n2h = round(0.7*fh*sqrt(trans)/fs*Nfft) ;
n2b = round(n2h/trans) ;

% Plateau length
N_plateau = n2b-n1h ;

% Function generation
f_gev = [zeros(1,n1h) ones(1,N_plateau) zeros(1,Nfft-n2b)];

% Low-frequencies transition
f_gev(n1b:n1h) = 0.5*( 1 + tanh(-1./((n1b:n1h)/n1h-(n1b-1)/n1h)+1./((n1h+1)/n1h-(n1b:n1h)/n1h))) ;

% High-frequencies transition
f_gev_droit = 0.5*( 1 + tanh(-1./((n2b:n2h)/n2h-(n2b-1)/n2h)+1./((n2h+1)/n2h-(n2b:n2h)/n2h))) ;
f_gev(n2b:n2h) = f_gev_droit(end:-1:1) ;

% Espilon
epsilon = 1-f_gev ;



