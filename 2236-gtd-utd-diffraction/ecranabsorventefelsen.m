function saida = ecranabsorventefelsen( frequencia, angulo)
%
%  Função que para um determinado valor da frequência de trabalho,
%  e para uma ampla gama de angulos, retorna o valor do
%  coeficiente de difração Df=D(teta), usando a formulação de FELSEN..
%
%
%
%  Fonte bibliográfica: Radiowave propagation for modern communications
%			Henry L. Bertoni
%			Prentice-Hall, 2000
%			[Bertoni 2000]
%
%  saida = ecranabsorventefelsen( frequencia, angulo)
%  saida	       : Vector com valore do coeficiente de difusao, para
%		            uma gama de angulos dada pelo array 'angulo';
%  frequencia   : Valor da frequencia de trabalho expressa em MHz;
%  angulo	    : Vector de entrada contendo valores do ângulo de
%                 em relação à direcção de incidência, em RADIANOS;
%
%

k = 0;

s = 0;

lambda = 300/frequencia;

beta = 2*pi/lambda;

saida = 0*angulo;

aux = 0;

for k = 1 : length(angulo),
   fi = angulo(k);
   aux = -1/sqrt(2*pi*beta)*(1/fi+1/(2*pi-fi));  
   saida(k) = abs(aux);
end
