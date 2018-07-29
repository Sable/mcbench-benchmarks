function saida = rtscost231(frequencia, hre, ws, hb, fi)
%
% FUNÇÃO PARA PREVISÃO DA PERDA POR DIFRAÇÃO DESDE O TOPO DO ULTIMO EDIFICIO
% ATÉ AO NIVÉL DA RUA. 
% USA O MODELO "COST 231-Walfich/Ikegami".
%
% Fonte bibliográfica: Principles and Applications of GSM
%                      Vijay K. Garg, Joseph E. Wilkes
%                      Prentice Hall,1999
%                      Páginas 270 e 273.
%
% saída = rtscost231(frequencia, hre, ws, hb, fi)
%
% saída      : Vector com estimativas de predas, em função da frequencia
% frequencia : Vector com valores da frequência expressa em MHz
%	       Recomenda-se que esteja na gama [4,50] metros,
% hre        : Altura da antena do terminal movél (em metros)
%              Recomenda-se que esteja na gama [1,3] metros,
% ws	     : Largura da rua (expressa em metros), onde o terminal móvel
%	       se encontra; admite-se que este se localiza no centro da via,
% hb	     : Altura média dos edificios; neste parametros, inclui-se a
%	       contribuição dos telhados.
%	       

dhm = hb - hre;
perda = 0;
lzero = 0;
if fi < 35
  lzero = -10+0.354*fi;
elseif fi >= 35 & fi < 55
  lzero = 2.5+0.075*(fi-35);
else
  lzero = 4.0-0.114*(fi-55);
end
saida = frequencia * 0;
for n = 1 : length(frequencia),
   perda = -16.9 -10*log10(ws) + 10*log10(frequencia(n)) + 20*log10(dhm) + lzero;
   if perda < 0
      perda = 0;
   end   
   saida(n) = perda;
end