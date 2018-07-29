function [Cikis]=IterativeAveragingFilter(I,iterasyon,PencereGen)
% Iteratively apply averaging filtering on the matrix I.
% itrasyon: Number of applying average filtering.
% PencereGen: Set size Of square shaped window for averaging filter.
% (PencereGenxPencereGen) window.
%
% Programmer: B. Baykant ALAGÖZ
% Ver.1.0 date: 09.2008
%******************************************************************
[m n p]=size(I);
Iint=zeros(m,n);
duseyBoy=round(PencereGen(1)/2);
yatayBoy=round(PencereGen(2)/2);
for t=1:iterasyon
for i=1+duseyBoy:m-duseyBoy
    for j=1+yatayBoy:n-yatayBoy
        top=0;
        for k=-duseyBoy:duseyBoy
           for w=-yatayBoy:yatayBoy
               top=top+I(i+k,j+w);
           end
       end
       Iint(i,j)=top/(4*duseyBoy*yatayBoy);
   end
end
I=Iint;
end
Cikis=I;