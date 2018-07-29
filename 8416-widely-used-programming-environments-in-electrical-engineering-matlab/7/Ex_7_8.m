		% Incarcarea vectorilor cu coordonatele varfurilor
        % celor trei dreptunghiuri care vor forma poliedrul spatial
x1=[0,1,1,0]; y1=[0,0,-1,-1]; z1=[0,0,0,0];
x2=[1,1,1,1]; y2=[0,0,-1,-1]; z2=[0,1,1,0];
x3=[0,1,1,0]; y3=[0,0,-1,-1]; z3=[1,1,1,1];
		% Comanda formata din trei unitati, fiecare desemnand
		% cate-o fata a poliedrului spatial	
fill3(x1,y1,z1,'r',x2,y2,z2,'g',x3,y3,z3,'b');