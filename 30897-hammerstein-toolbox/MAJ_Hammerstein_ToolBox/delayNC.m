function y = delayNC(x,t)
%--------------------------------------------------------------------------
%
%        y = delayNC(x,t)
%
% Non integer delay (not circular)
%
% input parameters:
%       x : signal to be delayed
%       t : delay in samples (can be any real number)
% return a column vector
%
% Marc Rébillat & Romain Hennequin - 02/2011
% marc.rebillat@limsi.fr / romain.hennequin@telecom-paristech.fr
%
%--------------------------------------------------------------------------

x = x(:);

if t>=length(x)||t<=-length(x)
    y = zeros(length(x),1);
else
    ft = fft(x,2*length(x));
    ft = ft(1:length(ft)/2+1);

    ft = ft.* (exp(-1i*2*pi*t*(0:length(ft)-1)/((2*length(ft)-2)))).';
    ft = [ft ; flipud(conj(ft(2:end-1)  ))];
    y = real(ifft(ft));

    y = y(1:length(x));
end