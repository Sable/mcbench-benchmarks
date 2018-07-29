function C=renum(V)

n=V(1,1);

C=ones(1,n+1);
for i=1 : n+1 
  C(1,i)=V(1,i);  
end
