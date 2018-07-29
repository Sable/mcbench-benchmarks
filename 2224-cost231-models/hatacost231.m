function saida = hatacost231(distancia, frequencia, hte, hre, zona)
%
% FUNÇÃO PARA PREVISÃO DE PERDAS USANDO UMA EXTENSÃO DO "MODELO DE HATA"
%             SEGUNDO UMA RECOMENDAÇÃO DO COMITÉ CIENTIFICO COST-231, 
%             COM VISTA A EXTÊNDER A GAMA DE FREQUÊNCIAS DE 1.5 A 2 GHz.
%
% Fonte bibliográfica: Wireless Communications - Principles and Practice
%                      Theodore S. Rappaport
%                      Prentice Hall,1996
%                      Páginas 120.
%
% saída = hatacost231(distancia, frequencia, hte, hre, zona)
%
% saída      : Vector com estimativas de predas, em função da distancia
%              para um valor fixo da frequencia
% distancia  : Vector com valores da distancia expressa em km
%              Recomenda-se que seja superior a 1 km
% frequencia : Frequencia de trabalho, expressa em MHz,
%              Recomenda-se que se situe na gama [150,2000] MHz
% hte        : Altura efectiva da antena Emissora (em metros)
%              Recomenda-se que esteja na gama [30, 200] (metros)
% hre        : Altura efectiva da antena no terminal movél (em metros)
%              Recomenda-se que esteja na gama [1, 10] (metros)
% zona       : Classificação da area em analise para o parâmetro de correcção alfa(Hre)
%              1 - Cidades com pouco e mediano grau de urbanização
%              2 - Grandes metrópoles
%	            3 - Areas suburbanas
%              4 - NÃO ESTÁ PREVISTA A SITUAÇÃO PARA ZONAS RURAIS.
%


if frequencia > 1500
   for k = 1 : length(distancia),
      perda = 46.30 + 33.90*log10(frequencia) - 13.82*log10(hte) + (44.9 - 6.55*log10(hte))*log10(distancia(k));
      perda = perda -(1.1*log10(frequencia)-0.7)*hre + (1.56*log10(frequencia)-0.8);
      if zona ~= 2
         perda = perda + 3;
      end  
      saida(k) = perda;
   end 
else
   for k = 1 : length(distancia),
      perda = 69.55 + 26.16*log10(frequencia) - 13.82*log10(hte) + (44.9 - 6.55*log10(hte))*log10(distancia(k));
      saida(k) = perda -(1.1*log10(frequencia)-0.7)*hre + (1.56*log10(frequencia)-0.8);
   end    
end