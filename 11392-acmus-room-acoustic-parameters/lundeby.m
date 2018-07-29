%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lundeby.m
%
%Implements the Lundeby method, to determine the truncation point.
%
%[ponto,C]=lundeby(IR,Fs,flag)
%
%% The input are the room impulse response and its sampling frequency. Flag
%% specifies if the results should be ploted (1) or not(0).
%% The output are the truncation point (ponto) and the correction constant
%% C, used to compensate for the truncation effects in the Schroeder plots.
%% If no output variables are given, the function prints a grafic with the
%% evaluated values.

function [ponto,C]=lundeby(varargin)

warning off

energia_impulso = varargin{1}.^2;
Fs = varargin{2};
if nargin == 3
    flag = varargin{3};
else
    flag = 0;
end


        %Calcula o nivel de ruido dos ultimos 10% do sinal, onde se assume que o ruido ja domine o sinal
rms_dB = 10*log10(mean(energia_impulso(round(.9*length(energia_impulso)):end))/max(energia_impulso));

%divide em intervalos e obtem media
t = floor(length(energia_impulso)/Fs/0.01);
v = floor(length(energia_impulso)/t);

for n=1:t
    media(n) = mean(energia_impulso((((n-1)*v)+1):(n*v)));
    eixo_tempo(n) = ceil(v/2)+((n-1)*v);
end
mediadB = 10*log10(media/max(energia_impulso));

%obtem a regressao linear o intervalo de 0dB e a media mais proxima de rms+10dB
r = max(find(mediadB > rms_dB+10));
if any (mediadB(1:r) < rms_dB+10)
    r = min(find(mediadB(1:r) < rms_dB+10));
end
if isempty(r)
    r=10
elseif r<10
    r=10;
end

[A,B] = intlinear(eixo_tempo(1:r),mediadB(1:r));
cruzamento = (rms_dB-A)/B;

if rms_dB > -20
    %Relacao sinal ruido insuficiente
    ponto=length(energia_impulso);
    if nargout==2
        C=0;
    end
else
    
    %%%%%%%%%%%%%%%%%%%%%%%%INICIA A PARTE ITERATIVA DO PROCESSO%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    erro=1;
    INTMAX=50;
    vezes=1;
    while (erro > 0.0001 & vezes <= INTMAX)
    
        %Calcula novos intervalos de tempo para media, com aproximadamente p passos por 10dB
        clear r t v n media eixo_tempo;

        p = 5;                          %numero de passos por decada
        delta = abs(10/B);              %numero de amostras para o a linha de tendencia decair 10dB
        v = floor(delta/p);             %intervalo para obtencao de media
        t = floor(length(energia_impulso(1:round(cruzamento-delta)))/v);
        if t < 2                        %numero de intervalos para obtencao da nova media no intervalo
            t=2;                        %que vai do inicio ate 10dB antes do ponto de cruzamento.
        elseif isempty(t)
            t=2;
        end
    
        for n=1:t
            media(n) = mean(energia_impulso((((n-1)*v)+1):(n*v)));
            eixo_tempo(n) = ceil(v/2)+((n-1)*v);
        end
        mediadB = 10*log10(media/max(energia_impulso));
    
        clear A B noise energia_ruido rms_dB;
        [A,B] = intlinear(eixo_tempo,mediadB);

        %nova media da energia do ruido, iniciando no ponto da linha de tendencia 10dB abaixo do cruzamento.
        noise = energia_impulso(round(cruzamento+delta):end);
        if (length(noise) < round(.1*length(energia_impulso)))
            noise = energia_impulso(round(.9*length(energia_impulso)):end); 
        end       
        rms_dB = 10*log10(mean(noise)/max(energia_impulso));

        %novo ponto de cruzamento.
        erro = abs(cruzamento - (rms_dB-A)/B)/cruzamento;
        cruzamento = round((rms_dB-A)/B);
        vezes = vezes + 1;
    end
end

if nargout == 1
    if cruzamento > length(energia_impulso)     %caso o sinal nao atinja o patamar de ruido
        ponto = length(energia_impulso);        %nas amostras fornecidas, considera-se o ponto
    else                                        %de cruzamento a ultima amosta, o que equivale
        ponto = cruzamento;                     %a nao truncar o sinal.
    end
elseif nargout == 2
    if cruzamento > length(energia_impulso)
        ponto = length(energia_impulso);
    else
        ponto = cruzamento;
    end
    C=max(energia_impulso)*10^(A/10)*exp(B/10/log10(exp(1))*cruzamento)/(-B/10/log10(exp(1)));
end

if (nargout == 0 | flag == 1)
    figure
    plot((1:length(energia_impulso))/Fs,10*log10(energia_impulso/max(energia_impulso)));
    hold
    stairs(eixo_tempo/Fs,mediadB,'r');
    plot((1:cruzamento+1000)/Fs,A+(1:cruzamento+1000)*B,'g');
    line([cruzamento-1000,length(energia_impulso)]/Fs,[rms_dB,rms_dB],'Color',[.4,.4,.4]);
    plot(cruzamento/Fs,rms_dB,'o','MarkerFaceColor','y','MarkerSize',10);
    hold
end
