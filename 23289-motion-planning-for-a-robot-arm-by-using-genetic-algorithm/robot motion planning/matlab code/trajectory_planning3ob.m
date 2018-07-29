
global bound rng l1 l2 l3 ox oy 

hh=findobj(gcf,'tag','obx');
obx=str2mat(get(hh,'string'));
hh=findobj(gcf,'tag','oby');
oby=str2mat(get(hh,'string'));
shx=eval(obx);shy=eval(oby);
rx=.35;ry=.35;
n=length(shx);
l=linspace(0,2*pi,30);
m=length(l);
xv=repmat(rx*cos(l)',1,n)+repmat(shx,m,1);
yv=repmat(ry*sin(l)',1,n)+repmat(shy,m,1);
ox=[xv;xv(1,:)];oy=[yv;yv(1,:)];

l1=1;l2=1;l3=0.5;

hh=findobj(gcf,'tag','x1');
xs=str2num(get(hh,'string'));

hh=findobj(gcf,'tag','y1');
ys=str2num(get(hh,'string'));

hh=findobj(gcf,'tag','phi');
phis=str2num(get(hh,'string'));

hh=findobj(gcf,'tag','x2');
xf=str2num(get(hh,'string'));

hh=findobj(gcf,'tag','y2');
yf=str2num(get(hh,'string'));

phi=phis*pi/180;
[k,confi]=invkini(xs,ys,phi);
if k > 1
    warndlg('non valid initial conditions..... change the initial conditions','!! error !!')
    clear
    return
end
if sqrt(xf^2+yf^2)==2.5
   warndlg('there is no redundancy..... change final position','!! error !!')
   clear
   return
end 
para=[confi xf yf];
%GA parameters
pops=40;
crossprop=0.8;
mutprop=0.05;
maxgen=80;
bound=[ -pi     pi;% qm1
        -pi     pi;% qm2
        -pi     pi;% qm3
        -pi     pi;% phif
       -0.4   0.4;% vqm1 
       -0.4   0.4;% vqm2
       -0.4   0.4;% vqm3
        0       8;% t1 
        0       8];%t2

%initialization
numvar=size(bound,1);
rng=(bound(:,2)-bound(:,1))';
pop=zeros(pops,numvar);
%pop = initial population
pop(:,1:numvar)=(ones(pops,1)*rng).*(rand(pops,numvar))+...
    (ones(pops,1)*bound(:,1)');
tic
for it=1:maxgen
    [fpop,z]=fitnesstra3ob(pop,para);
    pop(:,4)=z';
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
    offs=cross_singlepoint(parent,crossprop);
    %mutate1=uniform mutation.
    moffs=mutate1(offs,mutprop);
    pop=moffs;
    [mm,z]=fitnesstra3ob(pop,para);
    pop(:,4)=z';
    maxf(it)=max(mm);
    [bfit,bind]=max(mm);
    bsol=pop(bind,:);
    rec=recor(bsol,para);
    trec(it)=rec(1);
%   qrec(it)=rec(2);
    fvq(it)=rec(2);
    drec(it)=rec(3);
    torrec(it)=rec(4);
    if mm(inds) < cs
    pop(inds,:)=bchrom;
    end
    %*************************plot results
    
    qs1=para(1);qs2=para(2);qs3=para(3);
    qm1=bsol(1);qm2=bsol(2);qm3=bsol(3);
    [w,conff]=invkin3(para(4),para(5),bsol(4));
    qg1=conff(1);qg2=conff(2);qg3=conff(3);
    
%     [xxs1,yys1,xxs2,yys2,xxs3,yys3]=angls2links(qs1,qs2,qs3);
    
    [xs1,ys1]=pol2cart(qs1,l1);
    [xs2,ys2]=pol2cart(qs2+qs1,l2);
    [xs3,ys3]=pol2cart(qs3+qs2+qs1,l3);
    
    xxs1=linspace(0,xs1);
    yys1=linspace(0,ys1);
    xxs2=linspace(0,xs2);xxs2=xxs2+xs1;
    yys2=linspace(0,ys2);yys2=yys2+ys1;
    xxs3=linspace(0,xs3);xxs3=xxs3+xs2+xs1;
    yys3=linspace(0,ys3);yys3=yys3+ys2+ys1;
    

% [xxm1,yym1,xxm2,yym2,xxm3,yym3]=angls2links(qm1,qm2,qm3);
    
    [xm1,ym1]=pol2cart(qm1,l1);
    [xm2,ym2]=pol2cart(qm2+qm1,l2);
    [xm3,ym3]=pol2cart(qm3+qm2+qm1,l3);
    
    xxm1=linspace(0,xm1);
    yym1=linspace(0,ym1);
    xxm2=linspace(0,xm2);xxm2=xxm2+xm1;
    yym2=linspace(0,ym2);yym2=yym2+ym1;
    xxm3=linspace(0,xm3);xxm3=xxm3+xm2+xm1;
    yym3=linspace(0,ym3);yym3=yym3+ym2+ym1;

% [xxg1,yyg1,xxg2,yyg2,xxg3,yyg3]=angls2links(qg1,qg2,qg3);
    
    [xg1,yg1]=pol2cart(qg1,l1);
    [xg2,yg2]=pol2cart(qg2+qg1,l2);
    [xg3,yg3]=pol2cart(qg3+qg2+qg1,l3);
    
    xxg1=linspace(0,xg1);
    yyg1=linspace(0,yg1);
    xxg2=linspace(0,xg2);xxg2=xxg2+xg1;
    yyg2=linspace(0,yg2);yyg2=yyg2+yg1;
    xxg3=linspace(0,xg3);xxg3=xxg3+xg2+xg1;
    yyg3=linspace(0,yg3);yyg3=yyg3+yg2+yg1;
    
    xt=[xxs1;xxs2;xxs3;xxm1;xxm2;xxm3;xxg1;xxg2;xxg3];
   
    yt=[yys1;yys2;yys3;yym1;yym2;yym3;yyg1;yyg2;yyg3];
    
    cond=[confi,conff];
    chrom=[bsol(1:3),bsol(5:end)];
    kk=trajt3(cond,chrom);
    pq=kk(1:3,[5,7,10,13,15,17,20,23,25,27,30,33,35]);
    pcart=forkin3(kk(1,:),kk(2,:),kk(3,:));
    px=pcart(1,:);py=pcart(2,:);
%     clf
    if it==maxgen
      [xxt,yyt]=angls2links(pq); 
      figure,plot(xxt',yyt')
      xlabel('x(m)')
      ylabel('y(m)')
      hold on
    end
    plot(px,py,ox,oy,'r')
    hold on
    axis([-2.7 2.7 -2.7 2.7])
    text(0,2.6,['gen. no.',num2str(it)])
    plot(xt',yt')
    hold off
    pause(0)
end
toc
e=[1:maxgen];
figure,plot(e,1./maxf)
xlabel('generation')
ylabel('min. fitness')
tt=torque3(kk);

t1=bsol(8);ti1=linspace(0,t1,20);
ti2=bsol(9);ti2=linspace(t1,ti2+t1,20);
time=[ti1,ti2];

figure,plot(time,kk(1,:),'r--',time,kk(2,:),'g--+',time,kk(3,:),'b-*',time(20),kk(1,20),'ko',time(20),kk(2,20),'ko',time(20),kk(3,20),'ko')
h = legend('joint 1','joint 2','joint 3',2);
xlabel('Time(s)')
ylabel('joint angle(rad)')
figure,plot(time,kk(4,:),'r--',time,kk(5,:),'g--+',time,kk(6,:),'b-*',time(20),kk(4,20),'ko',time(20),kk(5,20),'ko',time(20),kk(6,20),'ko')
h = legend('joint 1','joint 2','joint 3',2);
xlabel('Time(s)')
ylabel('joint velocity(rad/s)')
figure,plot(time,kk(7,:),'r--',time,kk(8,:),'g--+',time,kk(9,:),'b-*',time(20),kk(7,20),'ko',time(20),kk(8,20),'ko',time(20),kk(9,20),'ko')
h = legend('joint 1','joint 2','joint 3',2);
xlabel('Time(s)')
ylabel('joint acceleration(rad/s^2)')

figure,plot(time,tt(1,:),'r--',time,tt(2,:),'g--+',time,tt(3,:),'b-*',time(20),tt(1,20),'ko',time(20),tt(2,20),'ko',time(20),tt(3,20),'ko')
h = legend('joint 1','joint 2','joint 3',2);
xlabel('Time(s)')
ylabel('joint torque(N.m)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure,plot(e,trec)
xlabel('generation')
ylabel('consumed time for point to point motion(s)')
figure,plot(e,fvq)
xlabel('generation')
ylabel('total joint distance(rad)')
figure,plot(e,drec)
xlabel('generation')
ylabel('total cartesian trajectory length(m)')
figure,plot(e,torrec)
xlabel('generation')
ylabel('total excessive torque(N.m)')
bsol'