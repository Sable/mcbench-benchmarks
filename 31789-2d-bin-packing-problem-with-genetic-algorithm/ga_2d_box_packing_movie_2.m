% main box sizes:
a=2;
b=1;

Nb=30; % number of boxes

% random boxes sizes:
mab=mean([a b]);
aa=0.05*mab+0.3*mab*rand(1,Nb);
bb=0.05*mab+0.3*mab*rand(1,Nb);
m2=min([aa bb]/2); % smallest half-size
AA=aa.*bb; % boxes areas

penalty=0.2*a*b;
nac=0.8; % negative area coefficient


N=500; % population size
ng=1500; % number of generations
pmpe=0.05; % places exchange mutation probability
pmbj=0.01; % big gauss jump
pmsj=0.02; % small gauss jump
pmrr=0.05; % random rotation
pmvi=0.05; % random visible/invisible
pmne=0.1; % move to nearest adge

figure;
%ha1=axes;
ha1=subplot(2,1,1);
plot([0 a a 0 0], [0 0 b b 0],'b-');
xlim([-0.1*a 1.1*a]);
ylim([-0.1*b 1.1*b]);
set(ha1,'NextPlot','add');
ht=title(ha1,'start');
ha2=subplot(2,1,2);
ylabel('individual number');
title('genes');
colorbar;
drawnow;


set_cl; % set color table cl to plot boxes with different colors



% random initial population:
G=zeros(N,4*Nb);
Gch=zeros(N,4*Nb); % children
for Nc=1:N % for each individual
    G1=zeros(4,Nb); % one individual
    % G1(1,i)=1 if i-box is visible
    % G1(2,i)=1 if i-box is rotated at 90 degrees
    % G1(3,i) - x-coordinate of i-box center
    % G1(4,i) - y-coordinate of i-box center

    G1(1,:)=double(rand(1,Nb)<0.2);
    G1(2,:)=double(rand(1,Nb)<0.5);
    
    G1(3,:)=m2+(a-m2)*rand(1,Nb);
    G1(4,:)=m2+(b-m2)*rand(1,Nb);
    
    
    G(Nc,:)=(G1(:))'; % (G1(:))' converts matrix to row-vector
end

hi=imagesc(G,'parent',ha2);
ylabel('individual number');
title('genes');
colorbar;
drawnow;


