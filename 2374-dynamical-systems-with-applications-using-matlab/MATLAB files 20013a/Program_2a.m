% Chapter 2 - Nonlinear Discrete Dynamical Systems.
% Program 2a - Graphical Iteration of the Tent Map.
% Symbolic Math toolbox required.
% Copyright Birkhauser 2013. Stephen Lynch.

% Plot a cobweb diagram (Figure 2.7(b)).
clear
% Initial condition 0.2001, must be symbolic.
nmax=200;
t=sym(zeros(1,nmax));t1=sym(zeros(1,nmax));t2=sym(zeros(1,nmax));
t(1)=sym(2001/10000);
mu=2;
halfm=nmax/2;
axis([0 1 0 1]);
for n=2:nmax
    if (double(t(n-1)))>0 && (double(t(n-1)))<=1/2
            t(n)=sym(2*t(n-1));
        else
            if (double(t(n-1)))<1 
                t(n)=sym(2*(1-t(n-1)));
            end
    end
end

for n=1:halfm
    t1(2*n-1)=t(n);
    t1(2*n)=t(n);
end

t2(1)=0;t2(2)=double(t(2));
for n=2:halfm
    t2(2*n-1)=double(t(n));
    t2(2*n)=double(t(n+1));
end
hold on
fsize=20;
plot(double(t1),double(t2),'r');
x=[0 0.5 1];y=[0 mu/2 0];
plot(x,y,'b');
x=[0 1];y=[0 1];
plot(x,y,'g');
title('Graphical iteration for the tent map','FontSize',fsize)
set(gca,'XTick',0:0.2:1,'FontSize',fsize)
set(gca,'YTick',0:0.2:1,'FontSize',fsize)
xlabel('x','FontSize',fsize)
ylabel('T','FontSize',fsize)
hold off

% End of Program 2a.
