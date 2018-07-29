function [K,L,T]=getfod(G,method)
K=dcgain(G);
if nargin==1
   [Kc,Pm,wc,wcp]=margin(G); ikey=0;
   L=1.6*pi/(3*wc); T=0.5*Kc*K*L; 
   if finite(Kc), 
      x0=[L;T]; 
      while ikey==0, 
         ww1=wc*x0(1); ww2=wc*x0(2);
         FF=[K*Kc*(cos(ww1)-ww2*sin(ww1))+1+ww2^2;
             sin(ww1)+ww2*cos(ww1)];
         J=[-K*Kc*wc*sin(ww1)-K*Kc*wc*ww2*cos(ww1), ...
            -K*Kc*wc*sin(ww1)+2*wc*ww2;
             wc*cos(ww1)-wc*ww2*sin(ww1), wc*cos(ww1)]; 
         x1=x0-inv(J)*FF; 
         if norm(x1-x0)<1e-8, 
            ikey=1; else, x0=x1;
      end, end
      L=x0(1); T=x0(2);
   end
elseif nargin==2 & method==1
   [n1,d1]=tfderv(G.num{1},G.den{1}); 
   [n2,d2]=tfderv(n1,d1);
   K1=dcgain(n1,d1); K2=dcgain(n2,d2);
   Tar=-K1/K; T=sqrt(K2/K-Tar^2); L=Tar-T;
end

%evaluate the derivative of a/b
function [e,f]=tfderv(b,a)
f=conv(a,a);
e1=conv((length(b)-1:-1:1).*...
   b(1:length(b)-1),a);
e2=conv((length(a)-1:-1:1).*...
   a(1:length(a)-1),b);
maxL=max(length(e1),length(e2));
e=[zeros(1,maxL-length(e1)) e1]-...
   [zeros(1,maxL-length(e2)) e2];

