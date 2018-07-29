function W = mywigner(Ex)
%MYWIGNER: Calculates the Wigner distribution from a column vector
%
%	W  = mywigner(Ex)
%
%	W  = output Wigner distribution
%	Ex = Input electric field (MUST be a column vector
%
%	Notes:
%		W = Int(-inf..inf){E(x+y)E(x-y)exp[2ixy]}
%
%		E(x+y) & E(x-y) are calculated via a FFT (fast Fourier transform) using the
%		shift theorem. The integration is performed via a FFT. Thus it is important
%		for the data to satisfy the sampling theorem:
%		dy = 2*pi/X			X = span of all x-values	dy = y resolution
%		dx = 2*pi/Y			Y = span of all y-values	dx = x resolution
%		The data must be completely contained within the range x(0)..x(N-1) &
%		y(0)..y(N-1) (i.e. the function must fall to zero within this range).
%
%	v1.0
%
%	Currently waiting for update:
%		Remove the fft/ifft by performing this inside the last function calls
%		Allow an arbitrary output resolution
%		Allow an input vector for x (and possibly y).

if (size(Ex, 2)-1)
    error('E(x) must be a column vector');
end

N = length(Ex);														%   Get length of vector
x = ifftshift(((0:N-1)'-N/2)*2*pi/(N-1));							%   Generate linear vector
X = (0:N-1)-N/2;
EX1 = ifft( (fft(Ex)*ones(1,N)).*exp( i*x*X/2 ));					%   +ve shift
EX2 = ifft( (fft(Ex)*ones(1,N)).*exp( -i*x*X/2 ));					%   -ve shift
W = real(fftshift(fft(fftshift(EX1.*conj(EX2), 2), [], 2), 2));		%   Wigner function