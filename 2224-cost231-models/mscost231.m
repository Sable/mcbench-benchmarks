function saida = mscost231(distancia, frequencia, hte, hre, ws, wb, hb, zona)
%
% FUNÇÃO PARA PREVISÃO DA PERDA DEVIDO À EXISTÊNCIA DE EDIFICIOS MULTIPLOS,
% DESDE O TERMINAL FIXO, ATÉ AO TERMINAL MÓVEL.
% USA O MODELO "COST 231-Walfich/Ikegami".
%
% Fonte bibliográfica: Principles and Applications of GSM
%                      Vijay K. Garg, Joseph E. Wilkes
%                      Prentice Hall,1999
%                      Páginas 270 e 273.
%
% saída = mscost231(distancia, frequencia, hte, hre, ws, wb, hb, zona)
%
% saída      : Vector com estimativas de predas, em função da distancia
%              para um valor fixo da frequencia
% distancia  : Vector com valores da distancia expressa em km,
% frequencia : Valor da frequência de trabalho, expressa em MHz,
% hte        : Altura da antena Emissora (em metros)
%	       Recomenda-se que esteja na gama [4,50] metros,
% hre        : Altura efectiva da antena no terminal movél (em metros)
%              Recomenda-se que esteja na gama [1,3] metros,
% ws	     : Largura da rua (expressa em metros), onde o terminal móvel
%	       se encontra; admite-se que este se localiza no centro da via,
% wb	     : Distancia média entre edificios, marcada entre os pontos
%	       centrais dos mesmos, para efeitos do calculo da média,
% hb	     : Altura média dos edificios; neste parametros, inclui-se a
%	       contribuição dos telhados,
% zona	     : Tipo de ambiente urbano em causa:
%	       1 - Grandes Centros Urbanos
%	       0 - Cidades de dimensões razoáveis ou areas Sub-urbanas.
%       

ka = 0;
kd = 0;
kf = 0;
lbsk = 0;
perda = 0;
saida = 0 * distancia;

if hte > hb
  lbsk = -18*log10(1 + hte - hb);
end

if zona == 0
  kf = -4 + 0.7 * (frequencia / 925 - 1);
else
  kf = -4 + 1.5 * (frequencia / 925 - 1);
end

if hte > hb
  kd = 18;
else
  kd = 18 - 15 * (hte - hb) / hb;
end

for n = 1 : length(distancia),
  if hte > hb
    ka = 54;
  elseif hte <= hb
    if distancia(n) >= 0.5
      ka = 54 - 0.8 * (hte - hb);
    else
      ka = 54 - 1.6 * (hte - hb) * distancia(n);
    end
  end
  perda = lbsk + ka + kd*log10(distancia(n)) + kf*log10(frequencia) - 9*log10(wb);
  if perda < 0
     perda = 0;
  end   
  saida(n) = perda;
end

