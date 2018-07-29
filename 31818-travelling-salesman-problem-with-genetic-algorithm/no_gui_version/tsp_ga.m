nn=40; % number of cities
asz=10; % area size   asx x asz


ps=3000; % population size
ng=5000; % number of generation

pm=0.01; % probability of mutation of exchange 2 random cities in the path (per gene, per genration)
pm2=0.02; % probability of mutation of exchange 2 peices of path (per gene, per genration)
pmf=0.08; % probability of mutation  of flip random pece of path

r=asz*rand(2,nn); % randomly distribute cities
% r(1,:) -x coordinaties of cities
% r(2,:) -y coordinaties of cities

% % uncomment to make circle:
% % circle
% al1=linspace(0,2*pi,nn+1);
% al=al1(1:end-1);
% r(1,:)=0.5*asz+0.45*asz*cos(al);
% r(2,:)=0.5*asz+0.45*asz*sin(al);

dsm=zeros(nn,nn); % matrix of distancies
for n1=1:nn-1
    r1=r(:,n1);
    for n2=n1+1:nn
        r2=r(:,n2);
        dr=r1-r2;
        dr2=dr'*dr;
        drl=sqrt(dr2);
        dsm(n1,n2)=drl;
        dsm(n2,n1)=drl;
    end
end

% start from random closed pathes:
G=zeros(ps,nn); % genes, G(i,:) - gene of i-path, G(i,:) is row-vector with cities number in the path
for psc=1:ps
    G(psc,:)=randperm(nn);
end

figure('units','normalized','position',[0.05 0.2 0.9 0.6]);

subplot(1,2,1);

% to plot best path:
hpb=plot(NaN,NaN,'r-');
ht=title(' ');

hold on;

% plot nodes numbers
for n=1:nn
    text(r(1,n),r(2,n),num2str(n),'color',[0.7 0.7 0.7]);
end

plot(r(1,:),r(2,:),'k.'); % plot cities as black dots



axis equal;
xlim([-0.1*asz 1.1*asz]);
ylim([-0.1*asz 1.1*asz]);

subplot(1,2,2);
hi=imagesc(G);
title('color is city number');
colorbar;
xlabel('index in sequence of cities');
ylabel('path number');

pthd=zeros(ps,1); %path lengths
p=zeros(ps,1); % probabilities
for gc=1:ng % generations loop
    % find paths length:
    for psc=1:ps
        Gt=G(psc,:);
        pt=0; % path length summation
        for nc=1:nn-1
            pt=pt+dsm(Gt(nc),Gt(nc+1));
        end
        % last and first:
        pt=pt+dsm(Gt(nn),Gt(1));
        pthd(psc)=pt;
    end
    ipthd=1./pthd; % inverse path lengths, we want to maximize inverse path length
    p=ipthd/sum(ipthd); % probabilities
    
    [mbp bp]=max(p); 
    Gb=G(bp,:); % best path 
    
    % update best path on figure:
    if mod(gc,5)==0
        set(hpb,'Xdata',[r(1,Gb) r(1,Gb(1))],'YData',[r(2,Gb) r(2,Gb(1))]);
        set(ht,'string',['generation: ' num2str(gc)  '  best path length: ' num2str(pthd(bp))]);
        set(hi,'CData',G);
        drawnow;
    end
    
    
    % crossover:
    ii=roulette_wheel_indexes(ps,p); % genes with cities numers in ii will be put to crossover
    % length(ii)=ps, then more probability p(i) of i-gene then more
    % frequently it repeated in ii list
    Gc=G(ii,:); % genes to crossover
    Gch=zeros(ps,nn); % childrens
    for prc=1:(ps/2) % pairs counting
        i1=1+2*(prc-1);
        i2=2+2*(prc-1);
        g1=Gc(i1,:); %one gene
        g2=Gc(i2,:); %another gene
        cp=ceil((nn-1)*rand); % crossover point, random number form range [1; nn-1]
        
      
        % two childrens:
        g1ch=insert_begining(g1,g2,cp);
        g2ch=insert_begining(g2,g1,cp);
        Gch(i1,:)=g1ch;
        Gch(i2,:)=g2ch;
    end
    G=Gch; % now children
    
    
    % mutation of exchange 2 random cities:
    for psc=1:ps
        if rand<pm
            rnp=ceil(nn*rand); % random number of sicies to permuation
            rpnn=randperm(nn);
            ctp=rpnn(1:rnp); %chose rnp random cities to permutation
            Gt=G(psc,ctp); % get this cites from the list
            Gt=Gt(randperm(rnp)); % permutate cities
            G(psc,ctp)=Gt; % % return citeis back
         end
    end
    
    % mutation of exchange 2 peices of path:
    for psc=1:ps
        if rand<pm2
            cp=1+ceil((nn-3)*rand); % range [2 nn-2]
            G(psc,:)=[G(psc,cp+1:nn) G(psc,1:cp)];
        end
    end
    
    % mutation  of flip randm pece of path:
    for psc=1:ps
        if rand<pmf
            n1=ceil(nn*rand);
            n2=ceil(nn*rand);
            G(psc,n1:n2)=fliplr(G(psc,n1:n2));
        end
    end
    
    

    
    G(1,:)=Gb; % elitism
    
    
        
end
