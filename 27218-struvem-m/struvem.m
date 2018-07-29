function f=struvem(v,x,n)
% Calculates the Modified Struve Function
%
% struvem(v,x) 
% struvem(v,x,n)
% 
% L_v(x) is the modified struve function and n is the length of
% the series calculation (n=100 if unspecified)
%
% from: Abramowitz and Stegun: Handbook of Mathematical Functions
% 		http://www.math.sfu.ca/~cbm/aands/page_498.htm

if nargin<3
n=100;
end

k=0:n;

x=x(:)';
k=k(:);

xx=repmat(x,length(k),1);
kk=repmat(k,1,length(x));

TOP=1;
BOT=gamma(kk+1.5).*gamma(kk+v+1.5);
RIGHT=(xx./2).^(2.*kk+v+1);
FULL=TOP./BOT.*RIGHT;

f=sum(FULL);