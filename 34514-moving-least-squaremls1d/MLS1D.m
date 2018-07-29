% ONE-DIMENSIONAL MLS APPROXIMATION

clear all

% PROBLEM DIFINITION
l  = 10.0;
dx =0.5;

% SET UP NODAL COORDINATES 
xi = [0.0 : dx : l];
nnodes = length(xi);

% SET UP COORDINATES OF EVALUATION POINTS
x = [0.0 : 0.05 : l];
npoints = length(x);

% DETERMINE RADIUS OF SUPPORT OF EVERY NODE
scale = 3;
dm = scale *dx * ones(1, nnodes);

% Evaluate MLS shape function at all evaluation points x
[PHI, DPHI, DDPHI] = MLS1DShape(1, nnodes, xi, npoints, x, dm, 'GAUSS', 3.0);

% Output Shape functions and their derivates
fid1 = fopen('shp.dat','w');
fid2 = fopen('dshp.dat','w');
fid3 = fopen('ddshp.dat','w');

fprintf(fid1,'%10s%10s%10s%10s\n', ' ', 'N1','N11','N21');
fprintf(fid2,'%10s%10s%10s%10s\n', ' ', 'N1','N11','N21');
fprintf(fid3,'%10s%10s%10s%10s\n', ' ', 'N1','N11','N21');

for j = 1 : npoints
   fprintf(fid1,'%10.4f', x(j));
   fprintf(fid2,'%10.4f', x(j));
   fprintf(fid3,'%10.4f', x(j));
   
   fprintf(fid1,'%10.4f%10.4f%10.4f\n',  PHI(j,1),  PHI(j,11),  PHI(j,21));
   fprintf(fid2,'%10.4f%10.4f%10.4f\n', DPHI(j,1), DPHI(j,11), DPHI(j,21));
   fprintf(fid3,'%10.4f%10.4f%10.4f\n',DDPHI(j,1),DDPHI(j,11),DDPHI(j,21));
end
   
fclose(fid1);
fclose(fid2);
fclose(fid3);

% PLOTING SHPAE FUNCTIONS
figure
subplot(1,3,1);
plot(x, PHI(:,1));
hold on
plot(x, PHI(:,11));
plot(x, PHI(:,21));

subplot(1,3,2);
plot(x, DPHI(:,1));
hold on
plot(x, DPHI(:,11));
plot(x, DPHI(:,21));

subplot(1,3,3);
plot(x, DDPHI(:,1));
hold on
plot(x, DDPHI(:,11));
plot(x, DDPHI(:,21));

% Curve fitting. y = sin(x)
yi  = sin(xi);    % Nodal function values
y   = sin(x);     % Exact solution
yh  = PHI * yi';  % Approximation function
err = norm(y' - yh) / norm(y) * 100  % Relative error norm in approximation function

figure
subplot(1,3,1);
plot(x, y, x, yh);

dy   = cos(x);
dyh  = DPHI * yi';  % First order derivative of approximation function
errd = norm(dy' - dyh) / norm(dy) * 100  % Relative error norm in the first order derivative

subplot(1,3,2);
plot(x, dy, x, dyh);

ddy   = -sin(x);
ddyh  = DDPHI * yi';  % Second order derivative of approximation function
errdd = norm(ddy' - ddyh) / norm(ddy) * 100  % Relative error norm in second order derivative

subplot(1,3,3);
plot(x, ddy, x, ddyh);

% Output approximate functions and their derivates
fid1 = fopen('fun.dat','w');
fid2 = fopen('dfun.dat','w');
fid3 = fopen('ddfun.dat','w');

fprintf(fid1,'%10s%10s%10s\n', ' ', 'Exact','Appr');
fprintf(fid2,'%10s%10s%10s\n', ' ', 'Exact','Appr');
fprintf(fid3,'%10s%10s%10s\n', ' ', 'Exact','Appr');

for j = 1 : npoints
   fprintf(fid1,'%10.4f', x(j));
   fprintf(fid1,'%10.4f%10.4f\n', y(j), yh(j));
   
   fprintf(fid2,'%10.4f', x(j));
   fprintf(fid2,'%10.4f%10.4f\n', dy(j), dyh(j));
   
   fprintf(fid3,'%10.4f', x(j));  
   fprintf(fid3,'%10.4f%10.4f\n', ddy(j), ddyh(j));
end
   
fclose(fid1);
fclose(fid2);
fclose(fid3);

