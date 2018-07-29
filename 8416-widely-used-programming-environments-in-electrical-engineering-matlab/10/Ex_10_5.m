		% Generarea matricei spirale
M=spiral(4)
		% Determinarea dimensiunilor matricei M
[k,l]=size(M);
		% Cele doua cicluri for pentru verificarea
		% conditiei pentru fiecare element
for i=1:k
	for j=1:l
		if (M(i,j) < 5)
        	M(i,j)=-M(i,j);
		end
	end
end
		% Afisarea rezultatului
M	
