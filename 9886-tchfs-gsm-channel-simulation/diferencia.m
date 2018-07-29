function Y = diferencia(X)

m=length(X);
        
        for i = 2:m,
      Y(i-1)=mod((X(i)+X(i-1)),2);
        end
         Y(m)=0;
       Y=Y';  