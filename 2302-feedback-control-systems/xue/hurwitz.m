function H=hurwitz(den)
n=length(den)-1;
for i=1:n, i1=floor(i/2);
   if i==i1*2, hsub1=den(1:2:n+1); i1=i1-1;
   else, hsub1=den(2:2:n+1); end
   l1=length(hsub1);
   H(i,:)=[zeros(1,i1),hsub1,zeros(1,n-i1-l1)];
end
