% Plots of temperature, pressure and density with altitude increments.
sldata;
chart;
A=chart;

A(:,2)=A(:,2)*T1;
A(:,3)=A(:,3)*p1;
A(:,4)=A(:,4)*rho1;


% Absolute variables are separated in different vectors.

h=A(:,1);
T=A(:,2);
p=A(:,3);
rho=A(:,4);

plott;
figure;
plotp;
figure;
plotrho;