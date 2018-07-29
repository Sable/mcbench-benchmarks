function [filtered_outpt] = coax_simulator(Samples,rate,t,f,inpt,Zr, ...
    L,b,a,Ur,Er,cond,var_coax,T0,cutoff,ord_but,considerBeta)

format long;

%% ########################### Input Signal ############################
INPT=fftshift(fft(inpt));  

%% ########################## Coaxial Cable ############################
H  = coaxTF(f,Zr,L,b,a,Ur,Er,cond,considerBeta);
FRESH_OUTPT = INPT.*H;
fresh_outpt = real(ifft(ifftshift(FRESH_OUTPT)));

%% #################### Noise from Coaxial Cable #######################
AWGNoise = sqrt(var_coax)*randn(size(t));
noisy_out = fresh_outpt + AWGNoise;

%% ########################### Low Pass Filter #########################
    filtrTF = buttLPF(f,cutoff,ord_but);                %Butterworth LPF


%% ##################### Thermal Noise of receiver #####################
k = 1.38e-23;   % Boltzmann's Const. (W/K-Hz)
noise_SD = sqrt(k*T0*cutoff*Zr);
noise_variance = noise_SD^2;
thermal_noise = noise_SD*randn(size(t));
outpt = noisy_out + thermal_noise;

%% ##################### Output Calculation ############################
OUTPT = fftshift(fft(outpt));
FILTERED_OUTPT = OUTPT.*filtrTF;
filtered_outpt = real(ifft(ifftshift(FILTERED_OUTPT)));