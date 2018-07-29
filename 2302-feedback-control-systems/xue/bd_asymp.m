function [wpos,ypos]=bd_asymp(G,w)
G1=zpk(G); Gtf=tf(G);
if nargin==1, 
   w=freqint2(Gtf.num{1},Gtf.den{1},100); 
end
zer=G1.z{1}; pol=G1.p{1}; gain=G1.k;
wpos=[]; pos1=[];
for i=1:length(zer);
   if isreal(zer(i))
      wpos=[wpos, abs(zer(i))]; 
      pos1=[pos1,20];
   else
      if imag(zer(i))>0
         wpos=[wpos, abs(zer(i))]; 
         pos1=[pos1,40];
end, end, end
for i=1:length(pol);
   if isreal(pol(i))
      wpos=[wpos, abs(pol(i))]; 
      pos1=[pos1,-20];
   else
      if imag(pol(i))>0
         wpos=[wpos, abs(pol(i))]; 
         pos1=[pos1,-40];
end, end, end
wpos=[wpos w(1) w(length(w))]; 
pos1=[pos1,0,0];
[wpos,ii]=sort(wpos); pos1=pos1(ii);
ii=find(abs(wpos)<eps); kslp=0; 
w_start=1000*eps; 
if length(ii)>0, 
   kslp=sum(pos1(ii)); 
   ii=(ii(length(ii))+1):length(wpos);
   wpos=wpos(ii); pos1=pos1(ii); 
end
while 1
   [ypos1,pp]=bode(G,w_start);
   if isinf(ypos1), w_start=w_start*10;
   else, break; end
end
wpos=[w_start wpos]; 
ypos(1)=20*log10(ypos1);
pos1=[kslp pos1];
for i=2:length(wpos)
   kslp=sum(pos1(1:i-1));
   ypos(i)=ypos(i-1)+...
         kslp*log10(wpos(i)/wpos(i-1));      
end
ii=find(wpos>=w(1)&wpos<=w(length(w)));
wpos=wpos(ii); ypos=ypos(ii);
