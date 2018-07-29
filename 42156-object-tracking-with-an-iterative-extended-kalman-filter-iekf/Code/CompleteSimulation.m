% Script to start playing around with this stuff
clc; clear all; close all

% x  = [xc xcd zc zcd p1 p2 w].'

% simulation parameters
n = 100;                             % number of frames
xint = [-35 .7 35 .4 1 3 1].';       % initial state variable 
xest = [-32 .9 32 .6 1.2 2.2 .7].';  % initial state estimates
noise = .01;

% simulate dynamics
X = f_Simulate(xint,n);

% simulate observations
[OBS, OBSn] = f_Observe(X,noise);

% make movie
f_Movie(X,OBS,'SimMovie')

% run filter 
Xp = f_IEKF(OBSn,xest);

% make movie
OBSr = f_Observe(Xp,0);
f_Movie(Xp,OBSr,'ResultsMovie')

save RunData 

% pixel values
figure; 
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1)-100 pos(2)-200 1.5*pos(3) 1.5*pos(4)]);
plot(1:n,OBSn,'.-',1:n,OBSr,'.-'); grid on;
legend('X1 simulated','X2 simulated','X1 predicted','X2 predicted','Location','Best')
xlabel('Frame index (n)','FontName','Time','FontSize',15); 
ylabel('Image pixel value','FontName','Time','FontSize',15); 
title('Pixel observations with noise',...
    'FontName','Time','FontSize',15,'FontWeight','Bold'); 

Error = X - Xp;
 
% error (xc and zc)
figure; 
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1)-100 pos(2)-200 1.5*pos(3) 1.5*pos(4)]);
plot(1:n,Error([1 3],:),'.-'); grid on;
legend('xc','zc','Location','Best')
xlabel('Frame index (n)','FontName','Time','FontSize',15); 
ylabel('Error','FontName','Time','FontSize',15); 
title('Error in xc and zc',...
    'FontName','Time','FontSize',15,'FontWeight','Bold'); 

% error (xcd and zcd)
figure; 
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1)-100 pos(2)-200 1.5*pos(3) 1.5*pos(4)]);
plot(1:n,Error([2 4],:),'.-'); grid on;
legend('xcd','zcd','Location','Best')
xlabel('Frame index (n)','FontName','Time','FontSize',15); 
ylabel('Error','FontName','Time','FontSize',15); 
title('Error in \dot{xc} and \dot{zc}',...
    'FontName','Time','FontSize',15,'FontWeight','Bold'); 

% error (p1 w)
figure; 
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1)-100 pos(2)-200 1.5*pos(3) 1.5*pos(4)]);
plot(1:n,Error([5 7],:),'.-'); grid on;
legend('p1','w','Location','Best')
xlabel('Frame index (n)','FontName','Time','FontSize',15); 
ylabel('Error','FontName','Time','FontSize',15); 
title('Error in p1 and w',...
    'FontName','Time','FontSize',15,'FontWeight','Bold'); 