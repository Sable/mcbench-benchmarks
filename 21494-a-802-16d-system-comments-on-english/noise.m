function noise_channel = noise(symbolRx,SNR,n_mod_type,encode,rate,G);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                      %
%%      Name: noise.m                                                   %
%%                                                                      %
%%      This function generates and adds the Gaussian noise,            %
%%      considering what modulation and signal-to-noise ratio           %
%%      we are working with.                                            %
%%                                                                      %
%%      Gives back the vector entered with noise added.                 %
%%                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Considering encoded or not, different Eb must be chosen.
if encode == 1
    Eb = 1;
elseif encode == 0
    Eb = rate;
end

% Calculation of the variance of the noise.
sigma = (Eb*10^(-SNR/10)) / n_mod_type / 2;

% Finally, the noise to be added is calculated.
noise_channel = sqrt(sigma)*(randn(1,length(symbolRx)) + j*randn(1,length(symbolRx)));
