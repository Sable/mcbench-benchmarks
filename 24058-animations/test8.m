%animation of ball
[k,l,m]=sphere(30);
h1=surf(2.5*k,2.5*l,2.5+2.5*m,'Facecolor',[0 0 0],'edgecolor','none');

camlight headlight,lighting phong
hold on

x=-20:0.5:20;
y=x;
[X,Y]=meshgrid(x,y);
r=sqrt((X).^2+(Y).^2);
r1=sqrt((-2+X).^2+(0+Y).^2);
r2=sqrt((-4+X).^2+(0+Y).^2);
r3=sqrt((-6+X).^2+(0+Y).^2);
r4=sqrt((-8+X).^2+(0+Y).^2);
r5=sqrt((-10+X).^2+(0+Y).^2);
r6=sqrt((-12+X).^2+(0+Y).^2);


z=sinc(0.2*r);
h=surf(X,Y,z,'Facecolor','blue','edgecolor','none');
camlight headlight; lighting phong
axis([-20 20 -20 20 -20 20]),view(3)


hold off
axis off
set(gcf,'color',[1 1 1])
view(113,45)
grid off

z1=[];
%M = moviein(91);
n=0;
while (n<=90)&&ishandle(h)
    set(h1,'xdata',n/5+2.5*k,'zdata',...
        2.5+2.5*m+abs(9*exp(-0.03*n)*sin(0.9*pi*n)));
    
    
    z1=0.4*sinc(r-0.4*n*pi);
    z2=0.4*sinc(r1-0.4*(n-10)*pi);
    z3=0.4*sinc(r2-0.4*(n-20)*pi);
    z4=0.4*sinc(r3-0.4*(n-30)*pi);
    z5=0.4*sinc(r4-0.4*(n-40)*pi);
    z6=0.4*sinc(r5-0.4*(n-50)*pi);
    z7=0.4*sinc(r6-0.4*(n-60)*pi);

    z=z1+z2+z3+z4+z5+z6+z7;
    set(h,'zdata',z);
    %M(:,n+1)=getframe;
    n=n+1;
    drawnow
end
%movie(M,1,15);