clear F;
fc=1;
Gpr1=zeros(4,Nb);
Gpr2=zeros(4,Nb); % two parents
Gch1=zeros(4,Nb);
Gch2=zeros(4,Nb); % two children
for ngc=1:ng % generations counting
    % find fitnesses:
    fitnesses=zeros(N,1);
    for Nc=1:N % for each individual
        G1(:)=(G(Nc,:))';
        vis=G1(1,:);
        ind=find(vis);
        L=length(ind);
        if L>0
            % only visible:
            rot=G1(2,ind);
            x=G1(3,ind);
            y=G1(4,ind);
            if L==1
                aaa=aa(ind);
                bbb=bb(ind);
                if rot
                    tmp=aaa;
                    aaa=bbb;
                    bbb=tmp;
                end
                A0=AA(ind); % box area
                x1=max([x-aaa/2  0]);
                y1=max([y-bbb/2  0]);
                x2=min([x+aaa/2  a]);
                y2=min([y+bbb/2  b]);
                % x1 - x2,  y1 - y2 is box (part of current box) that inside main box
                if (x1>=x2)||(y1>=y2)
                    A=0; % box that inside main box area
                else
                    A=(x2-x1)*(y2-y1); % box that inside main box area
                end
                %if A<A0 % if not fully inside main box
                if (aaa/2<=x)&&(x<=a-aaa/2)&&(bbb/2<=y)&&(y<=b-bbb/2) % if filly inside
                    fitness=A;
                else
                    fitness=A-nac*(A0-A)-penalty;
                end
                    
            else
                fitness=0;
                ispen=false; % true if penality
                
                % check cross with main box:
                % add boxes arreas and strong subtract out areas:
                for n=1:L % for each box
                    ind1=ind(n);
                    aaa=aa(ind1);
                    bbb=bb(ind1);
                    if rot(n)
                        tmp=aaa;
                        aaa=bbb;
                        bbb=tmp;
                    end
                    A0=AA(ind1); % box area
                    x1=max([x(n)-aaa/2  0]);
                    y1=max([y(n)-bbb/2  0]);
                    x2=min([x(n)+aaa/2  a]);
                    y2=min([y(n)+bbb/2  b]);
                    % x1 - x2,  y1 - y2 is box (part of current box) that inside main box
                    if (x1>=x2)||(y1>=y2)
                        A=0; % box that inside main box area
                    else
                        A=(x2-x1)*(y2-y1); % box that inside main box area
                    end
                    %if A<A0 % if not fully inside main box
                        %fitness=fitness + A-nac*(A0-A);
                        %ispen=true; % penality
                    %else
                        %fitness=fitness + A;
                    %end
                    
                    if (aaa/2<=x(n))&&(x(n)<=a-aaa/2)&&(bbb/2<=y(n))&&(y(n)<=b-bbb/2) % if filly inside
                        fitness=fitness + A;
                    else
                        fitness=fitness + A-nac*(A0-A);
                        ispen=true; % penality
                    end
                    
                end
                
                % for each pair of boxes:
                for n1=1:L-1
                    ind1=ind(n1);
                    aaa1=aa(ind1);
                    bbb1=bb(ind1);
                    if rot(n1)
                        tmp=aaa1;
                        aaa1=bbb1;
                        bbb1=tmp;
                    end
                    A1=AA(ind1);
                    x1=x(n1);
                    y1=y(n1); % position of 1st box of pair
                    for n2=n1+1:L
                        ind2=ind(n2);
                        aaa2=aa(ind2);
                        bbb2=bb(ind2);
                        if rot(n2)
                            tmp=aaa2;
                            aaa2=bbb2;
                            bbb2=tmp;
                        end
                        A2=AA(ind2);
                        x2=x(n2);
                        y2=y(n2); % position of 2nd box of pair
                        dx=abs(x1-x2);
                        dy=abs(y1-y2); % distancies
                        a12=(aaa1/2+aaa2/2);
                        b12=(bbb1/2+bbb2/2);
                        if (dx<a12)&&(dy<b12) % if cross
                            ispen=true;
                            Ac=(a12-dx)*(b12-dy); % area of cross
                            fitness=fitness-Ac-Ac; % becuse area of n1 and n2 was added fully
                            fitness=fitness-2*nac*Ac;
                        end

                    end
                end
                
                if ispen
                    fitness=fitness-penalty;
                end
        
            end
        else
            fitness=0;
        end
        fitnesses(Nc)=fitness;
    end
    
    [fb bi]=max(fitnesses); % best
    
    % plot best:
    G1(:)=(G(bi,:))';
    Gb=G(bi,:); % best
    if mod(ngc,10)==0
        cla(ha1);
        Atmp=0;
        for Nbc=1:Nb
            vis1=G1(1,Nbc);
            if vis1
                rot1=G1(2,Nbc);
                aaa=aa(Nbc);
                bbb=bb(Nbc);
                if rot1
                    tmp=aaa;
                    aaa=bbb;
                    bbb=tmp;
                end
                x=G1(3,Nbc);
                y=G1(4,Nbc);
                plot([x-aaa/2  x+aaa/2  x+aaa/2  x-aaa/2  x-aaa/2],...
                     [y-bbb/2  y-bbb/2  y+bbb/2  y+bbb/2  y-bbb/2],...
                     '-','color',cl(Nbc,:),...
                     'parent',ha1);
                hold on;
                Atmp=Atmp+aaa*bbb;
            end
        end
        plot([0 a a 0 0], [0 0 b b 0],'b-','parent',ha1);
        xlim(ha1,[-0.1*a 1.1*a]);
        ylim(ha1,[-0.1*b 1.1*b]);
        
        set(hi,'Cdata',G);
        
        nvb=length(find(G1(1,:))); % number of visible boxes
        
        set(ht,'string',[' generation: ' num2str(ngc)  ', boxes: ' num2str(nvb) ', area: ' num2str(fb)]);
        
        drawnow;
        
        F(fc)=getframe(gcf);
        fc=fc+1;
    end
    
    
    % prepare for crossover, selection:
    fmn=min(fitnesses);
    fst=std(fitnesses);
    if fst<1e-7
        fst=1e-7;
    end
    fmn1=fmn-0.01*fst; % little low then minimum
    P=fitnesses-fmn1; % positive values
    p=P/sum(P); % probabilities
    ii=roulette_wheel_indexes(N,p);
    Gp=G(ii,:); % parents
    
    % crossover:
    for n=1:2:N
        pr1=Gp(n,:);
        pr2=Gp(n+1,:); % two parents
        % in matrix form:
        Gpr1(:)=pr1'; 
        Gpr2(:)=pr2';
        
        for Nbc=1:Nb
            
            % visibility:
            if rand<0.5
                Gch1(1,Nbc)=Gpr1(1,Nbc);
            else
                Gch1(1,Nbc)=Gpr2(1,Nbc);
            end
            if rand<0.5
                Gch2(1,Nbc)=Gpr1(1,Nbc);
            else
                Gch2(1,Nbc)=Gpr2(1,Nbc);
            end
            
            % rotation:
            if rand<0.5
                Gch1(2,Nbc)=Gpr1(2,Nbc);
            else
                Gch1(2,Nbc)=Gpr2(2,Nbc);
            end
            if rand<0.5
                Gch2(2,Nbc)=Gpr1(2,Nbc);
            else
                Gch2(2,Nbc)=Gpr2(2,Nbc);
            end
            
            % position:
            % child 1:
            %i3=ceil(3*rand);
            %i3=roulette_wheel_indexes(1,[0.2 0.4 0.4]);
            i3=1+ceil(2*rand);
            switch i3
                case 1 % get mean position
                    Gch1(3,Nbc)=(Gpr1(3,Nbc)+Gpr2(3,Nbc))/2;
                    Gch1(4,Nbc)=(Gpr1(4,Nbc)+Gpr2(4,Nbc))/2;
                case 2 %get position of parent 1
                    Gch1(3,Nbc)=Gpr1(3,Nbc);
                    Gch1(4,Nbc)=Gpr1(4,Nbc);
                case 3 %get position of parent 2
                    Gch1(3,Nbc)=Gpr2(3,Nbc);
                    Gch1(4,Nbc)=Gpr2(4,Nbc);
            end
            % child 2:
            %i3=ceil(3*rand);
            %i3=roulette_wheel_indexes(1,[0.2 0.4 0.4]);
            i3=1+ceil(2*rand);
            switch i3
                case 1 % get mean position
                    Gch2(3,Nbc)=(Gpr1(3,Nbc)+Gpr2(3,Nbc))/2;
                    Gch2(4,Nbc)=(Gpr1(4,Nbc)+Gpr2(4,Nbc))/2;
                case 2 %get position of parent 1
                    Gch2(3,Nbc)=Gpr1(3,Nbc);
                    Gch2(4,Nbc)=Gpr1(4,Nbc);
                case 3 %get position of parent 2
                    Gch2(3,Nbc)=Gpr2(3,Nbc);
                    Gch2(4,Nbc)=Gpr2(4,Nbc);
            end
            
            
        end
        ch1=(Gch1(:))';
        ch2=(Gch2(:))';
        Gch(n,:)=ch1;
        Gch(n+1,:)=ch2;
        
        
    end
    G=Gch; % now children
    
    % mutations:
    % places exchange
    for Nc=1:N % for each individual
        if rand<pmpe
            G1(:)=(G(Nc,:))';
            ir1=ceil(Nb*rand);
            ir2=ceil(Nb*rand);
            tmp1=G1(3:4,ir1);
            G1(3:4,ir1)=G1(3:4,ir2);
            G1(3:4,ir2)=tmp1;
            G(Nc,:)=(G1(:))';
        end
    end
    
    % big gauss jump:
    for Nc=1:N % for each individual
        if rand<pmbj
            G1(:)=(G(Nc,:))';
            ir=ceil(Nb*rand);
            G1(3:4,ir)=G1(3:4,ir)+[0.05*a*randn;
                                   0.05*b*randn];
            G(Nc,:)=(G1(:))';
        end
    end
    
    % small gauss jump:
    for Nc=1:N % for each individual
        if rand<pmsj
            G1(:)=(G(Nc,:))';
            ir=ceil(Nb*rand);
            G1(3:4,ir)=G1(3:4,ir)+[0.005*a*randn;
                                   0.005*b*randn];
            G(Nc,:)=(G1(:))';
        end
    end
    
    % random rotation:
    for Nc=1:N % for each individual
        if rand<pmrr
            G1(:)=(G(Nc,:))';
            ir=ceil(Nb*rand);
            G1(2,ir)=double(rand<0.5);
            G(Nc,:)=(G1(:))';
        end
    end
    
    % random visible/invisible:
    for Nc=1:N % for each individual
        if rand<pmvi
            G1(:)=(G(Nc,:))';
            ir=ceil(Nb*rand);
            G1(1,ir)=double(rand<0.5);
            G(Nc,:)=(G1(:))';
        end
    end
    
    % move to nearest edge:
    for Nc=1:N % for each individual
        if rand<pmne
            G1(:)=(G(Nc,:))';
            ir=ceil(Nb*rand); % random small box
            rv=find((G1(1,:))&((1:Nb)~=Nc)); % find rest visible
            if rand<0.5
                % to veritcile edge
                eax=[G1(3,rv)-aa(rv)/2  G1(3,rv)+aa(rv)/2  0  a]; % edge xs
                deax=[(G1(3,ir)-aa(ir)/2) - eax  (G1(3,ir)+aa(ir)/2) - eax]; % distancies
                [dmn indm]=min(abs(deax));
                G1(3,ir)=G1(3,ir)-deax(indm);
            else
                % to horizontal edge
                eay=[G1(4,rv)-bb(rv)/2  G1(4,rv)+bb(rv)/2  0  b]; % edge ys
                deay=[(G1(4,ir)-bb(ir)/2) - eay  (G1(4,ir)+bb(ir)/2) - eay]; % distancies
                [dmn indm]=min(abs(deay));
                G1(4,ir)=G1(4,ir)-deay(indm);
            end
        end
    end
    
    
    
    % ellitism:
    G(1,:)=Gb;
    

    
    
    
end

movie2avi(F,'ga_2d_box_pack_2','fps',10,'compression','Cinepak'); 