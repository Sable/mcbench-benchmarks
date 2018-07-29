function y=renyi_entro(DATA,q)
  [M,N]=size(DATA);
       y=zeros(1,N);
       for n=1:N
           y(1,n)=log(sum(DATA(:,n).^q))/(1-q);
       end