function [Q,V,R]=MSA(D)
m=D.m;n=D.n;Ni=zeros(12,12,m);S=zeros(6*n);Pf=S(:,1);Q=zeros(12,m);Qfi=Q;Ei=Q;
for i=1:m
    H=D.Con(:,i);C=D.Coord(:,H(2))-D.Coord(:,H(1));e=[6*H(1)-5:6*H(1),6*H(2)-5:6*H(2)];c=D.be(i);
    [a,b,L]=cart2sph(C(1),C(3),C(2));ca=cos(a);sa=sin(a);cb=cos(b);sb=sin(b);cc=cos(c);sc=sin(c);
    r=[1 0 0;0 cc sc;0 -sc cc]*[cb sb 0;-sb cb 0;0 0 1]*[ca 0 sa;0 1 0;-sa 0 ca];T=kron(eye(4),r);
    co=2*L*[6/L 3 2*L L];x=D.A(i)*L^2;y=D.Iy(i)*co;z=D.Iz(i)*co;g=D.G(i)*D.J(i)*L^2/D.E(i);
    K1=diag([x,z(1),y(1)]);K2=[0 0 0;0 0 z(2);0 -y(2) 0];K3=diag([g,y(3),z(3)]);K4=diag([-g,y(4),z(4)]);
    K=D.E(i)/L^3*[K1 K2 -K1 K2;K2' K3 -K2' K4;-K1 -K2 K1 -K2;K2' K4 -K2' K3];
    w=D.w(:,i)';Qf=-L^2/12*[6*w/L 0 -w(3) w(2) 6*w/L 0 w(3) -w(2)]';Qfs=K*T*D.St(e)';
    A=diag([0 -0.5 -0.5]);B(2,3)=1.5/L;B(3,2)=-1.5/L;W=diag([1,0,0]);Z=zeros(3);M=eye(12);p=4:6;q=10:12;
    switch 2*H(3)+H(4)
        case 0;B=2*B/3;M(:,[p,q])=[-B -B;W Z;B B;Z W];case 1;M(:,p)=[-B;W;B;A];case 2;M(:,q)=[-B;A;B;W];
    end
    K=M*K;Ni(:,:,i)=K*T;S(e,e)=S(e,e)+T'*Ni(:,:,i);Qfi(:,i)=M*Qf;Pf(e)=Pf(e)+T'*M*(Qf+Qfs);Ei(:,i)=e;
end
V=1-(D.Re|D.St);f=find(V);V(f)=S(f,f)\(D.Load(f)-Pf(f));R=reshape(S*V(:)+Pf,6,n);R(f)=0;V=V+D.St;
for i=1:m
    Q(:,i)=Ni(:,:,i)*V(Ei(:,i))+Qfi(:,i);
end