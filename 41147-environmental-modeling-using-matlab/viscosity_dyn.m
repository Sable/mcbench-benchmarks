% Viscosity Intercomparison  
%   Dynamic viscosity of water in dependency of temperature   
%   
%   Ref: 

%   $Ekkehard Holzbecher  $Date: 2006/03/10 $

T_1 = [0:1:16];
mu_1 = 1.8e-3-06.55e-5*T_1+1.44e-6*T_1.*T_1;                % Hagen 1839 acc. to Prandtl/Tientjes
T_2 = [0:1:75];                                               
mu_2 = 0.001779./(1+0.03368*T_2+0.00022099*T_2.*T_2);       % Poiseuille 1840 acc. to Lamb 
T_3 = [100:1:300];
mu_3 = 241.4e-7*10.^(247.8./(T_3+132.15));                  % JSME 1968 
T_4 = [5:1:25];
mu_4 = 1.31*1.e-3./(0.7 + 0.03*T_4);                        % Gavich 1985 
T_5 = [0:1:100];
mu_5 = 0.001*(1.+0.636*(T_5-20)/41).^(-1/0.636);            % Pawlowski 1991 
T_6 = [15:1:35];
mu_6 = 1.98404e-6*exp(1825.85./(273+T_6));                  % Lin e.a. 2003  

plot (T_1,mu_1,'r',T_2,mu_2,'g',T_4,mu_4,'m',T_5,mu_5,'c',T_6,mu_6,'b')
legend ('Hagen','Poiseuille','Gavich e.a.','Pawlowski','Lin e.a.');
xlabel ('Temperature [°C]'); ylabel ('dynamic viscosity [Pa s]');

grid;