% McCabe and Thiele Graphical Method for Binary Distillation 
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

% Main program calls function equilib and plots McCabe and Thiele Diagram

global y

% Equilibrium curve computation using function equilib 
% and constant relative volatility alpha=2.45

for i=1:11
    y=0.1*(i-1);
    ye(i)=0.1*(i-1);
    xe(i)=fzero('equilib',0.5);
end

% Distillate, Bottom and Feed mole fractions are equal to 90 % mol, 10 % mol
% and 50 % mol respectively.

xd=0.9;
xb=0.1;
zf=0.5;

% Reflux ratio is equal to 1.51435

R=1.51435;

% Feed is a Two-phase mixture with feed quality equal to 0.85

q=0.85;

% Computing the intersection of feed line and operating lines

yi=(zf+xd*q/R)/(1+q/R);
xi=(-(q-1)*(1-R/(R+1))*xd-zf)/((q-1)*R/(R+1)-q);

figure(1);
hold on;
AXIS([0 1 0 1]);

% plotting operating and feed lines and equilibrium curve

plot(xe,ye,'r');
set(line([0  1],[0  1]),'Color',[0 1 0]);
set(line([xd xi],[xd yi]),'Color',[1 0 1]);
set(line([zf xi],[zf yi]),'Color',[1 0 1]);
set(line([xb xi],[xb yi]),'Color',[1 0 1]);

% Stepping off stages. Feed plate is optimum.

% Rectifying section

i=1;
xp(1)=xd;
yp(1)=xd;
y=xd;
while (xp(i)>xi),
    xp(i+1)=fzero('equilib',0.5);
    yp(i+1)=R/(R+1)*xp(i+1)+xd/(R+1);
    y=yp(i+1);
    set(line([xp(i) xp(i+1)],[yp(i) yp(i)]),'Color',[0 0 1]);
    if (xp(i+1)>xi) set(line([xp(i+1) xp(i+1)],[yp(i) yp(i+1)]),'Color',[0 0 1]);
    end
        i=i+1;
end    

% Stripping section

SS=(yi-xb)/(xi-xb);
yp(i)=SS*(xp(i)-xb)+xb;
y=yp(i);
set(line([xp(i) xp(i)],[yp(i-1) yp(i)]),'Color',[0 0 1]);

while (xp(i)>xb),
    xp(i+1)=fzero('equilib',0.5);
    yp(i+1)=SS*(xp(i+1)-xb)+xb;
    y=yp(i+1);
    set(line([xp(i) xp(i+1)],[yp(i) yp(i)]),'Color',[0 0 1]);
    if (xp(i+1)>xb) set(line([xp(i+1) xp(i+1)],[yp(i) yp(i+1)]),'Color',[0 0 1]);
    end
    i=i+1;
end        
hold off;
