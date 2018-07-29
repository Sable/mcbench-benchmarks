function g = nonlinear_convolution(output_sig,duration,f1,f2,fs)

%--------------------------------------------------------------------------
%
%       g = nonlinear_convolution(output_sig,duration,f1,f2,fs)
%
% This function computes the nonlinear convolution in frequency domain.
%
% Inputs:
%   output   : The output signal of the nonlinear system (a response to the
%   Synchronized Swept Sine)
%   duration : Approximative duration of the sweep
%   f1       : Starting frequency of the sweep
%   f2       : End frequency of the sweep
%   fs       : Sampling frequency
%
% Outputs:
%   g : Product of the nonlinear convolution
%
% References:
%
% [1] E. Armelloni and others, “Non-Linear Convolution: A New Approach
% for the Auralization of Distorting Systems,” in AES 110th convention,
% Amsterdam, may 2001
%
% [2] A. Novak, L. Simon, F. Kadlec, P. Lotton, "Nonlinear system
% identification using exponential swept-sine signal", IEEE Transactions on
% Instrumentation and Measurement, Volume 59, Issue 8, Pages 2220-2229,
% August 2010.
%
% [3] M. Rébillat, R. Hennequin, E. Corteel, B.F.G. Katz, "Identification
% of cascade of Hammerstein models for the description of non-linearities
% in vibrating devices", Journal of Sound and Vibration, Volume 330, Issue
% 5, Pages 1018-1038, February 2011.
%
% Antonin Novak - 01/2012
% ant.novak@gmail.com, http://ant-novak.com
%
%--------------------------------------------------------------------------

Y = fft(output_sig,2*ceil(length(output_sig)/2))./fs; % FFT (odd number of samples)
Y = 2*Y(1:length(Y)/2+1); % taking just the 1st Nyquist zone

f_axes = linspace(0,fs/2,(length(Y))).'; % frequency axis

L = 1/f1*round( (duration*f1)/(log(f2/f1)) );
% definition of the inferse filter in spectral domain (these A.Novak (available at http://ant-novak.com), Eq.
% 4.27 for the amplitude and 2.21 for the phase)
SI = sqrt(f_axes./L).*exp(-j*(2*pi*L.*(f_axes - f1 - f_axes.*log(f_axes./f1))-pi/4));
SI(1) = 0; % DC component is ill-defined in the above equation 

G = Y.*SI;  % convolution in spectral domain
g = ifft([G; flipud(conj(G(2:end-1)))]);  % adding the 2nd Nyquiste zone
g = real(g(1:length(output_sig)));  % adjusting the number of samples to match with the output_sig





