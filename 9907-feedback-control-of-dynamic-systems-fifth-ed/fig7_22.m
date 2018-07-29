%  Figure 7.22      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%% fig7_22.m
%% tradeoff curve for LQR
clf;
f=[0 1;0 0];
g=[0;1];
h=[1 0];
j=0;
sys=ss(f,g,h,j);
display('This computation takes several seconds');
% Initial condition
xo=[1 1]';
r=1;
i=1;
for rho=0.01:0.1:100;
   q=rho*h'*h;
   [k,s]=lqr(f,g,q,r);
   acl=f-g*k;
   w1=gram(acl',h');
   yy(i)=xo'*w1*xo;
   w2=gram(acl',k');
   uu(i)=xo'*w2*xo;
   jj(i)=xo'*s*xo;
   i=i+1;
end;
plot(uu,yy);
grid;
Title('Fig. 7.22: Trade-off curve');
text(uu(1)+1,yy(1),'\rho=0.01');
text(uu(1000)-2,yy(1000)+1,'\rho=100');
text(uu(11),yy(11)+1,'\rho=1');
line([uu(1) uu(1)],[yy(100) yy(1)],'LineStyle','--');
line([uu(1) uu(100)],[yy(100) yy(100)],'LineStyle','--');
text(uu(1),yy(1),'x');
text(uu(1000),yy(1000),'x');
text(uu(11),yy(11),'x');
xlabel('\int_0^\infty u^2dt')
ylabel('\int_0^\infty z^2dt');

