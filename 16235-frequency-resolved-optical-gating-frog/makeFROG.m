function [F, EF] = makeFROG(Pt, Gt)
%makeFROG: Makes a FROG trace from an input field and its gate.
%
%Usage;
%
%   [IF, EF]   = makeFROG(Pt, Gt)
%
%       IF      =   FROG trace = | FT[ P(t) .* G(t-tau); t->w ] |.^2
%       EF      =   Complex amplitude of FROG Trace
%       Pt      =   Signal field (Column vector, length N)
%       Gt      =   Gate Field (Column vector, length N)
%
%NOTE:
%	The carrier frequency is assumed to be equal to the central frequency - therefore the
%	Electric field in time should contain no linear phase term (otherwise the FROG trace
%	will alias in the frequency domain


N = length(Pt);

EF = Pt*(Gt.');

%   Row rotation
parfor (n=2:N)
	EF(n,:) = circshift(EF(n,:), [0 1-n]);
end

%   Generate FROG field & trace (= |field|^2)
EF = fftshift(ifft(ifftshift(EF), [], 1), 1);
F = abs(EF).^2;