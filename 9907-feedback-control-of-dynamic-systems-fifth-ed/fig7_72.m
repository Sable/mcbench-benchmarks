%  Figure 7.72      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
% LTR Example 
% 
clf;
F=[0 1; 0 0]; % define system matrices
G=[0;1];
H=[1 0];
J=[0];
sys0=ss(F,G,H,J); % form system
H1=[1 0];
sys=ss(F,G,H1,J);
w=logspace(-1,3,1000); % form frequency vector
rho=1;
Q=rho*H1'*H1;          % define weights
r=1;
[K]=lqr(F,G,Q,r)       % compute LQR gain
sys1=ss(F,G,K,0);      % form loop gain
[maggk1,phasgk1,w]=bode(sys1,w); % Bode plot of loop gain
%pause;
rv=1;
rho=[1 10 100];
% LTR
for i=1:3,
    gam=rho(i)*G;
    Q1=gam'*gam;
    [L]=lqe(F,gam,H,Q1,rv)
    aa=F-G*K-L*H;
    bb=L;
    cc=K;
    dd=0;
    sysk=ss(aa,bb,cc,dd);
    sysgk=series(sys0,sysk);
    [maggk,phsgk,w]=bode(sysgk,w);
    [gm,phm,wcg,wcp]=margin(maggk,phsgk,w)
    subplot(2,1,1);
    loglog(w,[maggk1(:) maggk(:)]);
    xlabel('\omega (rad/sec)');
    ylabel('Magnitude');
    title('Fig. 7.72: loop gain');
    axis([0.1 1000 1e-8 1e3]);
    text(100,10e-8,'q=1');
    text(100,10e-6,'q=10');
    line([0.1 1000],[1 1]);
    line([10.5356 10.5356],[1 0.1]);
    text(11,0.5,'GM');
    text(100,10e-4,'q=100');
    text(300,1e-2,'LQR');
    grid on;
    hold on;
    subplot(2,1,2);
    semilogx(w,[phasgk1(:) phsgk(:)]);
    xlabel('\omega (rad/sec)');
    ylabel('Phase (deg)');
    text(10,-240,'q=1');
    text(10,-170,'q=10');
    text(10,-120,'q=100');
    grid;
    hold on;
 end;
axis([0.1 1000 -270 -90]);
set(gca,'YTick',[-270 -240 -210 -180 -150 -120 -90]);
set(gca,'YTickLabel',[-270 -240 -210 -180 -150 -120 -90]);
line([0.1 1000],[-180 -180]);
line([1.4124 1.4124],[-180+55.07 -180]);
text(2,-150,'PM');
text(1.1,-100,'LQR');

