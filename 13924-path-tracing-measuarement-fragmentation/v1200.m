%script v1200
while 1
  if (x(k)==1)|(v==5)
    break
  end
  xk1=x(k)-1; yk1=y(k);
  ag=0;tr=1;  
  if yk1>1
    xk2=xk1;yk2=yk1-1;
    tr=(I(xk2,yk2)>0);
  end
  if I(xk1,yk1)
    break
  end
  if tr
    per=per+1+I(xk1,yk1+1);
    pr=pr+1;
    if xk1==1
      per=per+1;
    else
      per=per+I(xk1-1,yk1);
    end
    k=k+1;v=1;
    x=[x xk1]; y=[y yk1];
  else
    break
  end
end