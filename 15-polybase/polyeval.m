function y=polyeval(p,x)

% y=polyeval(p,x);
% This function evaluates the polynomial p computed by 
% polymake in a given point x.

% G.Campa 25/04/99

x=reshape(x,size(x,1)*size(x,2),1);
Px=x(p.idx(p.Vx)).^p.Wx;Pr=Px(1,:);
for h=2:size(Px,1), Pr=prod(polycomb(Pr,Px(h,:))); end
y=Pr*p.C;
