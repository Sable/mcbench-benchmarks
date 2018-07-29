%P2.12      %Commutation Property      %x1(n)*x2(n)=x2(n)*x1(n)
nx=[-20:30]; x1=nx.*(stepseq(-10,-20,30)- stepseq(20,-20,30));
x2=cos(0.1*pi*nx).*(stepseq(0,-20,30)- stepseq(30,-20,30));
%x1(n)*x2(n)
[y1,m1]=conv_m(x1,nx,x2,nx);    figure(1);
subplot(2,2,1);stem(m1,y1,'k');title('x1*x2');xlabel('m');
%x2(n)*x1(n)
[y1,m1]=conv_m(x2,nx,x1,nx);
subplot(2,2,2);stem(m1,y1,'k');title('x2*x1');xlabel ('m');

%Association Property   %[x1(n)*x2(n)]*x3(n)=x1(n)*[x2(n)*x3(n)]
nx=[-20:30]; x1=nx.*(stepseq(-10,-20,30)- stepseq(20,-20,30));
x2=cos(0.1*pi*nx).*(stepseq(0,-20,30)- stepseq(30,-20,30));
x3=1.2.^nx.*(stepseq(-5,-20,30)-stepseq(10,-20,30));
[y1,m1]=conv_m(x1,nx,x2,nx);
[y2,m2]=conv_m(y1,m1,x3,nx);
subplot(2,2,3);stem(m2,y2,'k');title('[x1*x2]*x3');xlabel('m');
[y1,m1]=conv_m(x2,nx,x3,nx);
[y2,m2]=conv_m(x1,nx,y1,m1);;
subplot(2,2,4);stem(m2,y2,'k');title('x1*[x2*x3]');xlabel('m');

%Distribution Property %x1(n)*[x2(n)]+x3(n)]=x1(n)*x2(n)+x1(n)*x3(n)
nx=[-20:30]; x1=nx.*(stepseq(-10,-20,30)- stepseq(20,-20,30));
x2=cos(0.1*pi*nx).*(stepseq(0,-20,30)- stepseq(30,-20,30));
x3=1.2.^nx.*(stepseq(-5,-20,30)-stepseq(10,-20,30));
[y1,m1]=sigadd(x2,nx,x3,nx);
[y2,m2]=conv_m(x1,nx,y1,m1);    figure(2);
subplot(2,2,1);stem(m2,y2,'k');title('x1*[x2+x3]');xlabel('m');
[y1,m1]=conv_m(x1,nx,x2,nx);
[y2,m2]=conv_m(x1,nx,x3,nx);
[y3,m3]=sigadd(y1,m1,y2,m2);
subplot(2,2,2);stem(m3,y3,'k');title('x1*x2+x1*x3]');xlabel('m');

%Identity    %x1(n)*d(n-n0)= x1(n-n0)
nx=[-20:30]; x1=nx.*(stepseq(-10,-20,30)- stepseq(20,-20,30));
%x1(n)*delta(n-n0)
[y1,m1]=impseq(10,-20,30);
[y2,m2]=conv_m(x1,nx,y1,m1);
subplot(2,2,3);stem(m2,y2,'k');title('x1*delta(nn0)'); xlabel('m');
[y1,m1]=sigshift(x1,nx,10);
subplot(2,2,4);stem(m1,y1,'k');title('x1(nn0)]');xlabel('m');
axis([-40 60 -10 20]);