function p=polelague(n)

% p=polegend(n)
% Almacena en las filas de la matriz p los coefs de los polinomios de Legendre

p(1,1)=1;
p(2,1:2)=[-1 1]; 
for k=2:n
   p(k+1,1:k+1)=((2*(k-2)*[0 p(k,1:k)]+3*[0 p(k,1:k)]-[p(k,1:k) 0]-(k-1).^2*[0 0 p(k-1,1:k-1)]));
end
