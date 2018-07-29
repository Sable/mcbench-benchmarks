% The following script calculates the saturation
% properties of H2O and plots the results
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

clear
nop=50;
not=5;
% Set the pressure from 100 kPa to 22 MPa
P=linspace(100,19700,nop); 

% Det the temperature from 20°C to 370°C
T=linspace(20,364,not); 


% Calculate the H2O properties 
for j=1:not    % set the outer loop size to the number of temperatures
   for i=1:nop  %set the inner loop size to the number of pressures
      [i j];
    tsat(i,j)=h2o_tsat(P(i));
    psat(i,j)=h2o_psat(T(j));
    sigma(i,j)=h2o_sigma(T(j));
    rhof(i,j)=h2o_rhof(P(i));
    rhog(i,j)=h2o_rhog(P(i));
    muf(i,j)=h2o_muf(P(i));
    mug(i,j)=h2o_mug(P(i));
 end
end

figure(1)
orient landscape;
subplot(2,2,1)
plot(P,tsat)
axis tight;
xlabel('{\bf Pressure} (kPa)');
ylabel('{\bf Saturation Temperature} (°C)');
title ('{\bf T_{sat} vs. P}','FontSize',10);

%figure(2)
%orient landscape;
subplot(2,2,3)
plot(P,psat)
axis tight;
xlabel('{\bf Pressure} (kPa)');
ylabel('{\bf Saturation Pressure} (kPa)');
title ('{\bf P_{sat} vs. P}','FontSize',10);

%figure(3)
%orient landscape;
subplot(2,2,2)
plot(P,sigma)
axis tight;
%semilogx(P,sigma)
xlabel('{\bf Pressure}(kPa)');
ylabel('{\bf Sigma} (N/m)');
title ('{\bf Surface tension vs. P}','FontSize',10);

figure(2)
%figure(4)
orient landscape;
subplot(2,2,1)
plot(P,rhof)
axis tight;
xlabel('{\bf Pressure}(kPa)');
ylabel('{\bf \rho_f} (kg/m^3)');
title ('{\bf \rho_f vs. P}','FontSize',10);

%figure(5)
%orient landscape;
subplot(2,2,3)
plot(P,rhog)
axis tight;
xlabel('{\bf Pressure}(kPa)');
ylabel('{\bf \rho_g} (kg/m^3)');
title ('{\bf \rho_g vs. P}','FontSize',10);

%figure(6)
%orient landscape;
subplot(2,2,2)
plot(P,muf)
axis tight;
xlabel('{\bf Pressure}(kPa)');
ylabel('{\bf \mu_f} (kg/ms)');
title ('{\bf Dynamic Viscosity  (\mu_f) vs. P}','FontSize',10);

%figure(7)
%orient landscape;
subplot(2,2,4)
plot(P,mug)
axis tight;
xlabel('{\bf Pressure}(kPa)');
ylabel('{\bf \mu_g} (kg/ms)');
title ('{\bf Dynamic Viscosity (\mu_g) vs. P}','FontSize',10);
