function saida = ecranabsorventeutd( frequencia, angulo, raio)
%
%  Função que para um determinado valor da frequência de trabalh,
%  e para uma ampla gama de angulos, retorna o valor do
%  coeficiente de difração Df=D(teta).
%  Usa a formulação dada pela Teoria Uniforme da Difração (UTD)
%
%  E(x,y)=A0.exp(-j.Beta.x).U(y) + A0.exp(-j.PI/4).exp(-j.Beta.RO)/SQR(RO).Dt
%  RO = SQRT(x*x + y*y)
%  Dt(teta) = D(teta).F(S)
%
%
%  Fonte bibliográfica: Radiowave propagation for modern communications
%			Henry L. Bertoni
%			Prentice-Hall, 2000
%			[Bertoni 2000]
%
%  saida = ecranabsorventeutd( frequencia, angulo, raio)
%
%  saida	       : Vector com valore do coeficiente de difusao, para
%		            uma gama de angulos dada pelo array 'angulo';
%  frequencia   : Valor da frequencia de trabalho expressa em MHz;
%  angulo	    : Vector de entrada contendo valores do ângulo,
%		            expressos em RADIANOS;
%  raio         : Valor do raio, para se obter 'x' e 'y'.
%

k = 0;

x = 0;

y = 0;

s = 0;

lambda = 300/frequencia;

beta = 2*pi/lambda;

saida = 0*angulo;

aux = 0;
s_aux = 0;

for k = 1 : length(angulo),
   teta = angulo(k);
   x = raio * cos(teta);
   y = raio * sin(teta);
   aux = 0;  
   [aux, s_aux] = funcaotransicao( x, y, frequencia);
   saida(k) = abs(-1/sqrt(2*pi*beta)*(1+cos(teta))/(2*sin(teta))*aux);
end
