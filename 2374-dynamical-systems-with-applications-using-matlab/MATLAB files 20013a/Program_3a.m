% Chapter 3 - Complex Iterative Maps.
% Program 3a - Julia Sets.
% Copyright Birkhauser 2013. Stephen Lynch.

% Plot the Julia set J(0,1.1) (Figure 3.1(d)).
clear
k=15;niter=2^k;
x=zeros(1,niter);y=zeros(1,niter);
x1=zeros(1,niter);y1=zeros(1,niter);
a=0;b=1.1;
x(1)=real(0.5+sqrt(0.25-(a+1i*b)));
y(1)=imag(0.5+sqrt(0.25-(a+1i*b)));
% Check that the point is unstable.
isunstable=2*abs(x(1)+1i*y(1))

hold on
for n=1:niter
    x1=x(n);y1=y(n);
    u=sqrt((x1-a)^2+(y1-b)^2)/2;v=(x1-a)/2;
    u1=sqrt(u+v);v1=sqrt(u-v);
    x(n+1)=u1;y(n+1)=v1;
    if y(n)<b 
        y(n+1)=-y(n+1);
    end
    if rand < .5
       x(n+1)=-u1;y(n+1)=-y(n+1);
    end
end

fsize=15;
plot(x,y,'k.','MarkerSize',1)
set(gca,'XTick',-1.6:0.4:1.6,'FontSize',fsize)
set(gca,'YTick',-1.2:0.4:1.2,'FontSize',fsize)
xlabel('Re z','FontSize',fsize)
ylabel('Im z','FontSize',fsize)
hold off

% End of Program 3a.