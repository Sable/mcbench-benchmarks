%script v0300
while 1  
    if (y(k)==sj)|(v==7)
      break
    end       
    xk1=x(k);   yk1=y(k)+1;
    xk2=xk1-1;  yk2=yk1;    
   if I(xk1,yk1)     
      break
   end   
    if xk2==0
      tr=1;
    else
      tr=(I(xk2,yk2)>0);
    end    
  if tr
    per=per+1+I(xk1+1,yk1);
    pr=pr+1;    
    if yk1==sj
      per=per+1;
    else
      per=per+I(xk1,yk1+1);
    end
    k=k+1;  v=3;
    x=[x xk1];  y=[y yk1];
  else
    break
  end
end