function [Ga,Xa]=augment(G,cc,dd,X)
G=ss(G);
Aa=G.a; Ca=G.c; Xa=X; Ba=G.b; D=G.d; 
if (length(dd)>0 & sum(abs(dd))>1e-5),
   if (abs(dd(4))>1e-5),
      Aa=[Aa dd(2)*Ba, dd(3)*Ba;
            zeros(2,length(Aa)),...
            [dd(1),-dd(4); dd(4),dd(1)]];
      Ca=[Ca dd(2)*D dd(3)*D]; 
      Xa=[Xa; 1; 0]; Ba=[Ba; 0; 0];
   else,
      Aa=[Aa dd(2)*B; zeros(1,length(Aa)) dd(1)];
      Ca=[Ca dd(2)*D]; Xa=[Xa; 1]; Ba=[B;0];
   end
end
if (length(cc)>0 & sum(abs(cc))>1e-5),
   M=length(cc); 
   Aa=[Aa Ba zeros(length(Aa),M-1);
       zeros(M-1,length(Aa)+1) eye(M-1);
       zeros(1,length(Aa)+M)];
   Ca=[Ca D zeros(1,M-1)];
   Xa=[Xa; cc(1)]; ii=1;
   for i=2:M, ii=ii*i; 
      Xa(length(Aa)+i)=cc(i)*ii;
   end
end
Ga=ss(Aa,zeros(size(Ca')),Ca,D);
