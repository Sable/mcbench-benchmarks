function [res,ires]=dydt(t,y,yp,rpar)

global DEBUG;

res(1)=yp(1)+rpar(1)*y(1);
res(2)=yp(2)+rpar(2)*y(2);
res(3)=y(3)-y(1)-2.0;

ires = 0;

if ( DEBUG > 9 )
  buf1 = sprintf('%.4e ',y);
  buf2 = sprintf('%.4e ',yp);
  buf3 = sprintf('%.4e ',res);
  disp(sprintf('(Debug) dydt.m: t=%.2e y=%s yp=%s res=%s', ...
               t,buf1,buf2,buf3));
  if ( DEBUG > 99 )
    cbuf = input(sprintf('\tRETURN to continue : '));
  end
end



