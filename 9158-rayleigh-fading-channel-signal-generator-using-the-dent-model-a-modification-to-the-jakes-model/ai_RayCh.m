% 
%
% Rayleigh Fading Channel Signal Generator 
% Using the Dent Model (a modification to the Jakes Model)
%
% Last Modified 10/18/05
%
% Author: Avetis Ioannisyan (avetis@60ateight.com)
%
%
% Usage:
% [omega_mTau, Tk] = 
% ai_RayCh(NumAngles, Length, SymbolRate, NumWaveforms, CarrierFreq, Velocity)
%
% Where the output omega_mTau is a time scaling factor for plotting
% normalized correlations. The LAGS value output by [C,LAGS] = XCORR(...)
% should be multiplied by the omega_mTau scaling factor to properly display
% axis. Tk is a two dimensional vector [M, N] = SIZE(Tk) with
% M=numWaverorms and N=Length specified in the RayCh(...) function call
%
% And the input variables are:
%
% NumAngles - scalar power of 2, NumAngles > 2^7 is used to specify the
% number of equally strong rays arriving at the receiver. It used to
% compute the number of oscillators in the Dent model with N0 = numAngles/4
%
% Length - scalar preferably power of 2 for faster computation, Length > 2^17
% is used to specify the length of the generated sequence. Lengths near 1E6
% are close to realistic signals
% 
% SymbolRate - scalar power of 2 and is in kilo-symbols-per-sec is used to
% specify what should be the transmission data rate. Slower rates will
% provide slowly fading channels. Normal voice and soem data rates are
% 64-256 ksps
%
% NumWaveforms - scalar used to specify how many 'k' waveforms to generate
% in the model. NumWaveforms > 2 to properly display plots
% 
% CarrierFreq - scalar expressed in MHz is the carrier frequency of the
% tranmitter. Normally 800 or 1900 MHz for mobile comms
%
% Velocity - scalar expressed in km/hr is the speed of the receiver. 
% 100 km/hr = 65 mi/hr. Normal values are 20-130 km/hr
% 
% Usage Examples:
% [omega_mTau, Tk] = ai_RayCh(2^7, 2^18, 64, 2, 900, 100)
% 
% where
%
% NumAngles=2^7, Length=2^18, symbolRate=64, NumWaveforms=2, carrierFreq=900, Velocity=100
% [omega_mTau, Tk] = RayCh(NumAngles, Length, symbolRate, NumWaveforms,
% carrierFreq, Velocity);
%
%


function [omega_mTau, Tk] = ai_RayCh(NumAngles, Length, symbolRate, NumWaveforms, carrierFreq, Velocity)

% Number of oscillators
N0 = NumAngles/4;
% Maximum Doppler shift of carrier at some wavelength
omega_m = (2*pi) * fm(Velocity, carrierFreq);
% specify variance of the Rayleigh channel
% use this for *constant* variange - requires changing other params in prog
sigma2 = 10;
% make sigma2 a gaussian RV around u = sigma2 and var = sigma2/5
% use for *non constant* variaance - requires changing other params in prog
sigma2 = sigma2 + sqrt(sigma2/5) .* randn(1,NumWaveforms);
% Initialize phases
alpha_n = []; beta_n = []; theta_nk = []; 
% make a hadamard matrix
Ak = hadamard(N0);
% determine phase values 'alpha' and 'beta'
n=[1:N0];
alpha_n = 2*pi*n/NumAngles - pi/NumAngles;
beta_n = pi*n/N0;

% convert to time scale using 'fs' sampling frequency
t=[1/(symbolRate*1000):1/(symbolRate*1000):1/(symbolRate*1000) * Length];

Tk = [];
for q = 1 : NumWaveforms

    rand('state',sum(100*clock))                % reset randomizer
    theta_nk = rand(1,length(n)) * 2 *pi;       % create uniform random phase in range [0,2pi]

    sumRes = 0;
	for i = 1 : N0
        term1 = Ak(NumWaveforms,i);
        term2 = cos(beta_n(i)) + j*sin(beta_n(i));
        term3 = cos(omega_m .* t .* cos(alpha_n(i)) + theta_nk(i));
        sumRes = sumRes + (term1 .* term2 .* term3);
	end
    
    Tk(q,:) = sqrt(2/N0) .* sumRes;
    % use line below to apply *non-constant* variance 
    Tk(q,:) = repmat(10.^(sigma2(q)/20),1, Length) .* Tk(q,:); %apply variable in dB 

end

% apply *constant* variance unilaterly in dB 
% Tk = repmat(10^(sigma2/20), k, Length) .* Tk; 


% plot results
figure(20); subplot(3,1,1); semilogy(t,abs(Tk(1,:)));
xlabel('Time (sec)'); ylabel('Signal Strength (dB)'); 
title(['Received Envelope, Symbol Rate = ', num2str(symbolRate), ',Carrier = ', num2str(carrierFreq), ', Velocity = ', num2str(Velocity)]);
% compute auto and cross correlations and plot them
omega_mTau = (1/(symbolRate*1000)) * (omega_m/(2*pi));    % compute omega_m * tau scaling
[C1, Lags] = crosscorr(Tk(1,:), Tk(2,:), 20000);
[C2, Lags2] = autocorr(Tk(1,:),  20000);
figure(20); subplot(3,1,3); plot(Lags * omega_mTau, C1);
xlabel('Normalized Time Delay'); ylabel('Normalized Crosscorrelation'); 
title('Crosscorrelation between waveforms k=1 and k=2');
figure(20); subplot(3,1,2); plot(Lags2 * omega_mTau, C2);
xlabel('Normalized Time Delay'); ylabel('Normalized Autocorrelation'); 
title('Autocorrelation of the first waveform k=1');




