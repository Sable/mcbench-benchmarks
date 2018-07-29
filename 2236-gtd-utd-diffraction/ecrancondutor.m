function saida = ecrancondutor( frequencia, angulo, filinha)
%
%  Função que para um determinado valor da frequência de trabalh,
%  e para uma ampla gama de angulos, retorna o valor do
%  coeficiente de difração Df=D(teta), usando a formulação de FELSEN..
%  Depende da polarização.
%
%
%
%  Fonte bibliográfica: Radiowave propagation for modern communications
%			Henry L. Bertoni
%			Prentice-Hall, 2000
%			[Bertoni 2000]
%
%  saida = ecrancondutor( frequencia, angulo, filinha)
%  saida	       : Vector com valore do coeficiente de difusao, para
%		            uma gama de angulos dada pelo array 'angulo';
%  frequencia   : Valor da frequencia de trabalho expressa em MHz;
%  angulo	    : Vector de entrada contendo valores dos ângulos
%                 'teta entre a ISB e a posição;
%  filinha      :
%

k = 0;

s = 0;

lambda = 300/frequencia;

beta = 2*pi/lambda;

saida = 0*angulo;

aux = 0;

for k = 1 : length(angulo),
   teta = angulo(k);
   aux = -0.5/sqrt(2*pi*beta)*(1/cos((pi-teta)/2)-1/cos((pi-teta+2*filinha)/2));  
   saida(k) = abs(aux);
end
