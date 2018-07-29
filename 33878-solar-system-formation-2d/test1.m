n=1000; % number of balls
% n=5;
d0=sqrt(1/n); % disstance between bals

% d=10;
mm=100; % total mass
m=mm/n; % mass of a ball;
G=1; % gravitational constant
al=0.3; % friction coeficent
rmx=30; % maximal distance not delete

dt=0.0001;
tm=400;
t=0:dt:tm;

d=10*(G*m*dt^2/4*pi^2)^(1/3); % ball size, diameter


% for limits:
b=1;
bb=[-b b];

idm=1/d;

hfl=['history_' num2str(now*1e6,'%16.0f') '.mat']; % history filename

r=randn(1,n,2); % random initial coordinates
v=0.005*randn(1,n,2); % random initial velocities


f=no_fly_away_frequency(G,mm,r);

v=bsxfun(@minus,v,(mean(v,2))); % go to centroid
r=bsxfun(@minus,r,(mean(r,2)));


v=add_rotation(v,r,f,n);

%v=10*ones(1,n,2);

hp=plot(r(1,:,1),r(1,:,2),'k.');
ht=title(' ');
axis equal;
%xlim(bb);
%ylim(bb);
dlc=5;
lc=1;
tic;
for tt=t
    %[id id2 nn]=invers_distancies(r,n);
    F=calulate_forcies(r,n,G,idm,al,v);
    
    % integrate:
    v=v+(F/m)*dt;
    r=r+v*dt;
    
    if mod(lc,dlc)==0
    
        set(hp,'Xdata',r(1,:,1),'Ydata',r(1,:,2));
        mr=(mean(r,2));
        bb1=bb+mr(1,1,1);
        bb2=bb+mr(1,1,2);
%         xlim(bb);
%         ylim(bb);

        set(ht,'string',['lc=' num2str(lc)]);
        drawnow;
        
        %[r v n]=delete_far_points(r,v,rmx,n);
        
    end
      
    lc=lc+1;
    
end
toc

