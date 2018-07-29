%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Smoothed nonparametric spectral estimation via cepstrum thresholding %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% function Phi = CepSpec(y,mu)
%
% y = input data vector
% mu = selected threshold (see [1] for more information)
% Phi = output spectrum
%
% This is the original implementation of the cepstrum thresholding
% technique for nonparametric estimation of smooth spectra introduced in:
%
% [1] P. Stoica and N. Sandgren. Smoothed nonparametric spectral
% estimation via cepstrum thresholding, IEEE Sign. Proc. Mag.,
% vol. 23, pp. 34-45, Nov 2006.
%
% The exchange files contains another implementation by
% Dr. S. Lutes, but according to our experience our original
% implementation has better performance.
%
% Created by Niclas Sandgren 2005-03-29 and revised 2007-02-12.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Phi = CepSpec(y,mu)
  
N = length(y);

y = y(:);

Phi_p_tmp = (abs(fft(y)).^2)./N;
c_p = ifft(log(Phi_p_tmp));
c_e = c_p;
c_e(1) = c_e(1) + 0.57721; % Euler constant
if abs(c_e(1)) < mu*pi/sqrt(3*N)
  c_e(1) = 0;
end
for k=2:N/2
  if abs(c_e(k)) < mu*pi/sqrt(6*N)
    c_e(k) = 0;
  end
end
if abs(c_e(N/2+1)) < mu*pi/sqrt(3*N)
  c_e(N/2+1) = 0;
end
for k=N/2+2:N
  if abs(c_e(k)) < mu*pi/sqrt(6*N)
    c_e(k) = 0;
  end
end
Phi_e_temp = real(exp(fft(c_e)));
alpha = sum(Phi_p_tmp.*Phi_e_temp)/sum(Phi_e_temp.^2);
Phi_e_tmp = alpha.*Phi_e_temp;
Phi = flipud([Phi_e_tmp(N/2+1:N); Phi_e_tmp(1:N/2)]);
