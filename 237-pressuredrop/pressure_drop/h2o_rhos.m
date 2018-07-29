function RHOS = h2o_rhos(T,P)
% H2O_RHOS  Superheated density at a given temperature and pressure
% H2O_RHOS(T,P) Returns the superheated density a given temperature
% and pressure.  Based on the correlation (Subsection 2) given in the 
% ASME STEAM TABLES - SIXTH EDITION
% Temperature and pressure ranges are above saturation 
%  Called function: h2o_psat(T), h2o_tsat(P) (if required)
%  Required Inputs are: T - temperature in °C
%                       P - pressure in kPa
% ---------------------------------------------------------------
%  The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

%check the pressure and temperature ranges
TS=374.15;
PS=22120;

%if T<374.15
%   TS=h2o_tsat(P); % calculate the saturation temperature
%   elseif P<22120
%      PS=h2o_psat(T); % calculate the saturation pressure
%   end
if and((T<374.15),(P<22120))
   TS=h2o_tsat(P); % calculate the saturation temperature
%   PS=h2o_psat(T); % calculate the saturation pressure
end

%if and((T<TS),(P<PS))
if T<TS
  error('Temperature and pressure are in the subcooled region - use the h2o_rhol function for subcooled water')
end

PIN=P*1000; %convert the pressure from kPa to Pa
T1=T+273.15; %convert the temperature from °C to K

% set up the constants
% the reduced temperature is calculated from theta=T/Tc1
% temperature constants used in the reduced temperature Tc1=647.3K
TC1=647.3; % and the reduced temperature is
theta=T1/TC1;

% The reduced pressure is: beta=ps/pc1
%where:  pc1=22120000 N/m^2
pc1=22120000; % and the reduced pressure is
beta=PIN/pc1;

%Derived form of rhe L-function and values of rhe constants relating thereto
%from Section 8.2
L0=1.574373327e1;
L1=-3.417061978e1;
L2=1.931380707e1;

betaL=L0+L1*theta+L2*theta^2;

% Primary constants for Subregion 2
B0=1.683599274e1;
B(100,1)=2.856067796e1; %B01 to B05 were renamed to B(100,1) to B(100,5)
B(100,2)=-5.438923329e1;
B(100,3)=4.330662834e-1;
B(100,4)=-6.547711697e-1;
B(100,5)=8.565182058e-2;
B(1,1)=6.670375918e-2;
B(1,2)=1.388983801e0;
B(2,1)=8.390104328e-2;
B(2,2)=2.614670893e-2;
B(2,3)=-3.373439453e-2;
B(3,1)=4.520918904e-1;
B(3,2)=1.069036614e-1;
B(4,1)=-5.975336707e-1;
B(4,2)=-8.847535804e-2;
B(5,1)=5.958051609e-1;
B(5,2)=-5.159303373e-1;
B(5,3)=2.075021122e-1;
B(6,1)=1.190610271e-1;
B(6,2)=-9.867174132e-2;
B(7,1)=1.683998803e-1;
B(7,2)=-5.809438001e-2;
B(8,1)=6.552390126e-3;
B(8,2)=5.710218649e-4;
B(9,10)=1.936587558e2; %B90 to B96 was renamed to B(9,10) to B(9,16) watch for the last summation x^v goes from v=0 to 6, so from 
B(9,11)=-1.388522425e3;
B(9,12)=4.126607219e3;
B(9,13)=-6.508211677e3;
B(9,14)=5.745984054e3;
B(9,15)=-2.693088365e3;
B(9,16)=5.235718623e2;

bb=7.633333333e-1;
b(6,1)=4.006073948e-1;
b(7,1)=8.636081627e-2;
b(8,1)=-8.532322921e-1;
b(8,2)=3.460208861e-1;

%mu=[1 2 3 4 5 6 7 8];
nmu=[2 3 2 2 3 2 2 2];
z=[13 3 0;
   18 2 1;
   18 10 0;
   25 14 0;
   32 28 24;
   12 11 0;
   24 18 0;
   24 14 0];

upsilon=[0 0 0 0 0 1 1 2];

xi=[0 0;
   0 0;
   0 0;
   0 0;
   0 0;
   14 0;
   19 0;
   54 27];

% -----------comp1-------------
% the 1st component of the summation for reduced volume
l1=4.260321148e0;
comp1=l1*theta/beta;
% -----------------------------
X=exp(bb*(1-theta));
% -----------comp2-------------
% the 2nd component of the summation for reduced volume
comp2=0;
comp2a=[0 0 0 0 0];
comp2b=[0 0 0 0 0];
for mu=1:5
   comp2a(mu)=mu*beta^(mu-1);
   for v=1:nmu(mu) 
     comp2b(mu)=comp2b(mu)+B(mu,v)*X^z(mu,v);
   end
   comp2c(mu)=comp2a(mu)*comp2b(mu);
end

for mu=1:5
   comp2=comp2+comp2c(mu);
end
% -----------------------------

% -----------comp3-------------
% the 3rd component of the summation for reduced volume
comp3=0;
comp3a=[0 0 0 0 0 0 0 0];
comp3b=[0 0 0 0 0 0 0 0];
comp3d=[0 0 0 0 0 0 0 0];
comp3e=[0 0 0 0 0 0 0 0];
comp3f=[0 0 0 0 0 0 0 0];
comp3g=[0 0 0 0 0 0 0 0];


for mu=6:8
   comp3a(mu)=(mu-2)*beta^(mu-1);
   for v=1:nmu(mu) 
      comp3b(mu)=comp3b(mu)+B(mu,v)*X^z(mu,v);
   end
   comp3c(mu)=comp3a(mu)*comp3b(mu); %the numerator of component 3
   
   comp3d(mu)=beta^(2-mu);
   for lambda=1:upsilon(mu) 
      comp3e(mu)=comp3e(mu)+b(mu,lambda)*X^xi(mu,lambda);
   end
   comp3f(mu)=(comp3d(mu)+comp3e(mu))^2; %the denominator of component 3
   comp3g(mu)=comp3c(mu)/comp3f(mu);
end

for mu=6:8
   comp3=comp3+comp3g(mu);
end
% -----------------------------

% -----------comp4-------------
% the 4th component of the summation for reduced volume
comp4a=0;
for v=10:16
   comp4a=comp4a+B(9,v)*X^(v-10);
end
comp4=11*(beta/betaL)^10*comp4a;
% -----------------------------

x2=comp1-comp2-comp3+comp4;
% The reduced volume for subcooled fluid in Subregin 2 is
% calculated from x2=v2/vc1 where vc1=0.00317 m^3/kg
vc1=0.00317;
v2=x2*vc1;
RHOS=1/v2;

return

