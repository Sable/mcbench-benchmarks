%Compute properties for parabolic cylinder coordinates
clear all; syms u v p real
X=[u*v*cos(p); u*v*sin(p); (u^2-v^2)/2];
J=[diff(X,u),diff(X,v),diff(X,p)];
bco=J; bcn=simple(inv(J).');
gco=simple(J.'*J); gcn=simple(inv(gco));
h=sym(zeros(3,3)); cs1=h; cs2=h;
h(:,:,1)=diff(J,u); h(:,:,2)=diff(J,v); h(:,:,3)=diff(J,p); h=simple(h); 
for i=1:3
  for j=1:3
    for k=1:3
      cs1(i,j,k)=simple(h(1,i,j)*J(1,k)+h(2,i,j)*J(2,k)+h(3,i,j)*J(3,k));
    end
  end
end
for k=1:3
  cs2(:,:,k)=simple(cs1(:,:,1)*gcn(1,k)+cs1(:,:,2)*gcn(2,k)+...
                    cs1(:,:,3)*gcn(3,k));
end
clear i j k
X,bco,bcn,gco,gcn,cs1,cs2
 