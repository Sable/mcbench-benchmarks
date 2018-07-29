
function  y=escorTsallis_entro(DATA,q)
 [M,N]=size(DATA);
  y=zeros(1,N);
  for n=1:N
      sum2=(1-(sum(DATA(:,n).^(1/q)))^(-q))/(q-1);
      y(1,n)=sum2;
      
      
      
      
  end