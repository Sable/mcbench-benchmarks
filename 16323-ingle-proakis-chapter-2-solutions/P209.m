%P2.9a
%T1[x(n)]=2^x(n)
n=[0:200];x=cos(0.2*pi*n)+0.5*cos(0.6*pi*n);
t1=2.^x
[x1,n1]=sigshift(t1,n,50); %x(n-k) -> k=50
[x2,n2]=sigfold(t1,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t1,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
figure(1);
subplot(3,1,1); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');


%T2[x(n)]=3x(n)+4
n=[0:200];x=cos(0.2*pi*n)+0.5*cos(0.6*pi*n);
t2=3*x+4
[x1,n1]=sigshift(t2,n,50); %x(n-k) -> k=50
[x2,n2]=sigfold(t2,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t2,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
subplot(3,1,2); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');


%T3[x(n)]=x(n)+2x(n-1)-x(n-2)
n=[0:200];x=cos(0.2*pi*n)+0.5*cos(0.6*pi*n);
[xa,nxa]=sigshift(x,n,1);
[xb,nxb]=sigshift(x,n,2);
[xa,nxa]=sigadd(2*xa,nxa,-1*xb,nxb);
[t3,n]=sigadd(x,n,xa,nxa)
[x1,n1]=sigshift(t3,n,50); %x(n-k) -> k=50
[x2,n2]=sigfold(t3,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t3,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
subplot(3,1,3); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');

%P2.9b
%T1[x(n)]=2^x(n)
%x(n)=random sequence
nrand=[0:100];xrand=rand(size(nrand));
t1=2.^xrand
[x1,n1]=sigshift(t1,n,50); %x(n-k) k=50
[x2,n2]=sigfold(t1,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t1,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
figure(2);
subplot(3,1,1); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');


%T2[x(n)]=3x(n)+4
%x(n)=random sequence
nrand=[0:100];xrand=rand(size(nrand));
t2=3*xrand+4
[x1,n1]=sigshift(t2,n,50); %x(n-k) -> k=50
[x2,n2]=sigfold(t2,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t2,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
subplot(3,1,2); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');


%T3[x(n)]=x(n)+2x(n-1)-x(n-2)
%x(n)=Random Sequence
nrand=[0:100];xrand=rand(size(nrand));
[xa,nxa]=sigshift(xrand,nrand,1);
[xb,nxb]=sigshift(xrand,nrand,2);
[xa,nxa]=sigadd(2*xa,nxa,-1*xb,nxb);
[t3,n]=sigadd(xrand,nrand,xa,nxa);
[x1,n1]=sigshift(t3,n,50); %x(n-k) -> k=50
[x2,n2]=sigfold(t3,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t3,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
subplot(3,1,3); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');

%P2.9c
%T1[x(n)]=2^x(n)
%x(n)=Gaussian random sequence
nrand=[0:100];xrand=randn(size(nrand))
t1=2.^xrand
[x1,n1]=sigshift(t1,n,50); %x(n-k) k=50
[x2,n2]=sigfold(t1,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t1,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
figure(3);
subplot(3,1,1); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');


%T2[x(n)]=3x(n)+4
%x(n)=Gaussian random sequence
nrand=[0:100];xrand=randn(size(nrand))
t2=3*xrand+4
[x1,n1]=sigshift(t2,n,50); %x(n-k) -> k=50
[x2,n2]=sigfold(t2,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t2,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
subplot(3,1,2); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');

%T3[x(n)]=x(n)+2x(n-1)-x(n-2)
%x(n)=Gaussian Random Sequence
nrand=[0:100];xrand=randn(size(nrand));
[xa,nxa]=sigshift(xrand,nrand,1);
[xb,nxb]=sigshift(xrand,nrand,2);
[xa,nxa]=sigadd(2*xa,nxa,-1*xb,nxb);
[t3,n]=sigadd(xrand,nrand,xa,nxa);
[x1,n1]=sigshift(t3,n,50); %x(n-k) -> k=50
[x2,n2]=sigfold(t3,n); %x(-n)
[x3,n3]=sigfold(x1,n1); %x(k-n)
[rxx,nrxx]=conv_m(t3,n,x2,n2);
[rxk,nrkx]=conv_m(x1,n1,x3,n3);
[y,m]=sigadd(rxx,nrxx,0.1*rxk,nrkx);
subplot(3,1,3); stem(m,y,'k');title('Autocorrelation ryy');xlabel('m');