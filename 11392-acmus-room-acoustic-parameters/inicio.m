%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inicio.m
%
%       [ponto,rms] = inicio(impulse)
%
%% Finds the beginning of a impulse respons according to ISO 3382
%% recommendations. The input (impulse) should be a measured impulse
%% response.
%% The output if the sample point where the impulse response begins
%% (ponto). If desired, gives the RMS value of the noise present before the
%% begin of the impulse response.

function [ponto,rms] = inicio(impulse)

maximo = find(abs(impulse) == max(abs(impulse)));
energia = (impulse/impulse(maximo(1))).^2;

aux = energia(1:maximo(1)-1);
ponto = maximo(1);
if any(aux > 0.01)
    ponto=min(find(aux > 0.01));
    aux = energia(1:ponto-1);
end

if nargout == 2
    rms = 10*log10(sum(aux)/length(aux));
end