%P2.17
%Rectangular Pulse
n=[-10:40];x=5*(stepseq(0,-10,40)- stepseq(20,-10,40));
[x1,n1]=sigshift(x,n,1);
[x2,n2]=sigadd(x,n,-1*x1,n1);
subplot(3,2,1);stem(n,x,'k');title('Rectangular Pulse')
subplot(3,2,2);stem(n2,x2,'k');title('Simple Digital Differentiator')
axis([-10,40,-5,5])

%Triangular Pulse
n=[-10:40];x=n.*(stepseq(0,-10,40)- stepseq(10,-10,40))+(20-n).*(stepseq(10,-10,40)- stepseq(20,-10,40));
[x1,n1]=sigshift(x,n,1);
[x2,n2]=sigadd(x,n,-1*x1,n1);
subplot(3,2,3);stem(n,x,'k');title('Triangular Pulse')
subplot(3,2,4);stem(n2,x2,'k');title('Simple Digital Differentiator')
axis([-10,40,-5,5])

%Sinusoidal Pulse
n=[-10:130];x=sin((pi*n)/25).*(stepseq(0,- 10,130)-stepseq(100,-10,130));
[x1,n1]=sigshift(x,n,1);
[x2,n2]=sigadd(x,n,-1*x1,n1);
subplot(3,2,5);stem(n,x,'k');title('Sinusoidal Pulse')
subplot(3,2,6);stem(n2,x2,'k');title('Simple Digital Differentiator')