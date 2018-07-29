function [d,c]=runenc(x);
ind=1;
d(ind)=x(1);
c(ind)=1;

for i=2 :length(x)
    if x(i-1)==x(i)
       c(ind)=c(ind)+1;
    else ind=ind+1;
         d(ind)=x(i);
         c(ind)=1;
    end
end