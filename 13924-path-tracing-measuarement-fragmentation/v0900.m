%script v0900
while 1
  if (y(k)==1)|(v==3)
    break
  end
  xk1=x(k); yk1=y(k)-1;
  if I(xk1,yk1)
    break
  end
  xk2=xk1+1;yk2=yk1;
  tr=1;
  if xk1<si
    tr=(I(xk2,yk2)>0);
  end
  if tr
    per=per+1;
    pr=pr+1;
    if yk1==1
      per=per+1;
    else
      per=per+I(xk1,yk1-1);
    end
    if xk1==1
      per=per+1;
    else
      per=per+I(xk1-1,yk1);
    end
    k=k+1;v=7;
    x=[x xk1];  y=[y yk1]; 
  else
    break
  end
end