function y=shannon_entro(x)
       [M,N]=size(x);
       y=zeros(1,N);
       for l=1:N
          sum1=sum(x(:,l).*log(x(:,l)));
          sum1=-1*sum1;
         y(1,l)=sum1;
       end
      