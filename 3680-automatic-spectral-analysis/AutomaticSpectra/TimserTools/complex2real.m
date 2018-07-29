function xr = complex2real(xc)

%COMPLEX2REAL Translates complex data into real data
%   xr = complex2real(x) translates the complex-valued data x 
%   into real-valued data xr. The real-valued signal xr has
%   the same Fourier Series as the original signal x apart from
%   a multiplication by a phase-factor. It is assumed the
%   signal x is a column vector.
%
%   For matrix-valued x, each column is translated into
%   a real-valued signal.

%  S. de Waele, February 2001.

%Reference: Modeling radar data with time series models,
%           Proc. EUSIPCO 2000, Tampere, Finland,
%           September 2000.

n_obs = size(xc,1);
if n_obs/2~=n_obs/2,
    error('Number of complex observations must be even.')
end

%Zero frequency to middle
sc = fft(xc);

nbr = floor(n_obs/2)+1;
sc = [sc(nbr:end,:); sc(1:nbr-1,:)];

%making sure FIRST value of spectrum is real
if abs(sc(1,:)),
	phaseturn = sc(1,:)./abs(sc(1,:));
	phaseturn = ones(n_obs,1)*phaseturn;
	sc = sc./phaseturn;
end

%Calculating real signal
sr = [sc(1:end,:); sc(1,:); flipud(conj(sc(2:end,:)))];
xr = real(ifft(sr));
