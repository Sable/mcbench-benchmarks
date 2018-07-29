function [x_nn, Tres] = nnresample(ti, xi, Tres_ratio)
%
% Author P.M.T. Broersen,  November 2008
%
% NN or nearest neighbor resampling of irregularly sampled data.
% Replaces irregularly sampled data by an equidistant signal.
%
% ti         : irregular data times [s]
% xi         : irregular data
% Tres_ratio : N / Nout (of resampled signal) ~ Tres / T_0 
% Tres       : resampling time distance ~ T_0 * Tres_ratio [s]
% x_nn       : equidistantly resampled signal 
% 
% T0         : mean time distance between data of input signal [s]
% f0         : 1/T0 or mean data rate [Hz]
% 
% For random observation instants with Poisson distribution,
% the Power Spectral Density PSD after NN resampling
% will mostly be acceptable close to the true PSD if dt_ratio > pi.
% The filter error in the spectrum is about 50 % for f = f0/2pi Hz.
% The filter error is about 10 % for f = f0/20.
% The spectrum is filtered and has additive white noise. 
% Filtering reduces the spectrum and noise gives an increase. Hence those two
% effects of NN resampling counteract.
%
% A safe choice for accurate spectra over the whole discrete-time
% frequency range is Tres_ratio is 10.
% Distorted but recognizible spectra are found with Tres_ratio is 2.
% Peaks in the spectrum can be found until about Tres_ratio is 1, or even higher.
% PSD in higher frequency ranges can better be estimated with ARMAsel_irreg.

N    = length(ti);
Nout = round( N / Tres_ratio)
Tres = (ti(N) - ti(1)) / (Nout - 1);
x_nn = zeros(1,Nout);
ti   = ti - ti(1);

% initialize
t = 0;
j = 2;

for i = 1 : Nout
    while ((t > ti(j)) & (j < N))
        j = j + 1;
    end
    % Look for nearest ti
    if (abs((ti(j) - t)) < abs(ti(j-1) - t))
        x_nn(i) = xi(j);
    elseif (abs((ti(j) - t)) > abs(ti(j-1) - t))
        x_nn(i) = xi(j-1);
    elseif (abs((ti(j) - t)) == abs(ti(j-1) - t))
    % If same distance to grid, 50 % for each possibility
        rn = round(rand(1));
        if (rn == 1)
            x_nn(i) = xi(j);
        else
            x_nn(i) = xi(j-1);
        end
    end
    t = t + Tres;
end
