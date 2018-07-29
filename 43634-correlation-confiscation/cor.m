function rr=cor(yyn,yon)
n=length(yon);  %yon  x..outher..yo1         yyn...y ..adopted..yn1

a=n*sum(yon.*yyn)-sum(yon)*sum(yyn);

b=sqrt((n*sum(yon.^2)-(sum(yon))^2)*(n*sum(yyn.^2)-(sum(yyn))^2));
rr=(a/b);