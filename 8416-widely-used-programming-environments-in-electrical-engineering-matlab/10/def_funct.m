	function f=def_funct(t,t1,a1,t2,a2,a3)
			% **************************************************
			% Functie MATLAB destinata generarii
			% unei functii de forma
			%
			%        a1, pentru t<t1
			% f(t)=  a2, pentru t>t2
			%        a3, pentru t>=t1 si t<=t2
			%
			% Variabile de intrare:
			% - t intervalul total de definitie al functiei
			% - t1, t2 limitele de definitie
			% - a1, a2, a3 valorile functiei
			%   in diferitele intervale
			% Variabila de iesire: vectorul f
			% **************************************************

			% Determinarea indicilor pentru care t<t1
	k1=find(t<t1); 
			% Determinarea indicilor pentru care t>t2
	k3=find(t>t2); 
			% Generarea tuturor indicilor
	k2=1:length(t); 
			% Generarea indicilor din mijloc 
			% prin extragerea celor pentru care t<t1 si t>t2
	k2([k1 k3])=[]; 
			% Incarcarea vectorului rezultat
			% (utilizand tricul lui Tony):
			% - prima parte cu valorile a1
	f(k1)=a1(1,ones(1,length(k1)));
			% - partea din mijloc cu valorile a3
	f(k2)=a3(1,ones(1,length(k2)));
			% - ultima parte cu valorile a2
	f(k3)=a2(1,ones(1,length(k3)));
