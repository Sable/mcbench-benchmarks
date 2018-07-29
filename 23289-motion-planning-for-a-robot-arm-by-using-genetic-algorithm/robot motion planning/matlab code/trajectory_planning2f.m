
global bound rng l1 l2
l1=1;l2=1;
hh=findobj(gcf,'tag','x1');
xs=str2num(get(hh,'string'));
hh=findobj(gcf,'tag','y1');
ys=str2num(get(hh,'string'));
hh=findobj(gcf,'tag','x2');
xg=str2num(get(hh,'string'));
hh=findobj(gcf,'tag','y2');
yg=str2num(get(hh,'string'));

qs=invkin(xs,ys);
qg=invkin(xg,yg);

para=[qs,qg ];%*pi/180;
%GA parameters
pops=200;
crossprop=0.8;
mutprop=0.05;
maxgen=80;
bound=[-pi    pi;
       -pi    pi;
       -pi/4  pi/4;
       -pi/4  pi/4;
       0      6;
       0      6];
   
%initialization
numvar=size(bound,1);
rng=(bound(:,2)-bound(:,1))';
pop=zeros(pops,numvar);
%pop = initial population
pop(:,1:numvar)=(ones(pops,1)*rng).*(rand(pops,numvar))+...
    (ones(pops,1)*bound(:,1)');
tic
for it=1:maxgen
    fpop=fitnesstra2f(pop,para);
    [cs,inds]=max(fpop);bchrom=pop(inds,:);
   % tournament selection
    toursize=5;
    players=ceil(pops*rand(pops,toursize));
    scores=fpop(players);
    [a,m]=max(scores');
    pind=zeros(1,pops);
    for ii=1:pops
        pind(ii)=players(ii,m(ii));
        parent(ii,:)=pop(pind(ii),:);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%crossover%%%%%%%%%%%%%%%%%%%%%%%%%%%
          offs=cross_singlepoint(parent,crossprop);

    moffs=mutate1(offs,mutprop);
    pop=moffs;
    mm=fitnesstra2f(pop,para);
    maxf(it)=max(fpop);    
    [bfit,bind]=max(mm);
    bsol=pop(bind,:);
    rec=recor2(bsol,para);
    trec(it)=rec(1);
    qrec(it)=rec(2);
    drec(it)=rec(3);
    torrec(it)=rec(4);
    if mm(inds) < cs
    pop(inds,:)=bchrom;
    end
    %*************************plot results
    qs1=para(1);qs2=para(2);
    qm1=bsol(1);qm2=bsol(2);
    qg1=para(3);qg2=para(4);
    
    [xs1,ys1]=pol2cart(qs1,l1);
    [xs2,ys2]=pol2cart(qs2+qs1,l2);
    xxs1=linspace(0,xs1);
    yys1=linspace(0,ys1);
    xxs2=linspace(0,xs2);xxs2=xxs2+xs1;
    yys2=linspace(0,ys2);yys2=yys2+ys1;
    
    [xm1,ym1]=pol2cart(qm1,l1);
    [xm2,ym2]=pol2cart(qm2+qm1,l2);
    xxm1=linspace(0,xm1);
    yym1=linspace(0,ym1);
    xxm2=linspace(0,xm2);xxm2=xxm2+xm1;
    yym2=linspace(0,ym2);yym2=yym2+ym1;
    
    [xg1,yg1]=pol2cart(qg1,l1);
    [xg2,yg2]=pol2cart(qg2+qg1,l2);
    xxg1=linspace(0,xg1);
    yyg1=linspace(0,yg1);
    xxg2=linspace(0,xg2);xxg2=xxg2+xg1;
    yyg2=linspace(0,yg2);yyg2=yyg2+yg1;
    xs=[xxs1,xxs2];ys=[yys1,yys2];
    xm=[xxm1,xxm2];ym=[yym1,yym2];
    xg=[xxg1,xxg2];yg=[yyg1,yyg2];
    kk=trajt(para,bsol);
    bq=kk(1:2,[5,10,15,20,25,30,35]);
    pq=kk(1:2,:);
    pcart=forkin(pq);
    px=pcart(1,:);py=pcart(2,:);
    if it==maxgen
      [xxt,yyt]=angls2links2(bq); 
      figure,plot(xxt',yyt')
      xlabel('x(m)')
      ylabel('y(m)')
      hold on
    end
    plot(px,py)
    hold on
    axis([-2.5 2.5 -2.5 2.5])
    text(1.75,2.4,['gen. No.',num2str(it)]);
    plot(xs,ys,xm,ym,xg,yg)
    hold off
    pause(0)
end
toc
e=[1:maxgen];
figure,plot(e,1./maxf)
xlabel('generation')
ylabel('min. fitness')
% h = legend('min.fitness',2);
tt=torque(kk(1:6,:));

t1=bsol(5);ti1=linspace(0,t1,20);
t2=bsol(6);ti2=linspace(t1,t2+t1,20);
time=[ti1 ti2];

q1=kk(1,:);q2=kk(2,:);
figure,plot(time,q1,'r--',time,q2,'g--+',time(20),q1(20),'ko',time(20),q2(20),'ko')
xlabel('Time(s)')
ylabel('joint angle(rad)')
h = legend('joint 1','joint 2',1);
v1=kk(3,:);v2=kk(4,:);
figure,plot(time,v1,'r--',time,v2,'g--+',time(20),v1(20),'ko',time(20),v2(20),'ko')

xlabel('Time(s)')
ylabel('joint velocity(rad/s)')
h = legend('joint 1','joint 2',1);

a1=kk(5,:);a2=kk(6,:);
figure,plot(time,a1,'r--',time,a2,'g--+',time(20),a1(20),'ko',time(20),a2(20),'ko')

xlabel('Time(s)')
ylabel('joint acceleration(rad/s^2)')
h = legend('joint 1','joint 2',1);
figure,plot(time,tt(1,:),'r--',time,tt(2,:),'g--+',time(20),tt(1,20),'ko',time(20),tt(2,20),'ko')

xlabel('Time(s)')
ylabel('joint torque(N.m)')
h = legend('joint 1','joint 2',1);

figure,plot(e,trec)
% title('consumed time for point to point motion')
xlabel('generation')
ylabel('consumed time for point to point motion(s)')
figure,plot(e,qrec)
% title('total joint distance ')
xlabel('generation')
ylabel('total joint distance(rad)')
figure,plot(e,drec)
% title('total cartesian trajectory length')
xlabel('generation')
ylabel('total cartesian trajectory length(m)')
figure,plot(e,torrec)
% title('total excessive torque')
xlabel('generation')
ylabel('total excessive torque(N.m)')
bsol'