n=400; % number of balls
% n=5;
d0=sqrt(1/n); % disstance between bals

% d=10;
mm=100; % total mass
m=mm/n; % mass of a ball;
G=1; % gravitational constant
al=1; % friction coeficent
rmx=30; % maximal distance not delete

dt=0.00005;
tm=400;
t=0:dt:tm;

%d=1*(G*m*dt^2/4*pi^2)^(1/3); % ball size, diameter
d=0.01;
f=0.8;


% for limits:
b=10;
bb=[-b b];

idm=1/d;

hfl=['history_' num2str(now*1e6,'%16.0f') '.mat']; % history filename

r=randn(1,n,2); % random initial coordinates
v=0.05*randn(1,n,2); % random initial velocities


%f=no_fly_away_frequency(G,mm,r);

v=bsxfun(@minus,v,(mean(v,2))); % go to centroid
r=bsxfun(@minus,r,(mean(r,2)));



v=add_rotation(v,r,f,n);

%v=10*ones(1,n,2);

hp=plot(r(1,:,1),r(1,:,2),'k.');
ht=title(' ');
axis equal;
%xlim(bb);
%ylim(bb);
dlc=20;

tic;

% for history:
hisrr=zeros(0,n,2); % hsitory r;
hisrv=zeros(0,n,2); % hsitory v;
hisr=false(size(t)); % when record history
hisrf=false(size(t)); % when record history to file
hisrT=20000/5; % history repated recording period
hisrd=1000; % record length
hisrt=zeros(size(t));
for lc=1:hisrT:length(t)
    hisr(lc:lc+hisrd)=true;
    hisrt(lc:lc+hisrd)=t(lc);
    
end
for lc=1:hisrT:length(t)
    hisrf(lc)=true;
end

lc=1;
for tt=t
    %[id id2 nn]=invers_distancies(r,n);
    F=calulate_forcies(r,n,G,idm,al,v);
    

%     if lc>100
%         break;
%     end
    
    % integrate:
    v=v+(F/m)*dt;
    r=r+v*dt;
    
    if mod(lc,dlc)==0
    
        set(hp,'Xdata',r(1,:,1),'Ydata',r(1,:,2));
        mr=(mean(r,2));
        bb1=bb+mr(1,1,1);
        bb2=bb+mr(1,1,2);
        xlim(bb);
        ylim(bb);

        set(ht,'string',['lc=' num2str(lc)]);
        drawnow;
        
        %[r v n]=delete_far_points(r,v,rmx,n);
        
    end
    
    % history recording:
    if hisr(lc)
        hisrr=cat(1,hisrr,r);
        hisrv=cat(1,hisrv,v);
    end
    
    if hisrf(lc)
        save(hfl,'hisrr','hisrv','lc','t','hisr','hisrf','hisrT','hisrd','n','mm','G','al','d','f','hisrt');
    end
      
    lc=lc+1;
    
end
toc

