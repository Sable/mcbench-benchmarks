		% Generarea matricei spirale
M=spiral(4)
		% Determinarea tuturor indicilor elementelor 
		% care satisfac conditia data
ind=find(M<5)
		% Modificarea termenilor matricei M 
		% care au satisfacut conditia data
M(ind)=-M(ind)