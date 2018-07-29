%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ldbparam.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ldbparam.m
%
%% This function evaluate several room acoustic parameters, with the signal
%% processing done by Lundeby method.
%%
%% [s]=ldbparam(IR,fs,flag)
%%
%% The input is a room impulse response and its sampling frequency. The
%% flag variable indicates if the function should generate (1) or not (0)
%% the Schroeder decay plots.
%% The output it a text file with the value of several parameter for each
%% frequency band. If desired, returns a matrix with this values, where the
%% first line contains the frequency band central frequencies, instead of
%% text.

function [saida]=ldbparam(IR,fs,flag)

banda = filtros(IR,fs);
t = size(banda,2);
for n = 1:t
    s(1,n) = ceil(1000*2^(n-5));
    comeco = inicio(banda(:,n));
    fim = lundeby(banda(comeco:end,n),fs,flag);
    title(['Ponto de Cruzamento - Banda ',num2str(s(1,n))])
    if n == t-2
        title('Ponto de Cruzamento - Compensacao A ')
    elseif n == t-1
        title('Ponto de Cruzamento - Compensacao C ')
    elseif n == t
        title('Ponto de Cruzamento - Linear ')
    end
        
    aux = banda(comeco:fim,n).^2;    
    [s(2,n),s(3,n),s(4,n),s(5,n),s(6,n)] = energeticos(aux,fs);
    [s(7,n),s(8,n),s(9,n),s(10,n)] = reverberacao(aux,fs,flag);
    title(['Curva de Decaimento - Banda ',num2str(s(1,n))])
    if n == t-2
        title('Curva de Decaimento - Compensacao A ')
    elseif n == t-1
        title('Curva de Decaimento - Compensacao C ')
    elseif n == t
        title('Curva de Decaimento - Linear ')
    end
    
end

if nargout == 1
    saida = s;
    saida(1,t-2) = (['A']);
    saida(1,t-1) = (['C']);
    saida(1,t) = (['L']);
else
    tabela(s,size(banda,2))
end