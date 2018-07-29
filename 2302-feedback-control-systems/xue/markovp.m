function M=markovp(G,k)
G=ss(G); A=G.a; B=G.b; C=G.c; D=G.d;  
M=[C*B+D,zeros(1,k-1)]; A1=A;
for i=1:k-1, 
   M(i+1)=C*A1*B; A1=A*A1; 
end

   