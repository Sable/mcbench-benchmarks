function [Pt, Gt] = svdexFROG(Field)
%svdexFROG: Extracts the pulse and gate as functions of time from the FROG
%   FIELD (i.e. complex amplitude) via a SVD.
%
%Usage:
%
%   [Pt, Gt]    =   exFROG(Complex Field)
%
%       Pt      =   Pulse field (in time)
%       Gt      =   Gate field (in time)
%       Field   =   Input FROG field.

%   ------------------------------------------
%   Convert FIELD to time.
%
%	See also SVDFROG, SVD, MAKEFROG
% Et = ifftshift(ifft(Field), 1);
EF = fftshift(fft(ifftshift(Field, 1), [], 1));

N = size(Field, 1);

%   Row rotation
for n=2:N
    EF(n, :) = circshift(EF(n,:), [0, (n-1)]);
end

%   Extract vectors via SVD
[U, S, V] = svd(EF);
Pt = U(:,1);
Gt = conj(V(:,1));