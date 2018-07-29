function saida = ecranabsorventegtd( frequencia, angulo)
%
%  Função que para um determinado valor da frequência de trabalh,
%  e para uma ampla gama de angulos, retorna o valor do
%  coeficiente de difração Df=D(teta).
%  Usa a formulação dada pela Teoria Geral da Difração (GTD)
%
%  E(x,y)=A0.exp(-j.Beta.x) + A0.exp(-j.PI/4).exp(-j.Beta.RO)/SQR(RO).Df
%  E(x,y)=A0.exp(-j.Beta.x) + A0.exp(-j.PI/4).exp(-j.Beta.RO)/SQR(RO).D(teta)
%
%
%  Fonte bibliográfica: Radiowave propagation for modern communications
%			Henry L. Bertoni
%			Prentice-Hall, 2000
%			[Bertoni 2000]
%
%  saida = ecranabsorventegtd( frequencia, angulo)
%
%  saida			 : Vector com valore do coeficiente de difusao, para
%		     			uma gama de angulos dada pelo array 'angulo';
%  frequencia   : Valor da frequencia de trabalho expressa em MHz;
%  angulo	    : Vector de entrada contendo valores do ângulo,
%				  	   expressos em RADIANOS.
%

k = 0;

lambda = 300/frequencia;

beta = 2*pi/lambda;

saida = 0*angulo;

for k = 1 : length(angulo),
   teta = angulo(k);
   saida(k) = abs(-1/sqrt(2*pi*beta)*(1+cos(teta))/(2*sin(teta)));
end
