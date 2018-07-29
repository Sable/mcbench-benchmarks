%--------------------------------------------------------------------------
%
% Estimation of the Hammerstein kernels of a simulated system using an 
% exponential sine-sweep by two different methods (see [1] and [2]).
%
% [1] M. Rébillat, R. Hennequin, E. Corteel, B.F.G. Katz, "Identification
% of cascade of Hammerstein models for the description of non-linearities 
% in vibrating devices", Journal of Sound and Vibration, Volume 330, Issue 
% 5, Pages 1018-1038, February 2011. 
%
% [2] A. Novak, L. Simon, F. Kadlec, P. Lotton, "Nonlinear system 
% identification using exponential swept-sine signal", IEEE Transactions on
% Instrumentation and Measurement, Volume 59, Issue 8, Pages 2220-2229,
% August 2010.
%
% Marc Rébillat & Romain Hennequin - 02/2011
% marc.rebillat@limsi.fr / romain.hennequin@telecom-paristech.fr
%
% Modified by Antonin Novak - 01/2012
% ant.novak@gmail.com, http://ant-novak.com
%
%--------------------------------------------------------------------------

display('-----------------------------------------------------------------')
close all
clear all

%% Parameters
display('Parameters creation ...')

% Assumed order of the system under test
N = 4;

% Sampling rate
fs = 96000;

% Lowest frequency of the sweep
f1 = 20;

% Highest frequency of the swwep
f2 = 10000;

% Provisional duration of the sweep (seconds). The exact duration is
% imposed afterwards.
duration = 10;

%% Design of the system under test (2 poles, 2 zeros ARMA)
display('Design of the system ...')

% Length of the Hammerstein kernels (in samples)
len = 1500;

% Order of the SUT (DO NOT CHANGE without changing the whole design of the SUT, fzeros, fpoles, modulusZeros... must have a length equal to "order")
order = 4;

% Frequencies (Hz) of zeros and poles of the ARMA: fzeros(1), fpoles(1) -> order 1, fzeros(2), fpoles(2) -> order 2 ...
fzeros = [150 400 1000 2200 ];
fpoles = [1500 4000 100 500 ];

% Modulus of poles and zeros of the ARMA
modulusZeros = [0.95 0.97 0.93 0.92 ];
modulusPoles = [0.97 0.95 0.95 0.92 ];

% Global gain factor for each order (globalGain(1) -> order 1...)
globalGain = [1 0.1 0.05 0.01 ];

% Computation of the kernels
h = zeros(order,len);
for k=1:order
    % Zeros of the ARMA
    zerosARMA = modulusZeros(k)*exp(1i*2*fzeros(k)/fs*pi*[-1 1]);
    % Poles of the ARMA
    polesARMA = modulusPoles(k)*exp(1i*2*fpoles(k)/fs*pi*[-1 1]);
    % Filter coefficients
    B = poly(zerosARMA);
    A = poly(polesARMA);
    % Kernels
    h(k,:) = globalGain(k)*filter(B,A,[1 zeros(1,len-1)]);
end

%% Application of the method proposed by Rébillat et al.
display('Application of the method proposed by Rébillat et al.:')

% Parameters
opt_meth = 'Reb' ;
opt_filt = 'TFB_linear' ;

% Computation of the sweep
xR = sweep(f1,f2,fs,duration,opt_meth);

% Non-linear system response
display('--> Simulation in progress ...')
yR = 0 ;
for n = 1:order
    yR = yR + convq(h(n,:),xR.^n) ;
end

% Computation of the non-linear impulse responses
hhatR = Hammerstein_ID(xR,yR,duration,f1,f2,fs,N,opt_meth,opt_filt) ;

%% Application of the method proposed by Novak et al.
display('Application of the method proposed by Novak et al.:')

% Parameters
opt_meth = 'Nov' ;
opt_filt = 'Nov' ;

% Computation of the sweep
xN = sweep(f1,f2,fs,duration,opt_meth);

% Non-linear system response
display('--> Simulation in progress...')
yN = 0 ;
for n = 1:order
    yN = yN + convq(h(n,:),xN.^n) ;
end

% Computation of the non-linear impulse responses
hhatN = Hammerstein_ID(xN,yN,duration,f1,f2,fs,N,opt_meth,opt_filt) ;

%% Plots for amplitude (in dB)
display('Plots in progress ...')

Nfft = 2^16 ;
n1 = round(f1/fs*Nfft) ;
n2 = round(f2/fs*Nfft) ;

close all

a = figure() ;
set(a,'windowstyle','docked')

for n = 1:N
    
    HO_amp = 20*log10(abs(fft(h(n,:),Nfft))) ;
    HR_amp = 20*log10(abs(fft(hhatR(n,:),Nfft))) ;
    HN_amp = 20*log10(abs(fft(hhatN(n,:),Nfft)));
    freq = (0:Nfft-1)/Nfft*fs ;
    
    subplot(N/2,2,n)
    semilogx(freq,HO_amp,'-g','linewidth',3)
    hold on
    semilogx(freq,HR_amp,'-.b','linewidth',1.5)
    semilogx(freq,HN_amp,'--r','linewidth',1.5)

    grid on
    xlim([0.75*f1 2*f2])
    Y_max = max([HO_amp(n1:n2) HR_amp(n1:n2) HN_amp(n1:n2)]);
    ylim([Y_max-70 Y_max+5])

    fontsize = 14 ;

    legend_text{1} = 'Original kernel' ;
    legend_text{2} = 'Kernel estimated from Rébillat et al.' ;
    legend_text{3} = 'Kernel estimated from Novak et al. (corrected)' ;

    legend(legend_text,'location','south')
    set(gca,'fontsize',0.6*fontsize)
    xlabel('Frequency (en Hz)','fontsize',0.8*fontsize)
    ylabel('Amplitude (en dB)','fontsize',0.8*fontsize)
    title(['Hammerstein kernel of order ' num2str(n)],'fontsize',0.8*fontsize)
    
end

display('-----------------------------------------------------------------')







   
