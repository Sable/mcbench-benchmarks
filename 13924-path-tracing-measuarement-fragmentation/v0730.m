%script v0730
while 1
  if or(x(k)==si,y(k)==1)|(v==2)
    break
  end
  xk1=x(k)+1;  yk1=y(k)-1;
  if I(xk1,yk1)
    break
  end
  xk2=xk1-1;yk2=yk1;
  tr=(I(xk2,yk2)>0)|I(xk1,y(k));
  if tr
    per=per+1;
    pr=pr+sqrt(2);
    if xk1==si
      per=per+1;
    else
      per=per+I(xk1+1,yk1);
    end
    if yk1==1
      per=per+1;
    else
      per=per+I(xk1,yk1-1);
    end  
    k=k+1;v=6;
    x=[x xk1];  y=[y yk1];
  else
    break
  end
end