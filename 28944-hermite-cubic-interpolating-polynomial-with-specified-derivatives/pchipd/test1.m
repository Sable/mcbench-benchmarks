
% functions
f1 = @(x) exp(-x.^2);
df1 = @(x) -2*x.*exp(-x.^2);

f2 = @(x) x.*sin(x)+x;
df2 = @(x) sin(x) + x.*cos(x)+1;

% domain
a = -4;
b = 4;

% interpolation points
ni = 7;
xi = linspace(a,b,ni);

% interpolation data
yi1 = f1(xi);
di1 = df1(xi);
yi2 = f2(xi);
di2 = df2(xi);

Y = [yi1; yi2];
D = [di1; di2];

% interpolation struct
pp = pchipd(xi,Y,D)

% plot points
np = 100;
xp = linspace(a,b,np);
Yp = ppval(pp,xp);

% true data
yt1 = f1(xp);
yt2 = f2(xp);

figure(1)
clf
hold on
plot(xp,yt1,'g')
plot(xp,Yp(1,:))
plot(xi,yi1,'ro')

figure(2)
clf
hold on
plot(xp,yt2,'g')
plot(xp,Yp(2,:))
plot(xi,yi2,'ro')

figure(3)
clf
hold on
plot(yt1,yt2,'g')
plot(Yp(1,:),Yp(2,:))
plot(yi1,yi2,'ro')