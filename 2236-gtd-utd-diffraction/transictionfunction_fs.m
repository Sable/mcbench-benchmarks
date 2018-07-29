function saida = transictionfunction_fs( s)
%
% Geração da função de transição complexa F=F(S) 
%
% function saida = funcaotransicaofs( s)
%
% saida       : Vector de saída com o função de transição F(S);
% s           : Vector com S's de entrada para o calculo da função F(S).
%

saida = s*0;
k = 0;
fs = 0;

csi = 0;
k1 = 0;
k2 = 0;

f = 0;
g = 0;
num1 = 0;
den1 = 0;
num2 = 0;
den2 = 0;
cdaux = 0;
num3 = 0;
den3 = 0;
costeta = 0;
senteta = 0;
for k = 1 : length(s),
  k1 = power( (2*pi*s(k)), 0.5);
  csi = power( (2*s(k)/pi), 0.5);
  num1 = 1 + 0.926*csi;
  den1 = 2 + 1.792*csi + 3.104*power( csi, 2);
  f = num1/den1;
  num2 = 1;
  den2 = 2 + 4.142*csi + 3.492*power( csi, 2) + 6.670*power( csi, 3);
  g = num2/den2;
  k2 = f + j*g;
  fs = k1*k2;
  saida(k) = fs;
end

