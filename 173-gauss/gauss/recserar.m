function y=recserar(x,y0,a)
% RECSERAR
% RECSERAR(x,y0,a) constructs a recursive time series
% x: N*K   y0: P*K   a: P*K   y: N*K
% y(t)=x(t)+a(1)y(t-1)+...a(p)y(t-p) for t=p+1,..N
% y(t)=y0(t) for t=1,..P
y=[];
y=y0;

p=lin(y0); n=rows(x);
for i=p+1:n
   maty=rev(y(i-p:i-1,:)');
   y(i,:)=maty'.*a+x(i,:);
end
