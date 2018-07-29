function MU = h2o_mu(T,RHO)
% H2O_MU  Dynamic viscosity at a given temperature and density
% H2O_MU(T,RHO) Returns the dynamic viscosity at a given temperature and density.
% Dynamic viscosity in (Pa s) i.e., (kg/ms)
% Based on the correlation given in Appendix 6 of the 
% ASME STEAM TABLES - SIXTH EDITION
% Range of validity of equation:
%    P<=500MPa for   0°C <= T <= 150°C
%    P<=350MPa for 150°C <= T <= 600°C
%    P<=300MPa for 600°C <= T <= 900°C
% Called function: none
%  Required Inputs are: T   - temperature in °C
%                       RHO - density in kg/m^3
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

%Reference temperature 647.27K
Tstar=647.27;
%Reference density 317.763 kg/m^3
RHOstar=317.763;
%Reference pressure 22.115x10^6 Pa
Pstar=22.115e6;
%Reference viscosity 55.071x10^-6 Pa s (or kg/ms)
mustar=55.071e-6;

%Coefficients H_i for  mu_0
HI=[1 0.978197 0.579829 -0.202354];

%Coefficients H_ij for  mu_1
HIJ(1:6,1:7)=0; %the coefficients not listed are all 0, so first set the matrix elements to 0
H00=0.5132047; %
HIJ(1,1)=H00;
H10=0.3205656; %
HIJ(2,1)=H10;
H40=-0.7782567; %
HIJ(5,1)=H40;
H50=0.1885447; %
HIJ(6,1)=H50;
H01=0.2151778; %
HIJ(1,2)=H01;
H11=0.7317883; %
HIJ(2,2)=H11;
H21=1.241044; %
HIJ(3,2)=H21;
H31=1.476783; %
HIJ(4,2)=H31;
H02=-0.2818107; %
HIJ(1,3)=H02;
H12=-1.070786; %
HIJ(2,3)=H12;
H22=-1.263184; %
HIJ(3,3)=H22;
H03=0.1778064; %
HIJ(1,4)=H03;
H13=0.4605040; %
HIJ(2,4)=H13;
H23=0.2340379; %
HIJ(3,4)=H23;
H33=-0.4924179; %
HIJ(4,4)=H33;
H04=-0.04176610; %
HIJ(1,5)=H04;
H34=0.1600435; %
HIJ(4,5)=H34;
H15=-0.01578386; %
HIJ(2,6)=H15;
H36=-0.003629481; %
HIJ(4,7)=H36;


T1=T+273.15; %convert the temperature from °C to K
Tbar=T1/Tstar;

% In the viscosity equation the firs (mu0) term of the product gives the viscosity
% of the steam in the ideal-gas limit and calculated from:
comp1=0;
for i=1:4
   comp1=comp1+(HI(i)/Tbar^(i-1));
end
mu0=sqrt(Tbar)/comp1;

% The second multiplicative factor is
RHObar=RHO/RHOstar;
comp2=0;
for i=1:6
   for j=1:7
      comp2=comp2+HIJ(i,j)*(((1/Tbar)-1)^(i-1)*(RHObar-1)^(j-1));
   end
end
mu1=exp(RHObar*comp2);

% The reduced viscosity is
mubar=mu0*mu1;

% The dynamic viscosity is calculated from the reduced and reference viscosities
MU=mubar*mustar;

return

