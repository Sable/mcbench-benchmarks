function [coefdif1, coefdif2] = cdecranabsorvente( x, y, frequencia)
%
% Geração dos coeficientes de difracçõa D(teta) e Dt(teta),
% para ecran's absorventes, tal que:
% Dt(teta)=D(teta)*F(S) é contínua e tata = teta(x,y).
%
% function [coefdif1, coefdif2] = cdecranabsorvente( x, y, frequencia)
%
% coefdif1    : Coeficiente de difração D(teta);
% coefdif2    : Coeficiente de difração Dt(teta);
% x	        : Distância horizontal da descontinuidade espacial;
% y	        : Vector com as elevações em relação ao plano horizontal
%		          que contém a descontinuidade espacial (edge);
% frequencia  : Valor da frequencia de trabalho (MHz).
%

coefdif1 = y*0;
coefdif2 = y*0;
s = 0;
tgteta2 = 0;
ro = 0;
k = 0;
fs = 0;
lambda = 300/frequencia;
beta = 2*pi/lambda;
csi = 0;
k1 = 0;
k2 = 0;
k3 = -1/sqrt(2*pi*beta);
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
for k = 1 : length(y),
  ro = power( (x*x + y(k)*y(k)), 0.5);
  tgteta2 = power( (y(k)/x), 2);   
  s = beta*ro*tgteta2/2;
  k1 = power( (2*pi*s), 0.5);
  csi = power( (2*s/pi), 0.5);
  num1 = 1 + 0.926*csi;
  den1 = 2 + 1.792*csi + 3.104*power( csi, 2);
  f = num1/den1;
  num2 = 1;
  den2 = 2 + 4.142*csi + 3.492*power( csi, 2) + 6.670*power( csi, 3);
  g = num2/den2;
  k2 = f + j*g;
  fs = k1*k2;
  costeta = x/ro;
  senteta = y(k)/ro;
  num3 = 1 + costeta;
  den3 = 2*senteta;
  if den3 ~= 0
    coefdif1(k) = k3*num3/den3;
    coefdif2(k) = coefdif1(k)*fs; 
  else
    coefdif1(k) = k3*num3/den3;
    coefdif2(k) = 0;      
  end
end

