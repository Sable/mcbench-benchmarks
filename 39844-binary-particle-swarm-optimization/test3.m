%binary PSO eberhart

clc
clear all
close all
tic
Pbest1=10^65;
Gbest1=10^65;
for tt=1:10

    vec=3;
    popsize=100;
    bit=20;
    upb=mybin2dec(ones(1,bit));
    lowb=mybin2dec(zeros(1,bit));
    up=50;
    low=-50;
    % vec=3;
    N=vec;
    x=randint(popsize,bit*vec,[0 1]);
    vel=rand(popsize,bit*vec)-0.5;

    ff='testfunction1';
    vel=rand(popsize,bit*vec)-0.5;
    one_vel=rand(popsize,bit*vec)-0.5;
    zero_vel=rand(popsize,bit*vec)-0.5;

    for i=1:popsize
        xn=[];
        for j=1:N
            x1=x(i,1+(j-1)*bit:j*bit);
            x1=mybin2dec(x1)/(upb-lowb)*(up-low)+low;
            xn=[xn x1];
        end
        fx(i)=feval(ff,xn);
    end

    pbest=fx;
    xpbest=x;
    w1=0.5;
    [gbest l]=min(fx);
    xgbest=x(l,:);
    c1=1;
    c2=1;
    maxiter=1000;
    vmax=4;
    for iter=1:maxiter
        w=(maxiter-iter)/maxiter;
        w=0.5;
        for i=1:popsize
            xn=[];
            for j=1:N
                x1=x(i,1+(j-1)*bit:j*bit);
                x1=mybin2dec(x1)/(upb-lowb)*(up-low)+low;
                xn=[xn x1];
            end
            fx(i)=feval(ff,xn);
            if fx(i)<pbest(i)
                pbest(i)=fx(i);
                xpbest(i,:)=x(i,:);
            end
        end
        [gg l]=min(fx);
        if gbest>gg
            gbest=gg;
            xgbest=x(l,:);
        end
        
        oneadd=zeros(popsize,bit*vec);
        zeroadd=zeros(popsize,bit*vec);
        c3=c1*rand;
        dd3=c2*rand;
        for i=1:popsize
            for j=1:bit*vec
                if xpbest(i,j)==0

                    oneadd(i,j)=oneadd(i,j)-c3;
                    zeroadd(i,j)=zeroadd(i,j)+c3;
                else

                    oneadd(i,j)=oneadd(i,j)+c3;
                    zeroadd(i,j)=zeroadd(i,j)-c3;
                end
                if xgbest(j)==0

                    oneadd(i,j)=oneadd(i,j)-dd3;
                    zeroadd(i,j)=zeroadd(i,j)+dd3;
                else

                    oneadd(i,j)=oneadd(i,j)+dd3;
                    zeroadd(i,j)=zeroadd(i,j)-dd3;
                end
            end
        end
        one_vel=w1*one_vel+oneadd;
        zero_vel=w1*zero_vel+zeroadd;
        for i=1:popsize
            for j=1:bit*vec
                if abs(vel(i,j))>vmax
                    zero_vel(i,j)=vmax*sign(zero_vel(i,j));
                    one_vel(i,j)=vmax*sign(one_vel(i,j));
                end
            end
        end
        for i=1:popsize
            for j=1:bit*vec
                if x(i,j)==1
                    vel(i,j)=zero_vel(i,j);
                else
                    vel(i,j)=one_vel(i,j);
                end
            end
        end

        %%%%%%
        veln=logsig(vel);

        %%%%%%%%%%%%%%%%%
%         veln=logsig(vel);
        temp=rand(popsize,bit*vec);
        for i=1:popsize
            for j=1:bit*vec
                if temp(i,j)<veln(i,j)
                    x(i,j)=not(x(i,j));
                else
                    x(i,j)=(x(i,j));
                end
            end
        end
    end

    % clc
    if Gbest1>gbest
        Gbest1=gbest;
    end
    if Pbest1>sum(pbest)/popsize
        Pbest1=sum(pbest)/popsize;
    end

end
toc
Gbest1
Pbest1