function y = FourierShift(x, delta, zero_pad)
%
% y = FourierShift(x, delta, zero_pad)
%
% Shifts x by delta cyclically. Uses the fourier shift theorem.
%
% zero_pad is optional. If set to 'pad' then zeros will be added making the
% shift non-cyclic. The default is not to.
%
% Real inputs should give real outputs.
%
% By Tim Hutt, 24/03/2009
% Small fix thanks to Brian Krause, 11/02/2010

% Force the input to be a column vector.
x = x(:);

% The length of the vector.
N = length(x);

% The range to return. This will be different if we are zero padding.
R = 1:N;

% See if they want to add zeros to make the shift non-cyclic. Actually it
% is still cyclic but instead of seeing the back of the signal shifted in
% at the front, they see the zeros we added.
if nargin > 2 && strcmp(zero_pad, 'pad')
    % Clamp to avoid cycling. Note that there may still be some ringing at
    % the sides. Should probably use more conservative zero padding.
    delta = min(max(delta, -N), N);
    
    % New zero padded signal.
    x = [zeros(ceil(N/2), 1); x; zeros(ceil(N/2), 1)];
    
    % We want to return a different range.
    R = R + ceil(N/2);
    
    % And the length has changed.
    N = length(x);
end

% FFT of our possibly padded input signal.
X = fft(x);

% The mathsy bit. The floors take care of odd-length signals.
W = exp(-1i * 2 * pi * delta * [0:floor(N/2)-1 floor(-N/2):-1]' / N); 
if mod(N, 2) == 0
	% Force conjugate symmetry. Otherwise this frequency component has no
	% corresponding negative frequency to cancel out its imaginary part.
	W(N/2+1) = real(W(N/2+1));
end 
Y = X .* W;

% Invert the FFT.
y = ifft(Y);

% There should be no imaginary component (for real input
% signals) but due to numerical effects some remnants remain.
if isreal(x)
    y = real(y);
end

% Extract the relevant range in case we used zero padding.
y = y(R);