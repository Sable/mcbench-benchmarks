% The following script calculates and plots the
% two-phase multipliers for steam-water systems at
% various pressures between 0 and 40% quality at
% pressures of 3,6, 9, and 11 MPa (and mass flux of
% 3000 kg/m2s for the Collier-Jones TPM
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

clear
% Set the pressure from 100 kPa to 22 MPa
P=[100 1000 3000 6000 9000 11000 15000 19000 22000]; 

% Set the qualities between 0 and 100 %
X=linspace(0,0.4,50); % up to 40%

% Set the mass flux (kg/m^2s)
MFLUX=3000;

% Calculate the H2O properties 
for j=3:6    % set the outer loop size to the number of pressures up to 11 MPa
   for i=1:50  %set the inner loop size to the number of qualities
      cm(i,j) =tpm_cm(P(j),X(i)); %Chenoweth-Martin TPM
      hom(i,j)=tpm_cm(P(j),X(i)); %Homogeneous TPM
      mn(i,j) =tpm_mn(P(j),X(i)); %Martinelli-Nelson TPM
      cj(i,j) =tpm_cj(P(j),X(i),MFLUX); %Collier-Jones TPM
      fs(i,j) =tpm_fs(P(j),X(i)); %Fitzsimmons TPM
 end
end

figure(1)
orient landscape;
subplot(1,2,1)
plot(X,cm)
axis tight;
h=legend('3000 kPa','6000 kPa','9000 kPa','11000 kPa',2);
set(findobj(h,'type','text'),'FontUnits','points','FontSize',8);
xlabel('{Quality} (fraction)');
ylabel('{\Phi^2_{cm}}');
%title ('{\bf Chenoweth-Martin Two-phase multiplier}','FontSize',10);
title ('{\bf Chenoweth-Martin Two-phase multiplier}');

%figure(2)
%orient landscape;
subplot(1,2,2)
plot(X,hom)
axis tight;
h=legend('3000 kPa','6000 kPa','9000 kPa','11000 kPa',2);
set(findobj(h,'type','text'),'FontUnits','points','FontSize',8);
xlabel('{Quality} (fraction)');
ylabel('{\Phi^2_{cm}}');
%title ('{\bf Homogeneous Two-phase multiplier}','FontSize',10);
title ('{\bf Homogeneous Two-phase multiplier}');

figure(2)
orient landscape;
subplot(1,2,1)
plot(X,mn)
axis tight;
h=legend('3000 kPa','6000 kPa','9000 kPa','11000 kPa',2);
set(findobj(h,'type','text'),'FontUnits','points','FontSize',8);
xlabel('{Quality} (fraction)');
ylabel('{\Phi^2_{mn}}');
title ('{\bf Martinelli-Nelson TPM}','FontSize',10);

subplot(1,2,2)
plot(X,fs)
axis tight;
h=legend('3000 kPa','6000 kPa','9000 kPa','11000 kPa',2);
set(findobj(h,'type','text'),'FontUnits','points','FontSize',8);
xlabel('{Quality} (fraction)');
ylabel('{\Phi^2_{fs}}');
title ('{\bf Fitzsimmons TPM}','FontSize',10);

figure(3)
orient landscape;
subplot(1,2,1)
plot(X,cj)
axis tight;
h=legend('3000 kPa','6000 kPa','9000 kPa','11000 kPa',2);
set(findobj(h,'type','text'),'FontUnits','points','FontSize',8);
xlabel('{Quality} (fraction)');
ylabel('{\Phi^2_{cj}}');
title ('{\bf Collier-Jones TPM (G=3000kg/m^2s)}','FontSize',10);

