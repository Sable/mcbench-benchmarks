% Chapter 0 - A Tutorial Introduction to MATLAB and the Symbolic Math Package.
% Tutorial Two - Plots and differential equations.
% Copyright Birkhaser 2013. Stephen Lynch.

% These commands should be run in the Command Window.
% Copy the commands into the Command Window.

clear
% Plot a simple function.
x=-2:.01:2;
plot(x,x.^2)                            

% Plot two functions on one graph.
t=0:.1:100;
y1=exp(-.1*t).*cos(t);y2=cos(t);
plot(t,y1,t,y2),legend('y1','y2')       

% Symbolic plots.
ezplot('x^2',[-2,2])                    
ezplot('exp(-t)*sin(t)'),xlabel('time'),ylabel('current'),title('decay')

% 3-D plots on a 50x50 grid.
ezcontour('y^2/2-x^2/2+x^4/4',[-2,2],50)
ezsurf('y^2/2-x^2/2+x^4/4',[-2,2],50)
ezsurfc('y^2/2-x^2/2+x^4/4',[-2,2],50)

% Parametric plot.
ezplot('t^3-4*t','t^2',[-3,3])

% 3-D parametric plot.
ezplot3('sin(t)','cos(t)','t',[-10,10])

% Symbolic solutions to o.d.e's.
dsolve('Dx=-x/t')
dsolve('D2x+5*Dx+6*x=10*sin(t)','x(0)=0','Dx(0)=0')

% Linear systems of o.d.e's.
[x,y]=dsolve('Dx=3*x+4*y','Dy=-4*x+3*y')
[x,y]=dsolve('Dx=x^2','Dy=y^2','x(0)=1,y(0)=1')

% A 3-D linear system.
[x,y,z]=dsolve('Dx=x','Dy=y','Dz=-z')

% Numerical solutionms to o.d.e's.
deq1=inline('x(1)*(.1-.01*x(1))','t','x');
[t,xa]=ode45(deq1,[0 100],50);
plot(t,xa(:,1))

% A 2-D system.
deq2=inline('[.1*x(1)+x(2);-x(1)+.1*x(2)]','t','x');
[t,xb]=ode45(deq2,[0 50],[.01,0]);
plot(xb(:,1),xb(:,2))

% A 3-D system.
deq3=inline('[x(3)-x(1);-x(2);x(3)-17*x(1)+16]','t','x');
[t,xc]=ode45(deq3,[0 20],[.8,.8,.8]);
plot3(xc(:,1),xc(:,2),xc(:,3))

% A stiff system.
deq4=inline('[x(2);1000*(1-(x(1))^2)*x(2)-x(1)]','t','x');
[t,xd]=ode23s(deq4,[0 3000],[.01,0]);
plot(xd(:,1),xd(:,2))

% x versus t.
plot(t,xd(:,1))

% End of Tutorial 2.






