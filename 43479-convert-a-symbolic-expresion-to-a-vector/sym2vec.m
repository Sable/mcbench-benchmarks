function R=sym2vec(r)
% Separa los terminos de la variable simbolica r en un vector:
% R=sym2vec(r)
% de tal manera que r=sum(R)
% p.e.  r= c - exp(x) + b*x + a*x^2
% R=sym2matrix(r)
%  R=[ c, -exp(x), b*x, a*x^2]
% Erasmo miranda
% luis.erasmo@gmail.com


vars=symvar(r);
for k=1:numel(vars)
    syms(char(vars(k)))
end

r=char(expand(r));
if r(1)~='-'
    r=[' + ',r];
else
    r=[' ',r];
end
Ip=strfind(r,' + ');
In=strfind(r,' - ');
I =[sort([Ip In]),numel(r)+1];

for k=1:numel(I)-1
    R(k)=eval(r(I(k):I(k+1)-1));
end





