%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% reverberacao.m
%%
%% This function evaluates the decay time of a room, given its
%% impulse response.
%%
%%  [EDT,T20,T30,T40] = reverberacao(IR^2,Fs,flag)
%%
%% The input are the squared impulse response and its sampling frequency.
%% The delay of this impulse response should not be present! The flag
%% variable specifies if the function will (1) or not (0) plot the
%% evaluated decay curves.
%% The output are the decay times T20, T30 e T40 and EDT.

function [EDT,T20,T30,T40] = reverberacao(varargin)

ir  = varargin{1};
Fs = varargin{2};
E(length(ir):-1:1) = (cumsum(ir(length(ir):-1:1))/sum(ir));

if find(E < 0)
    E(min(find(E < 0)):end) = [];
    E=10*log10(E);
else
    E=10*log10(E);
end

if nargin == 3
    flag = varargin{3};
else
    flag = 0;
end

x = (0:length(E)-1)/44100;

%Calcula o Early Decay Time (EDT) do sinal. A curva de Schroeder fornecida deve
%ter sido obtida a partir de uma resposta impulsiva sem ruido de inicio.
t10   = min(find(E < -15)); 
[A10,B10] = intlinear(x(1:t10),E(1:t10));
EDT = (-60)/(B10);

% Calcula os tempos de reverberacao da resposta impulsiva (T20 e T30) a partir
% curva de Schroeder (em dB) fornecida no argumento de entrada.

if flag == 1
    %grafico de saida
    figure, plot(x,E,'LineWidth',1.5);
end

begin = min(find(E < -5));
t25   = min(find(E < -25));     %Se a curva nao for monotonica, o primeiro ponto onde a curva
t35   = min(find(E < -35));     %atinge -25 e -35dB limita a regiao de iteracao.
t45   = min(find(E < -45));

%Usando 20dB
if ~isempty(t25)
    [A20,B20] = intlinear(x(begin:t25),E(begin:t25));
    T20 = (-60)/(B20);
else
    T20=NaN;                %Caso a resposta impulsiva nao apresentefaixa dinamica suficiente
end

%Usando 30dB
if ~isempty(t35)
    [A30,B30] = intlinear(x(begin:t35),E(begin:t35));
    T30 = (-60)/(B30);
else
    T30=NaN;                %Caso a resposta impulsiva nao apresentefaixa dinamica suficiente
end

if nargout == 4
    %Usando 40dB
    if ~isempty(t45)
        [A40,B40] = intlinear(x(begin:t45),E(begin:t45));
        T40 = (-60)/(B40);
    else
        T40=NaN;
    end
else
    T40=NaN;            %Caso a resposta impulsiva nao apresentefaixa dinamica suficiente
end

if flag == 1
    title('Aproximacao dos tempos de Decaimento');
    ylim([-70 0]);
    ylimit = ylim;
    xlabel('tempo (s)'), ylabel('dB')
    xlim([0 max([T20 T30 T40])*1.1]);
    xlimit=xlim;
    
    line([0,(-60-A10)/(B10)],[A10,-60],'Color','m','LineWidth',.5);
    line([0,(-60-A20)/(B20)],[A20,-60],'Color','r','LineWidth',.5);
    line([0,(-60-A30)/(B30)],[A30,-60],'Color','g','LineWidth',.5);
    if nargout == 4
        line([0,(-60-A40)/(B40)],[A40,-60],'Color','y','LineWidth',.5);
    end
    line([xlimit(1),xlimit(2)],[-60,-60],'Color',[.4,.4,.4],'LineWidth',.5);
  
    legend('Curva de Schroeder',['EDT (ms) = ',num2str(EDT*1000)],['T_2_0 (ms) = ',num2str(T20*1000)],...
            ['T_3_0 (ms) = ',num2str(T30*1000)],['T_4_0 (ms) = ',num2str(T40*1000)])
end