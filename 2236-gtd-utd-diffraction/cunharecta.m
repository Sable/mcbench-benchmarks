function saida = cunharecta( frequencia, angulo, filinha)
%
%  Função que para um determinado valor da frequência de trabalho,
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
%  saida = cunharecta( frequencia, angulo, filinha)
%  saida	       : Vector com valores do coeficiente de difusao, para
%		            uma gama de angulos dada pelo array 'angulo';
%  frequencia   : Valor da frequencia de trabalho expressa em MHz;
%  angulo	    : Vector de entrada contendo valores dos ângulos
%                 entre a ISB e o ponto;
%  filinha      :
%

k = 0;

s = 0;

lambda = 300/frequencia;

beta = 2*pi/lambda;

saida = 0*angulo;

aux = -1/(3*sqrt(2*pi*beta));
d1 = 0;
d2 = 0;
d3 = 0;
d4 = 0;

for k = 1 : length(angulo),
   teta = angulo(k);
   d1 = aux/tan((2*pi-teta)/3);
   d2 = aux/tan(teta/3);
   d3 = aux/tan((2*pi-teta+2*filinha)/3);
   d4 = aux/tan((teta-2*filinha)/3);
   saida(k) = abs(d1+d2-d3-d4);
end
