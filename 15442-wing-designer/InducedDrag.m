function [CDi] = InducedDrag(gamma, geo, panel)
%Calculate far field induced drag

%The following code is derived from James A. Blackwell, Numerical Method to
%Calculate the Induced Drag or Optimum Loading for Arbitrary Non-Planar
%Aircraft, NASA SP-405, May 1976

%Determine the normal force coefficient for each lifting element along the
%load perimeter in the Trefftz plane (see figure 6) according to equation
%10
cn_c_per_c_av = 2*sum(reshape([gamma.c] + geo.alpha*[gamma.alpha],geo.ns,geo.nc),2)/geo.c_av;  %Eqn 10 non-dimensionalized by c_av as in Eqn 18

for i = 1:geo.ns
    yi(i) = -panel(i,geo.nc).CP(2);
    zi(i) = -panel(i,geo.nc).CP(3);  %Negative sign due to change in axes
    thetai(i) = geo.dih;
    for j = 1:geo.ns
        yj(j) = -panel(j,geo.nc).CP(2);
        zj(j) = -panel(j,geo.nc).CP(3);
        thetaj(j) = geo.dih;

        yprime(i,j) = (yi(i)-yj(j))*cos(thetaj(j)) + (zi(i) - zj(j))*sin(thetaj(j));    %Eqn 8
        zprime(i,j) = -(yi(i)-yj(j))*sin(thetaj(j)) + (zi(i) - zj(j))*cos(thetaj(j));   %Eqn 9
        R1(i,j) = zprime(i,j)^2 + (yprime(i,j) - panel(j,geo.nc).s)^2;       %Eqn 6
        R2(i,j) = zprime(i,j)^2 + (yprime(i,j) + panel(j,geo.nc).s)^2;        %Eqn 7
        A(i,j) = 1/(4*pi)*(((yprime(i,j)-panel(j,geo.nc).s)/R1(i,j)-(yprime(i,j)+panel(j,geo.nc).s)/R2(i,j))*cos(thetai(i)-thetaj(j))...
            +(zprime(i,j)/R1(i,j)-zprime(i,j)/R2(i,j))*sin(thetai(i)-thetaj(j)));  %Eqn 16
        cdi(i,j)=cn_c_per_c_av(i)*cn_c_per_c_av(j)*2*panel(i,geo.nc).s/geo.b*A(i,j); %Eqn 18
    end
end
CDi = -sum(sum(cdi,1),2);


