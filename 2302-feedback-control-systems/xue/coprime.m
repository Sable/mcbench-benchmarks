function [GN,GM,GX,GY]=coprime(G,K1,K2)
G=tf(G); num=G.num{1}; den=G.den{1};
if length(K1)==1, 
   K1=K1*ones(1,length(den)-1); 
end
if length(K2)==1, 
   K2=K2*ones(1,length(den)-1); 
end
[a,b,c,d]=tf2ss(num,den); 
F=-acker(a,b,K1); H=-acker(a',c',K2)';
GM=tf(ss(a+b*F,b,F,1)); 
GN=tf(ss(a+b*F,b,c+d*F,d));
GX=tf(ss(a+H*c,H,F,0)); 
GY=tf(ss(a+H*c,-b-H*d,F,1));
