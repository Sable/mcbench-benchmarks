function saida = hata_rural( distancia, frequencia, hte, hre)
%
% FUNÇÃO PARA PREVISÃO DE PERDAS USANDO O "MODELO DE HATA"
%
% Fonte bibliográfica: Wireless Communications - Principles and Practice
%                      Theodore S. Rappaport
%                      Prentice Hall,1996
%                      Páginas 119 e 120.
%
% saída = hata_rural(frequencia, distancia, hte, hre)
%
% saída      : Vector com estimativas de predas, em função da distancia
%              para um valor fixo da frequencia
% distancia  : Vector com valores da distancia expressa em km
%              Recomenda-se que seja superior a 1 km
% frequencia : Frequencia de trabalho, expressa em MHz,
%              Recomenda-se que se situe na gama [150,1500] MHz
% hte        : Altura efectiva da antena Emissora (em metros)
%              Recomenda-se que esteja na gama [30, 200] (metros)
% hre        : Altura efectiva da antena no terminal movél (em metros)
%              Recomenda-se que esteja na gama [1, 10] (metros)
%
% APLICABILIDADE DO MÉTODO: Zonas rurais com grandes areas abertas.
%           
%



for k = 1 : length(distancia),
   saida(k) = 0;
   perda = 69.55 + 26.16*log10(frequencia) - 13.82*log10(hte) + (44.9 - 6.55*log10(hte))*log10(distancia(k));
   perda = perda - 4.78*log10(frequencia)*log10(frequencia) + 18.33*log10(frequencia) - 40.98;
   saida(k) = perda;
end
