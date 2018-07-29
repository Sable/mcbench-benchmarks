function out = IAPWS_IF97(fun,in1,in2)
% IAPWS_IF97(fun,in1,in2)
%   102 water functions of water properties, based on the International Association on Properties of Water and Steam
%   Industrial Formulation 1997 (IAPWS-IF97), IAPWS-IF97-S01, IAPWS-IF97-S03rev, IAPWS-IF97-S04, IAPWS-IF97-S05, Revised
%   Advisory Note No. 3 Thermodynamic Derivatives from IAPWS Formulations 2008, Release on the IAPWS Formulation 2008
%   for the Viscosity of Ordinary Water Substance, 2008 Revised Release on the IAPWS Formulation 1985 for the Thermal
%   Conductivity of Ordinary Water Substance.
%
%   fun is the desired function that may take 1 input, in1, or 2 inputs, in1 and in2. in1 and in2 should be scalar,
%   column vector or matrix, and in1 and in2 should be the same size. If a row vector is entered, it is transposed. If a
%   scalar is entered for one input and the other input is a vector or matrix, then the scalar is repeated to form a
%   vector or matrix of the same size as the other input.
if nargin<2, out = NaN; return, end
if ~any(strcmpi(fun,{'k_pT','k_ph','mu_pT','mu_ph','dmudh_ph','dmudp_ph','dhLdp_p','dhVdp_p','dvdp_ph','dvdh_ph','dTdp_ph','cp_ph','h_pT','v_pT', ...
        'vL_p','vV_p','hL_p','hV_p','T_ph','v_ph','psat_T','Tsat_p','h1_pT','h2_pT','h3_rhoT','v1_pT','v2_pT','cp1_pT', ...
        'cp2_pT','cp3_rhoT','cv3_rhoT','alphav1_pT','alphav2_pT','alphap3_rhoT','betap3_rhoT','kappaT1_pT','kappaT2_pT',...
        'dgammadtau1_pT','dgammadpi1_pT','dgammadtautau1_pT','dgammadpipi1_pT','dgammadpitau1_pT','dgammadtau2_pT', ...
        'dgammadpi2_pT','dgammadtautau2_pT','dgammadpipi2_pT','dgammadpitau2_pT','dphidtau3_rhoT','dphiddelta3_rhoT', ...
        'dphidtautau3_rhoT','dphiddeltatau3_rhoT','dphiddeltadelta3_rhoT','dTsatdpsat_p','T1_ph','T2a_ph','T2b_ph','T2c_ph', ...
        'T3a_ph','T3b_ph','v3a_ph','v3b_ph','h2bc_p','h3ab_p','TB23_p','pB23_T','p3sat_h','v3a_pT','v3b_pT','v3c_pT', ...
        'v3d_pT','v3e_pT','v3f_pT','v3g_pT','v3h_pT','v3i_pT','v3j_pT','v3k_pT','v3l_pT','v3m_pT','v3n_pT','v3o_pT', ...
        'v3p_pT','v3q_pT','v3r_pT','v3s_pT','v3t_pT','v3u_pT','v3v_pT','v3w_pT','v3x_pT','v3y_pT','v3z_pT','T3ab_p', ...
        'T3cd_p','T3ef_p','T3gh_p','T3ij_p','T3jk_p','T3mn_p','T3op_p','T3qu_p','T3rx_p','T3uv_p','T3wx_p'}))
    out = NaN;return
end
if nargin==2
    dim = size(in1);
    if length(dim)>2,out = NaN;return,end
    if dim(1)==1 && dim(2)>1,in1 = in1';end
    out = feval(fun,in1);
end
if nargin==3
    dim1 = size(in1);dim2 = size(in2);
    if length(dim1)>2 || length(dim2)>2,out = NaN;return,end
    if any(dim1~=dim2);
        if dim1==ones(1,2),in1 = in1*ones(dim2);dim1=dim2;
        elseif dim2==ones(1,2),in2 = in2*ones(dim1);
        elseif dim1==fliplr(dim2),in1 = in1';dim1=dim2;
        else out = NaN;return
        end
    end
    if dim1(1)==1 && dim1(2)>1,in1 = in1';in2 = in2';end
    out = feval(fun,in1,in2);
end
end
%% stand alone functions
function k = k_pT(p,T)
% k = k_pT(p,T)
%   thermal conductivity, k [W/m/K], as a function of pressure, p [MPa], and temperature, T [K]
% based on Revised Release on the IAPWS Formulation 1985 for the Thermal Conductivity of Ordinary Water Substance, 2008
% Reference: http://www.iapws.org/
% June 23, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
k = initnan;
%% constants and calculated
Tstar = 647.26; % [K]
rhostar = 317.7; % [K]
kstar = 1; % [W/m/K]
a = [0.0102811, 0.0299621, 0.0156146, -0.00422464];
b = [-0.397070, 0.400302, 1.060000];
B = [-0.171587, 2.392190];
d = [0.0701309, 0.0118520, 0.00169937, -1.0200];
C = [0.642857, -4.11717, -6.17937, 0.00308976, 0.0822994, 10.0932];
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
TB23 = 863.15; % [K] temperature of boundary between region 2 and 3
Tmax = 1073.15; % [K] maximum valid temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pmax = 100; % [MPa] maximum valid pressure
psat = psat_T(T); % [MPa] saturation pressures
pB23 = initnan; valid = T>=TB13 & T<=TB23;
pB23(valid) = pB23_T(T(valid)); % [MPa] pressure on boundary between region 2 and region 3
%% valid ranges
valid1 = p>=psat & p<=pmax & T>=Tmin & T<=TB13; % valid range for region 1, include B13 in region 1
valid2 = p>=pmin & ((T>=Tmin & T<=TB13 & p<=psat) | (T>TB13 & T<=TB23 & p<=pB23) | (T>TB23 & T<=Tmax & p<=pmax)); % valid range for region 2, include B23 in region 2
valid3 = p>pB23 & p<=pmax & T>TB13 & T<TB23;
if any(any(valid1))
    T1 = T(valid1);rho1bar = 1./v1_pT(p(valid1),T1)/rhostar;T1bar = T1/Tstar;
    k0 = sqrt(T1bar).*(a(1) + (a(2) + (a(3) + a(4).*T1bar).*T1bar).*T1bar);
    k1 = b(1) + b(2)*rho1bar + b(3)*exp(B(1)*(rho1bar + B(2)).^2);
    deltaTbar = abs(T1bar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T1bar>=1) + (C(6)./deltaTbar.^0.6).*(T1bar<1);
    k2 = (d(1)./T1bar.^10 + d(2)).*rho1bar.^1.8.*exp(C(1)*(1-rho1bar.^2.8)) + d(3)*S.*rho1bar.^Q.*exp(Q./(1+Q).*(1-rho1bar.^(1+Q))) + d(4)*exp(C(2)*T1bar.^1.5 + C(3)./rho1bar.^5);
    k(valid1) = (k0+k1+k2)*kstar;
end
if any(any(valid2))
    T2 = T(valid2);rho2bar = 1./v2_pT(p(valid2),T2)/rhostar;T2bar = T2/Tstar;
    k0 = sqrt(T2bar).*(a(1) + (a(2) + (a(3) + a(4).*T2bar).*T2bar).*T2bar);
    k1 = b(1) + b(2)*rho2bar + b(3)*exp(B(1)*(rho2bar + B(2)).^2);
    deltaTbar = abs(T2bar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T2bar>=1) + (C(6)./deltaTbar.^0.6).*(T2bar<1);
    k2 = (d(1)./T2bar.^10 + d(2)).*rho2bar.^1.8.*exp(C(1)*(1-rho2bar.^2.8)) + d(3)*S.*rho2bar.^Q.*exp(Q./(1+Q).*(1-rho2bar.^(1+Q))) + d(4)*exp(C(2)*T2bar.^1.5 + C(3)./rho2bar.^5);
    k(valid2) = (k0+k1+k2)*kstar;
end
if any(any(valid3))
    T3 = T(valid3);rho3bar = 1./v_pT(p(valid3),T3)/rhostar;T3bar = T3/Tstar;
    k0 = sqrt(T3bar).*(a(1) + (a(2) + (a(3) + a(4).*T3bar).*T3bar).*T3bar);
    k1 = b(1) + b(2)*rho3bar + b(3)*exp(B(1)*(rho3bar + B(2)).^2);
    deltaTbar = abs(T3bar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T3bar>=1) + (C(6)./deltaTbar.^0.6).*(T3bar<1);
    k2 = (d(1)./T3bar.^10 + d(2)).*rho3bar.^1.8.*exp(C(1)*(1-rho3bar.^2.8)) + d(3)*S.*rho3bar.^Q.*exp(Q./(1+Q).*(1-rho3bar.^(1+Q))) + d(4)*exp(C(2)*T3bar.^1.5 + C(3)./rho3bar.^5);
    k(valid3) = (k0+k1+k2)*kstar;
end
end
function k = k_ph(p,h)
% k = k_ph(p,h)
%   thermal conductivity, k [W/m/K], as a function of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on Revised Release on the IAPWS Formulation 1985 for the Thermal Conductivity of Ordinary Water Substance, 2008
% Reference: http://www.iapws.org/
% June 23, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
k = initnan;
%% constants and calculated
Tstar = 647.26; % [K]
rhostar = 317.7; % [K]
kstar = 1; % [W/m/K]
a = [0.0102811, 0.0299621, 0.0156146, -0.00422464];
b = [-0.397070, 0.400302, 1.060000];
B = [-0.171587, 2.392190];
d = [0.0701309, 0.0118520, 0.00169937, -1.0200];
C = [0.642857, -4.11717, -6.17937, 0.00308976, 0.0822994, 10.0932];
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4a = p>=pmin & p<=pB13sat & h>h1L & h<=h2V; % valid range for region 4a
valid4b = p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V; % valid range for region 4b
if any(any(valid1))
    p1 = p(valid1);T1 = T1_ph(p1,h(valid1));rho1bar = 1./v1_pT(p1,T1)/rhostar;T1bar = T1/Tstar;
    k0 = sqrt(T1bar).*(a(1) + (a(2) + (a(3) + a(4).*T1bar).*T1bar).*T1bar);
    k1 = b(1) + b(2)*rho1bar + b(3)*exp(B(1)*(rho1bar + B(2)).^2);
    deltaTbar = abs(T1bar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T1bar>=1) + (C(6)./deltaTbar.^0.6).*(T1bar<1);
    k2 = (d(1)./T1bar.^10 + d(2)).*rho1bar.^1.8.*exp(C(1)*(1-rho1bar.^2.8)) + d(3)*S.*rho1bar.^Q.*exp(Q./(1+Q).*(1-rho1bar.^(1+Q))) + d(4)*exp(C(2)*T1bar.^1.5 + C(3)./rho1bar.^5);
    k(valid1) = (k0+k1+k2)*kstar;
end
if any(any(valid2a))
    p2a = p(valid2a);T2a = T2a_ph(p2a,h(valid2a));rho2abar = 1./v2_pT(p2a,T2a)/rhostar;T2abar = T2a/Tstar;
    k0 = sqrt(T2abar).*(a(1) + (a(2) + (a(3) + a(4).*T2abar).*T2abar).*T2abar);
    k1 = b(1) + b(2)*rho2abar + b(3)*exp(B(1)*(rho2abar + B(2)).^2);
    deltaTbar = abs(T2abar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T2abar>=1) + (C(6)./deltaTbar.^0.6).*(T2abar<1);
    k2 = (d(1)./T2abar.^10 + d(2)).*rho2abar.^1.8.*exp(C(1)*(1-rho2abar.^2.8)) + d(3)*S.*rho2abar.^Q.*exp(Q./(1+Q).*(1-rho2abar.^(1+Q))) + d(4)*exp(C(2)*T2abar.^1.5 + C(3)./rho2abar.^5);
    k(valid2a) = (k0+k1+k2)*kstar;
end
if any(any(valid2b))
    p2b = p(valid2b);T2b = T2b_ph(p2b,h(valid2b));rho2bbar = 1./v2_pT(p2b,T2b)/rhostar;T2bbar = T2b/Tstar;
    k0 = sqrt(T2bbar).*(a(1) + (a(2) + (a(3) + a(4).*T2bbar).*T2bbar).*T2bbar);
    k1 = b(1) + b(2)*rho2bbar + b(3)*exp(B(1)*(rho2bbar + B(2)).^2);
    deltaTbar = abs(T2bbar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T2bbar>=1) + (C(6)./deltaTbar.^0.6).*(T2bbar<1);
    k2 = (d(1)./T2bbar.^10 + d(2)).*rho2bbar.^1.8.*exp(C(1)*(1-rho2bbar.^2.8)) + d(3)*S.*rho2bbar.^Q.*exp(Q./(1+Q).*(1-rho2bbar.^(1+Q))) + d(4)*exp(C(2)*T2bbar.^1.5 + C(3)./rho2bbar.^5);
    k(valid2b) = (k0+k1+k2)*kstar;
end
if any(any(valid2c))
    p2c = p(valid2c);T2c = T2c_ph(p2c,h(valid2c));rho2cbar = 1./v2_pT(p2c,T2c)/rhostar;T2cbar = T2c/Tstar;
    k0 = sqrt(T2cbar).*(a(1) + (a(2) + (a(3) + a(4).*T2cbar).*T2cbar).*T2cbar);
    k1 = b(1) + b(2)*rho2cbar + b(3)*exp(B(1)*(rho2cbar + B(2)).^2);
    deltaTbar = abs(T2cbar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T2cbar>=1) + (C(6)./deltaTbar.^0.6).*(T2cbar<1);
    k2 = (d(1)./T2cbar.^10 + d(2)).*rho2cbar.^1.8.*exp(C(1)*(1-rho2cbar.^2.8)) + d(3)*S.*rho2cbar.^Q.*exp(Q./(1+Q).*(1-rho2cbar.^(1+Q))) + d(4)*exp(C(2)*T2cbar.^1.5 + C(3)./rho2cbar.^5);
    k(valid2c) = (k0+k1+k2)*kstar;
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);T3abar = T3a_ph(p3a,h3a)/Tstar;rho3abar = 1./v3a_ph(p3a,h3a)/rhostar;
    k0 = sqrt(T3abar).*(a(1) + (a(2) + (a(3) + a(4).*T3abar).*T3abar).*T3abar);
    k1 = b(1) + b(2)*rho3abar + b(3)*exp(B(1)*(rho3abar + B(2)).^2);
    deltaTbar = abs(T3abar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T3abar>=1) + (C(6)./deltaTbar.^0.6).*(T3abar<1);
    k2 = (d(1)./T3abar.^10 + d(2)).*rho3abar.^1.8.*exp(C(1)*(1-rho3abar.^2.8)) + d(3)*S.*rho3abar.^Q.*exp(Q./(1+Q).*(1-rho3abar.^(1+Q))) + d(4)*exp(C(2)*T3abar.^1.5 + C(3)./rho3abar.^5);
    k(valid3a) = (k0+k1+k2)*kstar;
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);T3bbar = T3b_ph(p3b,h3b)/Tstar;rho3bbar = 1./v3b_ph(p3b,h3b)/rhostar;
    k0 = sqrt(T3bbar).*(a(1) + (a(2) + (a(3) + a(4).*T3bbar).*T3bbar).*T3bbar);
    k1 = b(1) + b(2)*rho3bbar + b(3)*exp(B(1)*(rho3bbar + B(2)).^2);
    deltaTbar = abs(T3bbar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T3bbar>=1) + (C(6)./deltaTbar.^0.6).*(T3bbar<1);
    k2 = (d(1)./T3bbar.^10 + d(2)).*rho3bbar.^1.8.*exp(C(1)*(1-rho3bbar.^2.8)) + d(3)*S.*rho3bbar.^Q.*exp(Q./(1+Q).*(1-rho3bbar.^(1+Q))) + d(4)*exp(C(2)*T3bbar.^1.5 + C(3)./rho3bbar.^5);
    k(valid3b) = (k0+k1+k2)*kstar;
end
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);h1L4a = h1L(valid4a);
    x = (h(valid4a)-h1L4a)./(h2V(valid4a)-h1L4a); % quality
    v1L = v1_pT(p4a,Tsat4a); % [m^3/kg] saturated liquid specific volumes
    v2V = v2_pT(p4a,Tsat4a); % [m^3/kg] saturated vapor specific volumes
    T4abar = Tsat4a/Tstar;rho4abar = 1./(v1L + x.*(v2V - v1L))/rhostar;
    k0 = sqrt(T4abar).*(a(1) + (a(2) + (a(3) + a(4).*T4abar).*T4abar).*T4abar);
    k1 = b(1) + b(2)*rho4abar + b(3)*exp(B(1)*(rho4abar + B(2)).^2);
    deltaTbar = abs(T4abar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T4abar>=1) + (C(6)./deltaTbar.^0.6).*(T4abar<1);
    k2 = (d(1)./T4abar.^10 + d(2)).*rho4abar.^1.8.*exp(C(1)*(1-rho4abar.^2.8)) + d(3)*S.*rho4abar.^Q.*exp(Q./(1+Q).*(1-rho4abar.^(1+Q))) + d(4)*exp(C(2)*T4abar.^1.5 + C(3)./rho4abar.^5);
    k(valid4a) = (k0+k1+k2)*kstar;
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);
    v3L = vL_p(p4b); v3V = vV_p(p4b);
    h3L = h3_rhoT(1./v3L,Tsat4b);
    h3V = h3_rhoT(1./v3V,Tsat4b);
    x = (h(valid4b)-h3L)./(h3V-h3L); % quality
    T4bbar = Tsat4b/Tstar;rho4bbar = 1./(v3L + x.*(v3V - v3L))/rhostar;
    k0 = sqrt(T4bbar).*(a(1) + (a(2) + (a(3) + a(4).*T4bbar).*T4bbar).*T4bbar);
    k1 = b(1) + b(2)*rho4bbar + b(3)*exp(B(1)*(rho4bbar + B(2)).^2);
    deltaTbar = abs(T4bbar-1)+C(4);Q = 2 + C(5)./deltaTbar.^0.6;S = (1./deltaTbar).*(T4bbar>=1) + (C(6)./deltaTbar.^0.6).*(T4bbar<1);
    k2 = (d(1)./T4bbar.^10 + d(2)).*rho4bbar.^1.8.*exp(C(1)*(1-rho4bbar.^2.8)) + d(3)*S.*rho4bbar.^Q.*exp(Q./(1+Q).*(1-rho4bbar.^(1+Q))) + d(4)*exp(C(2)*T4bbar.^1.5 + C(3)./rho4bbar.^5);
    k(valid4b) = (k0+k1+k2)*kstar;
end
end
function mu = mu_ph(p,h)
% mu = mu_ph(p,h)
%   Viscosity, mu [Pa*s], as a function of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS95 Release on the IAPWS Formulation 2008 for the Viscosity of Ordinary Water Substance
% Reference: http://www.iapws.org/
% June 23, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
mu = initnan;
%% constants and calculated
Tc = 647.096; % [K]
rhoc = 322.0; % [kg/m^3]
mustar = 1.00e-6; % [Pa*s]
Hi = [1.67752 2.20462 0.6366564 -0.241605];
Hij = [0,1,2,3,0,1,2,3,5,0,1,2,3,4,0,1,0,3,4,3,5;0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,4,4,5,6,6; ...
    0.520094,0.0850895,-1.08374,-0.289555,0.222531,0.999115,1.88797,1.26613,0.120573,-0.281378,-0.906851,-0.772479, ...
    -0.489837,-0.257040,0.161913,0.257399,-0.0325372,0.0698452,0.00872102,-0.00435673,-0.000593264];
Nterms = 21;
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4a = p>=pmin & p<=pB13sat & h>h1L & h<=h2V; % valid range for region 4a
valid4b = p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V; % valid range for region 4b
if any(any(valid1))
    p1 = p(valid1);T1 = T1_ph(p1,h(valid1));rho1bar = 1./v1_pT(p1,T1)/rhoc;T1bar = T1/Tc;
    mu0 = 100*sqrt(T1bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T1bar)./T1bar)./T1bar);
    L = length(p1);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T1bar = T1bar*ones(1,Nterms);rho1bar = rho1bar*ones(1,Nterms);
    mu1 = exp(sum(rho1bar.*(1./T1bar-1).^I.*HIJ.*(rho1bar-1).^J,2));
    mu(valid1) = mu0.*mu1*mustar;
end
if any(any(valid2a))
    p2a = p(valid2a);T2a = T2a_ph(p2a,h(valid2a));rho2abar = 1./v2_pT(p2a,T2a)/rhoc;T2abar = T2a/Tc;
    mu0 = 100*sqrt(T2abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2abar)./T2abar)./T2abar);
    L = length(p2a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2abar = T2abar*ones(1,Nterms);rho2abar = rho2abar*ones(1,Nterms);
    mu1 = exp(sum(rho2abar.*(1./T2abar-1).^I.*HIJ.*(rho2abar-1).^J,2));
    mu(valid2a) = mu0.*mu1*mustar;
end
if any(any(valid2b))
    p2b = p(valid2b);T2b = T2b_ph(p2b,h(valid2b));rho2bbar = 1./v2_pT(p2b,T2b)/rhoc;T2bbar = T2b/Tc;
    mu0 = 100*sqrt(T2bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2bbar)./T2bbar)./T2bbar);
    L = length(p2b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2bbar = T2bbar*ones(1,Nterms);rho2bbar = rho2bbar*ones(1,Nterms);
    mu1 = exp(sum(rho2bbar.*(1./T2bbar-1).^I.*HIJ.*(rho2bbar-1).^J,2));
    mu(valid2b) = mu0.*mu1*mustar;
end
if any(any(valid2c))
    p2c = p(valid2c);T2c = T2c_ph(p2c,h(valid2c));rho2cbar = 1./v2_pT(p2c,T2c)/rhoc;T2cbar = T2c/Tc;
    mu0 = 100*sqrt(T2cbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2cbar)./T2cbar)./T2cbar);
    L = length(p2c);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2cbar = T2cbar*ones(1,Nterms);rho2cbar = rho2cbar*ones(1,Nterms);
    mu1 = exp(sum(rho2cbar.*(1./T2cbar-1).^I.*HIJ.*(rho2cbar-1).^J,2));
    mu(valid2c) = mu0.*mu1*mustar;
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);T3abar = T3a_ph(p3a,h3a)/Tc;rho3abar = 1./v3a_ph(p3a,h3a)/rhoc;
    mu0 = 100*sqrt(T3abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3abar)./T3abar)./T3abar);
    L = length(p3a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T3abar = T3abar*ones(1,Nterms);rho3abar = rho3abar*ones(1,Nterms);
    mu1 = exp(sum(rho3abar.*(1./T3abar-1).^I.*HIJ.*(rho3abar-1).^J,2));
    mu(valid3a) = mu0.*mu1*mustar;
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);T3bbar = T3b_ph(p3b,h3b)/Tc;rho3bbar = 1./v3b_ph(p3b,h3b)/rhoc;
    mu0 = 100*sqrt(T3bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3bbar)./T3bbar)./T3bbar);
    L = length(p3b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T3bbar = T3bbar*ones(1,Nterms);rho3bbar = rho3bbar*ones(1,Nterms);
    mu1 = exp(sum(rho3bbar.*(1./T3bbar-1).^I.*HIJ.*(rho3bbar-1).^J,2));
    mu(valid3b) = mu0.*mu1*mustar;
end
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);h1L4a = h1L(valid4a);
    x = (h(valid4a)-h1L4a)./(h2V(valid4a)-h1L4a); % quality
    v1L = v1_pT(p4a,Tsat4a); % [m^3/kg] saturated liquid specific volumes
    v2V = v2_pT(p4a,Tsat4a); % [m^3/kg] saturated vapor specific volumes
    T4abar = Tsat4a/Tc;rho4abar = 1./(v1L + x.*(v2V - v1L))/rhoc;
    mu0 = 100*sqrt(T4abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4abar)./T4abar)./T4abar);
    L = length(p4a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T4abar = T4abar*ones(1,Nterms);rho4abar = rho4abar*ones(1,Nterms);
    mu1 = exp(sum(rho4abar.*(1./T4abar-1).^I.*HIJ.*(rho4abar-1).^J,2));
    mu(valid4a) = mu0.*mu1*mustar;
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);
    v3L = vL_p(p4b); v3V = vV_p(p4b);
    h3L = h3_rhoT(1./v3L,Tsat4b);
    h3V = h3_rhoT(1./v3V,Tsat4b);
    x = (h(valid4b)-h3L)./(h3V-h3L); % quality
    T4bbar = Tsat4b/Tc;rho4bbar = 1./(v3L + x.*(v3V - v3L))/rhoc;
    mu0 = 100*sqrt(T4bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4bbar)./T4bbar)./T4bbar);
    L = length(p4b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T4bbar = T4bbar*ones(1,Nterms);rho4bbar = rho4bbar*ones(1,Nterms);
    mu1 = exp(sum(rho4bbar.*(1./T4bbar-1).^I.*HIJ.*(rho4bbar-1).^J,2));
    mu(valid4b) = mu0.*mu1*mustar;
end
end
function mu = mu_pT(p,T)
% mu = mu_pT(p,T)
%   Viscosity, mu [Pa*s], as a function of pressure, p [MPa], and temperature, T [K]
% based on IAPWS95 Release on the IAPWS Formulation 2008 for the Viscosity of Ordinary Water Substance
% Reference: http://www.iapws.org/
% June 23, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
mu = initnan;
%% constants and calculated
Tc = 647.096; % [K]
rhoc = 322.0; % [kg/m^3]
mustar = 1.00e-6; % [Pa*s]
Hi = [1.67752 2.20462 0.6366564 -0.241605];
Hij = [0,1,2,3,0,1,2,3,5,0,1,2,3,4,0,1,0,3,4,3,5;0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,4,4,5,6,6; ...
    0.520094,0.0850895,-1.08374,-0.289555,0.222531,0.999115,1.88797,1.26613,0.120573,-0.281378,-0.906851,-0.772479, ...
    -0.489837,-0.257040,0.161913,0.257399,-0.0325372,0.0698452,0.00872102,-0.00435673,-0.000593264];
Nterms = 21;
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
TB23 = 863.15; % [K] temperature of boundary between region 2 and 3
Tmax = 1073.15; % [K] maximum valid temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pmax = 100; % [MPa] maximum valid pressure
psat = psat_T(T); % [MPa] saturation pressures
pB23 = initnan; valid = T>=TB13 & T<=TB23;
pB23(valid) = pB23_T(T(valid)); % [MPa] pressure on boundary between region 2 and region 3
%% valid ranges
valid1 = p>=psat & p<=pmax & T>=Tmin & T<=TB13; % valid range for region 1, include B13 in region 1
valid2 = p>=pmin & ((T>=Tmin & T<=TB13 & p<=psat) | (T>TB13 & T<=TB23 & p<=pB23) | (T>TB23 & T<=Tmax & p<=pmax)); % valid range for region 2, include B23 in region 2
valid3 = p>pB23 & p<=pmax & T>TB13 & T<TB23;
if any(any(valid1))
    T1 = T(valid1);rho1bar = 1./v1_pT(p(valid1),T1)/rhoc;T1bar = T1/Tc;
    mu0 = 100*sqrt(T1bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T1bar)./T1bar)./T1bar);
    L = length(T1);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T1bar = T1bar*ones(1,Nterms);rho1bar = rho1bar*ones(1,Nterms);
    mu1 = exp(sum(rho1bar.*(1./T1bar-1).^I.*HIJ.*(rho1bar-1).^J,2));
    mu(valid1) = mu0.*mu1*mustar;
end
if any(any(valid2))
    T2 = T(valid2);rho2bar = 1./v2_pT(p(valid2),T2)/rhoc;T2bar = T2/Tc;
    mu0 = 100*sqrt(T2bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2bar)./T2bar)./T2bar);
    L = length(T2);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2bar = T2bar*ones(1,Nterms);rho2bar = rho2bar*ones(1,Nterms);
    mu1 = exp(sum(rho2bar.*(1./T2bar-1).^I.*HIJ.*(rho2bar-1).^J,2));
    mu(valid2) = mu0.*mu1*mustar;
end
if any(any(valid3))
    T3 = T(valid3);rho3bar = 1./v_pT(p(valid3),T3)/rhoc;T3bar = T3/Tc;
    mu0 = 100*sqrt(T3bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3bar)./T3bar)./T3bar);
    L = length(T3);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T3bar = T3bar*ones(1,Nterms);rho3bar = rho3bar*ones(1,Nterms);
    mu1 = exp(sum(rho3bar.*(1./T3bar-1).^I.*HIJ.*(rho3bar-1).^J,2));
    mu(valid3) = mu0.*mu1*mustar;
end
end
function dmudh = dmudh_ph(p,h)
% dmudh = dmudh_ph(p,h)
%   Derivative of viscosity, dmudh [(Pa*s)/(kJ/kg)], with respect to enthalpy, h [kJ/kg] at constant pressure as a function of
%   pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS95 Release on the IAPWS Formulation 2008 for the Viscosity of Ordinary Water Substance
% Reference: http://www.iapws.org/
% June 23, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
dmudh = initnan;
%% constants and calculated
Tc = 647.096; % [K]
rhoc = 322.0; % [kg/m^3]
mustar = 1.00e-6; % [Pa*s]
Hi = [1.67752 2.20462 0.6366564 -0.241605];
Hij = [0,1,2,3,0,1,2,3,5,0,1,2,3,4,0,1,0,3,4,3,5;0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,4,4,5,6,6; ...
    0.520094,0.0850895,-1.08374,-0.289555,0.222531,0.999115,1.88797,1.26613,0.120573,-0.281378,-0.906851,-0.772479, ...
    -0.489837,-0.257040,0.161913,0.257399,-0.0325372,0.0698452,0.00872102,-0.00435673,-0.000593264];
Nterms = 21;
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4a = p>=pmin & p<=pB13sat & h>h1L & h<=h2V; % valid range for region 4a
valid4b = p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V; % valid range for region 4b
if any(any(valid1))
    p1 = p(valid1);h1 = h(valid1);T1 = T1_ph(p1,h1);v1 = v1_pT(p1,T1);rho1bar = 1./v1/rhoc;T1bar = T1/Tc;
    mu0 = 100*sqrt(T1bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T1bar)./T1bar)./T1bar);
    dmu0dT = mu0/2./T1bar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T1bar)./T1bar)./T1bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T1bar)./T1bar)./T1bar);
    L = length(p1);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T1bar = T1bar*ones(1,Nterms);rho1bar = rho1bar*ones(1,Nterms);
    mu1 = exp(sum(rho1bar.*(1./T1bar-1).^I.*HIJ.*(rho1bar-1).^J,2));
    dmu1dT = mu1.*(sum(rho1bar.*I.*(1./T1bar-1).^(I-1).*(-1./T1bar.^2).*HIJ.*(rho1bar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T1bar-1).^I.*HIJ.*(rho1bar-1).^J,2) + sum(rho1bar.*(1./T1bar-1).^I.*J.*HIJ.*(rho1bar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid1) = -dmudrho./v1.^2.*dvdh_ph(p1,h1) + dmudT./cp_ph(p1,h1);
end
if any(any(valid2a))
    p2a = p(valid2a);h2 = h(valid2a);T2a = T2a_ph(p2a,h2);v2 = v2_pT(p2a,T2a);rho2abar = 1./v2/rhoc;T2abar = T2a/Tc;
    mu0 = 100*sqrt(T2abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2abar)./T2abar)./T2abar);
    dmu0dT = mu0/2./T2abar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T2abar)./T2abar)./T2abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2abar)./T2abar)./T2abar);
    L = length(p2a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2abar = T2abar*ones(1,Nterms);rho2abar = rho2abar*ones(1,Nterms);
    mu1 = exp(sum(rho2abar.*(1./T2abar-1).^I.*HIJ.*(rho2abar-1).^J,2));
    dmu1dT = mu1.*(sum(rho2abar.*I.*(1./T2abar-1).^(I-1).*(-1./T2abar.^2).*HIJ.*(rho2abar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T2abar-1).^I.*HIJ.*(rho2abar-1).^J,2) + sum(rho2abar.*(1./T2abar-1).^I.*J.*HIJ.*(rho2abar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid2a) = -dmudrho./v2.^2.*dvdh_ph(p2a,h2) + dmudT./cp_ph(p2a,h2);
end
if any(any(valid2b))
    p2b = p(valid2b);h2 = h(valid2b);T2b = T2b_ph(p2b,h2);v2 = v2_pT(p2b,T2b);rho2bbar = 1./v2/rhoc;T2bbar = T2b/Tc;
    mu0 = 100*sqrt(T2bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2bbar)./T2bbar)./T2bbar);
    dmu0dT = mu0/2./T2bbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T2bbar)./T2bbar)./T2bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2bbar)./T2bbar)./T2bbar);
    L = length(p2b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2bbar = T2bbar*ones(1,Nterms);rho2bbar = rho2bbar*ones(1,Nterms);
    mu1 = exp(sum(rho2bbar.*(1./T2bbar-1).^I.*HIJ.*(rho2bbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho2bbar.*I.*(1./T2bbar-1).^(I-1).*(-1./T2bbar.^2).*HIJ.*(rho2bbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T2bbar-1).^I.*HIJ.*(rho2bbar-1).^J,2) + sum(rho2bbar.*(1./T2bbar-1).^I.*J.*HIJ.*(rho2bbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid2b) = -dmudrho./v2.^2.*dvdh_ph(p2b,h2) + dmudT./cp_ph(p2b,h2);
end
if any(any(valid2c))
    p2c = p(valid2c);h2 = h(valid2c);T2c = T2c_ph(p2c,h2);v2 = v2_pT(p2c,T2c);rho2cbar = 1./v2/rhoc;T2cbar = T2c/Tc;
    mu0 = 100*sqrt(T2cbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2cbar)./T2cbar)./T2cbar);
    dmu0dT = mu0/2./T2cbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T2cbar)./T2cbar)./T2cbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2cbar)./T2cbar)./T2cbar);
    L = length(p2c);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2cbar = T2cbar*ones(1,Nterms);rho2cbar = rho2cbar*ones(1,Nterms);
    mu1 = exp(sum(rho2cbar.*(1./T2cbar-1).^I.*HIJ.*(rho2cbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho2cbar.*I.*(1./T2cbar-1).^(I-1).*(-1./T2cbar.^2).*HIJ.*(rho2cbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T2cbar-1).^I.*HIJ.*(rho2cbar-1).^J,2) + sum(rho2cbar.*(1./T2cbar-1).^I.*J.*HIJ.*(rho2cbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid2c) = -dmudrho./v2.^2.*dvdh_ph(p2c,h2) + dmudT./cp_ph(p2c,h2);
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);T3 = T3a_ph(p3a,h3a);T3abar = T3/Tc;v3 = v3a_ph(p3a,h3a);rho3abar = 1./v3/rhoc;
    mu0 = 100*sqrt(T3abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3abar)./T3abar)./T3abar);
    dmu0dT = mu0/2./T3abar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T3abar)./T3abar)./T3abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3abar)./T3abar)./T3abar);
    L = length(p3a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T3abar = T3abar*ones(1,Nterms);rho3abar = rho3abar*ones(1,Nterms);
    mu1 = exp(sum(rho3abar.*(1./T3abar-1).^I.*HIJ.*(rho3abar-1).^J,2));
    dmu1dT = mu1.*(sum(rho3abar.*I.*(1./T3abar-1).^(I-1).*(-1./T3abar.^2).*HIJ.*(rho3abar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T3abar-1).^I.*HIJ.*(rho3abar-1).^J,2) + sum(rho3abar.*(1./T3abar-1).^I.*J.*HIJ.*(rho3abar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid3a) = -dmudrho./v3.^2.*dvdh_ph(p3a,h3a) + dmudT./cp_ph(p3a,h3a);
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);T3 = T3b_ph(p3b,h3b);T3bbar = T3/Tc;v3 = v3b_ph(p3b,h3b);rho3bbar = 1./v3/rhoc;
    mu0 = 100*sqrt(T3bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3bbar)./T3bbar)./T3bbar);
    dmu0dT = mu0/2./T3bbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T3bbar)./T3bbar)./T3bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3bbar)./T3bbar)./T3bbar);
    L = length(p3b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T3bbar = T3bbar*ones(1,Nterms);rho3bbar = rho3bbar*ones(1,Nterms);
    mu1 = exp(sum(rho3bbar.*(1./T3bbar-1).^I.*HIJ.*(rho3bbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho3bbar.*I.*(1./T3bbar-1).^(I-1).*(-1./T3bbar.^2).*HIJ.*(rho3bbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T3bbar-1).^I.*HIJ.*(rho3bbar-1).^J,2) + sum(rho3bbar.*(1./T3bbar-1).^I.*J.*HIJ.*(rho3bbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid3b) = -dmudrho./v3.^2.*dvdh_ph(p3b,h3b) + dmudT./cp_ph(p3b,h3b);
end
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);h1L4a = h1L(valid4a);
    h4 = h(valid4a);x = (h4-h1L4a)./(h2V(valid4a)-h1L4a); % quality
    v1L = v1_pT(p4a,Tsat4a); % [m^3/kg] saturated liquid specific volumes
    v2V = v2_pT(p4a,Tsat4a); % [m^3/kg] saturated vapor specific volumes
    T4abar = Tsat4a/Tc;v4 = v1L + x.*(v2V - v1L);rho4abar = 1./v4/rhoc;
    mu0 = 100*sqrt(T4abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4abar)./T4abar)./T4abar);
    dmu0dT = mu0/2./T4abar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T4abar)./T4abar)./T4abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4abar)./T4abar)./T4abar);
    L = length(p4a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T4abar = T4abar*ones(1,Nterms);rho4abar = rho4abar*ones(1,Nterms);
    mu1 = exp(sum(rho4abar.*(1./T4abar-1).^I.*HIJ.*(rho4abar-1).^J,2));
    dmu1dT = mu1.*(sum(rho4abar.*I.*(1./T4abar-1).^(I-1).*(-1./T4abar.^2).*HIJ.*(rho4abar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T4abar-1).^I.*HIJ.*(rho4abar-1).^J,2) + sum(rho4abar.*(1./T4abar-1).^I.*J.*HIJ.*(rho4abar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid4a) = -dmudrho./v4.^2.*dvdh_ph(p4a,h4) + dmudT./cp_ph(p4a,h4);
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);
    v3L = vL_p(p4b); v3V = vV_p(p4b);
    h3L = h3_rhoT(1./v3L,Tsat4b);
    h3V = h3_rhoT(1./v3V,Tsat4b);
    h4 = h(valid4b);x = (h4-h3L)./(h3V-h3L); % quality
    T4bbar = Tsat4b/Tc;v4 = v3L + x.*(v3V - v3L);rho4bbar = 1./v4/rhoc;
    mu0 = 100*sqrt(T4bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4bbar)./T4bbar)./T4bbar);
    dmu0dT = mu0/2./T4bbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T4bbar)./T4bbar)./T4bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4bbar)./T4bbar)./T4bbar);
    L = length(p4b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T4bbar = T4bbar*ones(1,Nterms);rho4bbar = rho4bbar*ones(1,Nterms);
    mu1 = exp(sum(rho4bbar.*(1./T4bbar-1).^I.*HIJ.*(rho4bbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho4bbar.*I.*(1./T4bbar-1).^(I-1).*(-1./T4bbar.^2).*HIJ.*(rho4bbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T4bbar-1).^I.*HIJ.*(rho4bbar-1).^J,2) + sum(rho4bbar.*(1./T4bbar-1).^I.*J.*HIJ.*(rho4bbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudh(valid4b) = -dmudrho./v4.^2.*dvdh_ph(p4b,h4) + dmudT./cp_ph(p4b,h4);
end
end
function dmudp = dmudp_ph(p,h)
% dmudp = dmudp_ph(p,h)
%   Derivative of viscosity, dmudp [(Pa*s)/MPa], with respect to pressure, p [MPa] at constant enthalpy as a function of
%   pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS95 Release on the IAPWS Formulation 2008 for the Viscosity of Ordinary Water Substance
% Reference: http://www.iapws.org/
% June 23, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
dmudp = initnan;
%% constants and calculated
Tc = 647.096; % [K]
rhoc = 322.0; % [kg/m^3]
mustar = 1.00e-6; % [Pa*s]
Hi = [1.67752 2.20462 0.6366564 -0.241605];
Hij = [0,1,2,3,0,1,2,3,5,0,1,2,3,4,0,1,0,3,4,3,5;0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,4,4,5,6,6; ...
    0.520094,0.0850895,-1.08374,-0.289555,0.222531,0.999115,1.88797,1.26613,0.120573,-0.281378,-0.906851,-0.772479, ...
    -0.489837,-0.257040,0.161913,0.257399,-0.0325372,0.0698452,0.00872102,-0.00435673,-0.000593264];
Nterms = 21;
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4a = p>=pmin & p<=pB13sat & h>h1L & h<=h2V; % valid range for region 4a
valid4b = p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V; % valid range for region 4b
if any(any(valid1))
    p1 = p(valid1);h1 = h(valid1);T1 = T1_ph(p1,h1);v1 = v1_pT(p1,T1);rho1bar = 1./v1/rhoc;T1bar = T1/Tc;
    mu0 = 100*sqrt(T1bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T1bar)./T1bar)./T1bar);
    dmu0dT = mu0/2./T1bar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T1bar)./T1bar)./T1bar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T1bar)./T1bar)./T1bar);
    L = length(p1);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T1bar = T1bar*ones(1,Nterms);rho1bar = rho1bar*ones(1,Nterms);
    mu1 = exp(sum(rho1bar.*(1./T1bar-1).^I.*HIJ.*(rho1bar-1).^J,2));
    dmu1dT = mu1.*(sum(rho1bar.*I.*(1./T1bar-1).^(I-1).*(-1./T1bar.^2).*HIJ.*(rho1bar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T1bar-1).^I.*HIJ.*(rho1bar-1).^J,2) + sum(rho1bar.*(1./T1bar-1).^I.*J.*HIJ.*(rho1bar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid1) = -dmudrho./v1.^2.*dvdp_ph(p1,h1) + dmudT.*dTdp_ph(p1,h1);
end
if any(any(valid2a))
    p2a = p(valid2a);h2 = h(valid2a);T2a = T2a_ph(p2a,h2);v2 = v2_pT(p2a,T2a);rho2abar = 1./v2/rhoc;T2abar = T2a/Tc;
    mu0 = 100*sqrt(T2abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2abar)./T2abar)./T2abar);
    dmu0dT = mu0/2./T2abar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T2abar)./T2abar)./T2abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2abar)./T2abar)./T2abar);
    L = length(p2a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2abar = T2abar*ones(1,Nterms);rho2abar = rho2abar*ones(1,Nterms);
    mu1 = exp(sum(rho2abar.*(1./T2abar-1).^I.*HIJ.*(rho2abar-1).^J,2));
    dmu1dT = mu1.*(sum(rho2abar.*I.*(1./T2abar-1).^(I-1).*(-1./T2abar.^2).*HIJ.*(rho2abar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T2abar-1).^I.*HIJ.*(rho2abar-1).^J,2) + sum(rho2abar.*(1./T2abar-1).^I.*J.*HIJ.*(rho2abar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid2a) = -dmudrho./v2.^2.*dvdp_ph(p2a,h2) + dmudT.*dTdp_ph(p2a,h2);
end
if any(any(valid2b))
    p2b = p(valid2b);h2 = h(valid2b);T2b = T2b_ph(p2b,h2);v2 = v2_pT(p2b,T2b);rho2bbar = 1./v2/rhoc;T2bbar = T2b/Tc;
    mu0 = 100*sqrt(T2bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2bbar)./T2bbar)./T2bbar);
    dmu0dT = mu0/2./T2bbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T2bbar)./T2bbar)./T2bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2bbar)./T2bbar)./T2bbar);
    L = length(p2b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2bbar = T2bbar*ones(1,Nterms);rho2bbar = rho2bbar*ones(1,Nterms);
    mu1 = exp(sum(rho2bbar.*(1./T2bbar-1).^I.*HIJ.*(rho2bbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho2bbar.*I.*(1./T2bbar-1).^(I-1).*(-1./T2bbar.^2).*HIJ.*(rho2bbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T2bbar-1).^I.*HIJ.*(rho2bbar-1).^J,2) + sum(rho2bbar.*(1./T2bbar-1).^I.*J.*HIJ.*(rho2bbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid2b) = -dmudrho./v2.^2.*dvdp_ph(p2b,h2) + dmudT.*dTdp_ph(p2b,h2);
end
if any(any(valid2c))
    p2c = p(valid2c);h2 = h(valid2c);T2c = T2c_ph(p2c,h2);v2 = v2_pT(p2c,T2c);rho2cbar = 1./v2/rhoc;T2cbar = T2c/Tc;
    mu0 = 100*sqrt(T2cbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2cbar)./T2cbar)./T2cbar);
    dmu0dT = mu0/2./T2cbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T2cbar)./T2cbar)./T2cbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T2cbar)./T2cbar)./T2cbar);
    L = length(p2c);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T2cbar = T2cbar*ones(1,Nterms);rho2cbar = rho2cbar*ones(1,Nterms);
    mu1 = exp(sum(rho2cbar.*(1./T2cbar-1).^I.*HIJ.*(rho2cbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho2cbar.*I.*(1./T2cbar-1).^(I-1).*(-1./T2cbar.^2).*HIJ.*(rho2cbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T2cbar-1).^I.*HIJ.*(rho2cbar-1).^J,2) + sum(rho2cbar.*(1./T2cbar-1).^I.*J.*HIJ.*(rho2cbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid2c) = -dmudrho./v2.^2.*dvdp_ph(p2c,h2) + dmudT.*dTdp_ph(p2c,h2);
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);T3 = T3a_ph(p3a,h3a);T3abar = T3/Tc;v3 = v3a_ph(p3a,h3a);rho3abar = 1./v3/rhoc;
    mu0 = 100*sqrt(T3abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3abar)./T3abar)./T3abar);
    dmu0dT = mu0/2./T3abar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T3abar)./T3abar)./T3abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3abar)./T3abar)./T3abar);
    L = length(p3a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T3abar = T3abar*ones(1,Nterms);rho3abar = rho3abar*ones(1,Nterms);
    mu1 = exp(sum(rho3abar.*(1./T3abar-1).^I.*HIJ.*(rho3abar-1).^J,2));
    dmu1dT = mu1.*(sum(rho3abar.*I.*(1./T3abar-1).^(I-1).*(-1./T3abar.^2).*HIJ.*(rho3abar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T3abar-1).^I.*HIJ.*(rho3abar-1).^J,2) + sum(rho3abar.*(1./T3abar-1).^I.*J.*HIJ.*(rho3abar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid3a) = -dmudrho./v3.^2.*dvdp_ph(p3a,h3a) + dmudT.*dTdp_ph(p3a,h3a);
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);T3 = T3b_ph(p3b,h3b);T3bbar = T3/Tc;v3 = v3b_ph(p3b,h3b);rho3bbar = 1./v3/rhoc;
    mu0 = 100*sqrt(T3bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3bbar)./T3bbar)./T3bbar);
    dmu0dT = mu0/2./T3bbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T3bbar)./T3bbar)./T3bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T3bbar)./T3bbar)./T3bbar);
    L = length(p3b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T3bbar = T3bbar*ones(1,Nterms);rho3bbar = rho3bbar*ones(1,Nterms);
    mu1 = exp(sum(rho3bbar.*(1./T3bbar-1).^I.*HIJ.*(rho3bbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho3bbar.*I.*(1./T3bbar-1).^(I-1).*(-1./T3bbar.^2).*HIJ.*(rho3bbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T3bbar-1).^I.*HIJ.*(rho3bbar-1).^J,2) + sum(rho3bbar.*(1./T3bbar-1).^I.*J.*HIJ.*(rho3bbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid3b) = -dmudrho./v3.^2.*dvdp_ph(p3b,h3b) + dmudT.*dTdp_ph(p3b,h3b);
end
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);h1L4a = h1L(valid4a);
    h4 = h(valid4a);x = (h4-h1L4a)./(h2V(valid4a)-h1L4a); % quality
    v1L = v1_pT(p4a,Tsat4a); % [m^3/kg] saturated liquid specific volumes
    v2V = v2_pT(p4a,Tsat4a); % [m^3/kg] saturated vapor specific volumes
    T4abar = Tsat4a/Tc;v4 = v1L + x.*(v2V - v1L);rho4abar = 1./v4/rhoc;
    mu0 = 100*sqrt(T4abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4abar)./T4abar)./T4abar);
    dmu0dT = mu0/2./T4abar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T4abar)./T4abar)./T4abar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4abar)./T4abar)./T4abar);
    L = length(p4a);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T4abar = T4abar*ones(1,Nterms);rho4abar = rho4abar*ones(1,Nterms);
    mu1 = exp(sum(rho4abar.*(1./T4abar-1).^I.*HIJ.*(rho4abar-1).^J,2));
    dmu1dT = mu1.*(sum(rho4abar.*I.*(1./T4abar-1).^(I-1).*(-1./T4abar.^2).*HIJ.*(rho4abar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T4abar-1).^I.*HIJ.*(rho4abar-1).^J,2) + sum(rho4abar.*(1./T4abar-1).^I.*J.*HIJ.*(rho4abar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid4a) = -dmudrho./v4.^2.*dvdp_ph(p4a,h4) + dmudT.*dTdp_ph(p4a,h4);
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);
    v3L = vL_p(p4b); v3V = vV_p(p4b);
    h3L = h3_rhoT(1./v3L,Tsat4b);
    h3V = h3_rhoT(1./v3V,Tsat4b);
    h4 = h(valid4b);x = (h4-h3L)./(h3V-h3L); % quality
    T4bbar = Tsat4b/Tc;v4 = v3L + x.*(v3V - v3L);rho4bbar = 1./v4/rhoc;
    mu0 = 100*sqrt(T4bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4bbar)./T4bbar)./T4bbar);
    dmu0dT = mu0/2./T4bbar.*(Hi(1) + (3*Hi(2) + (5*Hi(3) + 7*Hi(4)./T4bbar)./T4bbar)./T4bbar)./(Hi(1) + (Hi(2) + (Hi(3) + Hi(4)./T4bbar)./T4bbar)./T4bbar);
    L = length(p4b);I = ones(L,1)*Hij(1,:);J = ones(L,1)*Hij(2,:);HIJ = ones(L,1)*Hij(3,:);
    T4bbar = T4bbar*ones(1,Nterms);rho4bbar = rho4bbar*ones(1,Nterms);
    mu1 = exp(sum(rho4bbar.*(1./T4bbar-1).^I.*HIJ.*(rho4bbar-1).^J,2));
    dmu1dT = mu1.*(sum(rho4bbar.*I.*(1./T4bbar-1).^(I-1).*(-1./T4bbar.^2).*HIJ.*(rho4bbar-1).^J,2));
    dmudT = (dmu0dT.*mu1 + mu0.*dmu1dT)*mustar/Tc;
    dmu1drho = mu1.*(sum((1./T4bbar-1).^I.*HIJ.*(rho4bbar-1).^J,2) + sum(rho4bbar.*(1./T4bbar-1).^I.*J.*HIJ.*(rho4bbar-1).^(J-1),2));
    dmudrho = mu0.*dmu1drho*mustar/rhoc;
    dmudp(valid4b) = -dmudrho./v4.^2.*dvdp_ph(p4b,h4) + dmudT.*dTdp_ph(p4b,h4);
end
end
function dhLdp = dhLdp_p(p)
% dhLdp = dhLdp_ph(p)
%   Derivative of enthalpy wrt pressure of saturated liquid, dhLdp [(kJ/kg)/MPa], as a function of pressure, p [MPa]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 16, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
dhLdp = NaN(dim);
%% constants and calculated
conversion_factor = 1e-3; % [MPa/(kJ/m^3)]
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pc = 22.064; % [MPa] critical pressure
Tsat = Tsat_p(p); % [K] saturation temperatures
%% valid ranges
valid4a = p>=pmin & p<=pB13sat; % valid range for saturated liquid in region 4a
valid4b = p>pB13sat & p<=pc; % valid range for saturated liquid in region 4b
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);
    dhLdp(valid4a) = v1_pT(p4a,Tsat4a).*(1-Tsat4a.*alphav1_pT(p4a,Tsat4a))/conversion_factor + cp1_pT(p4a,Tsat4a).*dTsatdpsat_p(p4a); % [(kJ/kg)/MPa]
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);v3L = vL_p(p4b);rho3L = 1./v3L;dTsatdpsat4b = dTsatdpsat_p(p4b);alphap3L = alphap3_rhoT(rho3L,Tsat4b);
    dhLdp(valid4b) = (v3L - Tsat4b.*alphap3L./betap3_rhoT(rho3L,Tsat4b).*(1 + p4b.*alphap3L.*dTsatdpsat4b))/conversion_factor - cv3_rhoT(rho3L,Tsat4b).*dTsatdpsat4b;
end
end
function dhVdp = dhVdp_p(p)
% dhVdp = dhVdp_ph(p)
%   Derivative of enthalpy wrt pressure of saturated vapor, dhVdp [(kJ/kg)/MPa], as a function of pressure, p [MPa]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 16, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
dhVdp = NaN(dim);
%% constants and calculated
conversion_factor = 1e-3; % [MPa/(kJ/m^3)]
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pc = 22.064; % [MPa] critical pressure
Tsat = Tsat_p(p); % [K] saturation temperatures
%% valid ranges
valid4a = p>=pmin & p<=pB13sat; % valid range for saturated liquid in region 4a
valid4b = p>pB13sat & p<=pc; % valid range for saturated liquid in region 4b
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);
    dhVdp(valid4a) = v2_pT(p4a,Tsat4a).*(1-Tsat4a.*alphav2_pT(p4a,Tsat4a))/conversion_factor + cp2_pT(p4a,Tsat4a).*dTsatdpsat_p(p4a); % [(kJ/kg)/MPa]
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);v3V = vV_p(p4b);rho3V = 1./v3V;dTsatdpsat4b = dTsatdpsat_p(p4b);alphap3V = alphap3_rhoT(rho3V,Tsat4b);
    dhVdp(valid4b) = (v3V - Tsat4b.*alphap3V./betap3_rhoT(rho3V,Tsat4b).*(1 + p4b.*alphap3V.*dTsatdpsat4b))/conversion_factor - cv3_rhoT(rho3V,Tsat4b).*dTsatdpsat4b;
end
end
function dvdp = dvdp_ph(p,h)
% dvdp = dvdp_ph(p,h)
%   Derivative of specific volume wrt pressure at constant enthalpy of liquid, vapor or mixture, dvdp [m^3/kg/MPa], as
%   functions of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 10, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
dvdp = initnan;
%% constants and calculated scalars
conversion_factor = 1e-3; % [MPa/(kJ/m^3)]
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4a = p>=pmin & p<=pB13sat & h>h1L & h<=h2V; % valid range for region 4a
valid4b = p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V; % valid range for region 4b
if any(any(valid1))
    p1 = p(valid1);T1 = T1_ph(p1,h(valid1));v1 = v1_pT(p1,T1);alphav1 = alphav1_pT(p1,T1);
    dvdp(valid1) = -v1.*(kappaT1_pT(p1,T1) + alphav1.*v1.*(1 - T1.*alphav1)./cp1_pT(p1,T1)/conversion_factor);
end
if any(any(valid2a))
    p2a = p(valid2a);T2a = T2a_ph(p2a,h(valid2a));v2a = v2_pT(p2a,T2a);alphav2a = alphav2_pT(p2a,T2a);
    dvdp(valid2a) = -v2a.*(kappaT2_pT(p2a,T2a) + alphav2a.*v2a.*(1 - T2a.*alphav2a)./cp2_pT(p2a,T2a)/conversion_factor);
end
if any(any(valid2b))
    p2b = p(valid2b);T2b = T2b_ph(p2b,h(valid2b));v2b = v2_pT(p2b,T2b);alphav2b = alphav2_pT(p2b,T2b);
    dvdp(valid2b) = -v2b.*(kappaT2_pT(p2b,T2b) + alphav2b.*v2b.*(1 - T2b.*alphav2b)./cp2_pT(p2b,T2b)/conversion_factor);
end
if any(any(valid2c))
    p2c = p(valid2c);T2c = T2c_ph(p2c,h(valid2c));v2c = v2_pT(p2c,T2c);alphav2c = alphav2_pT(p2c,T2c);
    dvdp(valid2c) = -v2c.*(kappaT2_pT(p2c,T2c) + alphav2c.*v2c.*(1 - T2c.*alphav2c)./cp2_pT(p2c,T2c)/conversion_factor);
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);T3a = T3a_ph(p3a,h3a);v3a = v3a_ph(p3a,h3a);
    rho3a = 1./v3a;alphap3a = alphap3_rhoT(rho3a,T3a);betap3a = betap3_rhoT(rho3a,T3a);
    dvdp(valid3a) = -1./p3a./(betap3a + alphap3a.*p3a.*(T3a.*alphap3a - v3a.*betap3a)./(cv3_rhoT(rho3a,T3a)*conversion_factor + p3a.*v3a.*alphap3a));
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);T3b = T3b_ph(p3b,h3b);v3b = v3b_ph(p3b,h3b);
    rho3b = 1./v3b;alphap3b = alphap3_rhoT(rho3b,T3b);betap3b = betap3_rhoT(rho3b,T3b);
    dvdp(valid3b) = -1./p3b./(betap3b + alphap3b.*p3b.*(T3b.*alphap3b - v3b.*betap3b)./(cv3_rhoT(rho3b,T3b)*conversion_factor + p3b.*v3b.*alphap3b));
end
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);vL4a = v1_pT(p4a,Tsat4a);vV4a = v2_pT(p4a,Tsat4a);dTsatdpsat4a = dTsatdpsat_p(p4a);
    alphavL4a = alphav1_pT(p4a,Tsat4a);alphavV4a = alphav2_pT(p4a,Tsat4a);hL4a = h1_pT(p4a,Tsat4a);hV4a = h2_pT(p4a,Tsat4a);
    dvLdp = vL4a.*(-kappaT1_pT(p4a,Tsat4a) + alphavL4a.*dTsatdpsat4a); % [(m^3/kg)/MPa]
    dvVdp = vV4a.*(-kappaT2_pT(p4a,Tsat4a) + alphavV4a.*dTsatdpsat4a); % [(m^3/kg)/MPa]
    dhLdp = vL4a.*(1-Tsat4a.*alphavL4a)/conversion_factor + cp1_pT(p4a,Tsat4a).*dTsatdpsat4a; % [(kJ/kg)/MPa]
    dhVdp = vV4a.*(1-Tsat4a.*alphavV4a)/conversion_factor + cp2_pT(p4a,Tsat4a).*dTsatdpsat4a; % [(kJ/kg)/MPa]
    hfg = hV4a-hL4a;vfg = vV4a-vL4a;
    dvdp(valid4a) = dvLdp + ((h(valid4a)-hL4a).*((dvVdp-dvLdp) - (dhVdp-dhLdp).*vfg./hfg) - dhLdp.*vfg)./hfg;
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);v3L = vL_p(p4b);rho3L = 1./v3L;v3V = vV_p(p4b);rho3V = 1./v3V;
    h3L = h3_rhoT(rho3L,Tsat4b);h3V = h3_rhoT(rho3V,Tsat4b);betap3L = betap3_rhoT(rho3L,Tsat4b);betap3V = betap3_rhoT(rho3V,Tsat4b);
    dTsatdpsat4b = dTsatdpsat_p(p4b);alphap3L = alphap3_rhoT(rho3L,Tsat4b);alphap3V = alphap3_rhoT(rho3V,Tsat4b);
    dvLdp = -(1./p4b + alphap3L.*dTsatdpsat4b)./betap3L; % [(m^3/kg)/MPa]
    dvVdp = -(1./p4b + alphap3V.*dTsatdpsat4b)./betap3V; % [(m^3/kg)/MPa]
    dhLdp = (v3L - Tsat4b.*alphap3L./betap3L.*(1 + p4b.*alphap3L.*dTsatdpsat4b))/conversion_factor - cv3_rhoT(rho3L,Tsat4b).*dTsatdpsat4b;
    dhVdp = (v3V - Tsat4b.*alphap3V./betap3V.*(1 + p4b.*alphap3V.*dTsatdpsat4b))/conversion_factor - cv3_rhoT(rho3V,Tsat4b).*dTsatdpsat4b;
    hfg = h3V-h3L;vfg = v3V-v3L;
    dvdp(valid4b) = dvLdp + ((h(valid4b)-h3L).*((dvVdp-dvLdp) - (dhVdp-dhLdp).*vfg./hfg) - dhLdp.*vfg)./hfg;
end
end
function dvdh = dvdh_ph(p,h)
% dvdh = dvdh_ph(p,h)
%   Derivative of specific volume wrt enthalpy at constant pressure of liquid, vapor or mixture, dvdh [(m^3/kg)/(kJ/kg)],
%   as functions of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 10, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
dvdh = initnan;
%% constants and calculated scalars
conversion_factor = 1000; % [(kJ/m^3)/MPa]
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4a = p>=pmin & p<=pB13sat & h>h1L & h<=h2V; % valid range for region 4a
valid4b = p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V; % valid range for region 4b
if any(any(valid1))
    p1 = p(valid1);T1 = T1_ph(p1,h(valid1));
    dvdh(valid1) = v1_pT(p1,T1).*alphav1_pT(p1,T1)./cp1_pT(p1,T1);
end
if any(any(valid2a))
    p2a = p(valid2a);T2a = T2a_ph(p2a,h(valid2a));
    dvdh(valid2a) = v2_pT(p2a,T2a).*alphav2_pT(p2a,T2a)./cp2_pT(p2a,T2a);
end
if any(any(valid2b))
    p2b = p(valid2b);T2b = T2b_ph(p2b,h(valid2b));
    dvdh(valid2b) = v2_pT(p2b,T2b).*alphav2_pT(p2b,T2b)./cp2_pT(p2b,T2b);
end
if any(any(valid2c))
    p2c = p(valid2c);T2c = T2c_ph(p2c,h(valid2c));
    dvdh(valid2c) = v2_pT(p2c,T2c).*alphav2_pT(p2c,T2c)./cp2_pT(p2c,T2c);
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);T3a = T3a_ph(p3a,h3a);v3a = v3a_ph(p3a,h3a);
    rho3a = 1./v3a;alphap3a = alphap3_rhoT(rho3a,T3a);betap3a = betap3_rhoT(rho3a,T3a);
    dvdh(valid3a) = 1./(conversion_factor*p3a.*(T3a.*alphap3a - v3a.*betap3a) + betap3a.*(cv3_rhoT(rho3a,T3a)./alphap3a + conversion_factor*p3a.*v3a));
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);T3b = T3b_ph(p3b,h3b);v3b = v3b_ph(p3b,h3b);
    rho3b = 1./v3b;alphap3b = alphap3_rhoT(rho3b,T3b);betap3b = betap3_rhoT(rho3b,T3b);
    dvdh(valid3b) = 1./(conversion_factor*p3b.*(T3b.*alphap3b - v3b.*betap3b) + betap3b.*(cv3_rhoT(rho3b,T3b)./alphap3b + conversion_factor*p3b.*v3b));
end
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);
    dvdh(valid4a) = (v2_pT(p4a,Tsat4a) - v1_pT(p4a,Tsat4a))./(h2V(valid4a)-h1L(valid4a));
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);
    v3L = vL_p(p4b); v3V = vV_p(p4b);
    h3L = h3_rhoT(1./v3L,Tsat4b);
    h3V = h3_rhoT(1./v3V,Tsat4b);
    dvdh(valid4b) = (v3V - v3L)./(h3V-h3L);
end
end
function dTdp = dTdp_ph(p,h)
% dTdp = dTdp_ph(p,h)
%   Derivative of temperature wrt pressure at constant enthalpy of liquid, vapor or mixture, dTdp [K/MPa], as functions of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 10, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
dTdp = initnan;
%% constants and calculated scalars
conversion_factor = 1e-3; % [MPa/(kJ/m^3)]
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4 = (p>=pmin & p<=pB13sat & h>h1L & h<=h2V) | (p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V); % valid range for region 4
if any(any(valid1))
    p1 = p(valid1);T1 = T1_ph(p1,h(valid1));
    dTdp(valid1) = -v1_pT(p1,T1).*(1 - T1.*alphav1_pT(p1,T1))./cp1_pT(p1,T1)/conversion_factor;
end
if any(any(valid2a))
    p2a = p(valid2a);T2a = T2a_ph(p2a,h(valid2a));
    dTdp(valid2a) = -v2_pT(p2a,T2a).*(1 - T2a.*alphav2_pT(p2a,T2a))./cp2_pT(p2a,T2a)/conversion_factor;
end
if any(any(valid2b))
    p2b = p(valid2b);T2b = T2b_ph(p2b,h(valid2b));
    dTdp(valid2b) = -v2_pT(p2b,T2b).*(1 - T2b.*alphav2_pT(p2b,T2b))./cp2_pT(p2b,T2b)/conversion_factor;
end
if any(any(valid2c))
    p2c = p(valid2c);T2c = T2c_ph(p2c,h(valid2c));
    dTdp(valid2c) = -v2_pT(p2c,T2c).*(1 - T2c.*alphav2_pT(p2c,T2c))./cp2_pT(p2c,T2c)/conversion_factor;
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);T3a = T3a_ph(p3a,h3a);v3a = v3a_ph(p3a,h3a);
    rho3a = 1./v3a;alphap3a = alphap3_rhoT(rho3a,T3a);betap3a = betap3_rhoT(rho3a,T3a);
    dTdp(valid3a) = 1./(betap3a.*(cv3_rhoT(rho3a,T3a)*conversion_factor + p3a.*v3a.*alphap3a)./(T3a.*alphap3a - v3a.*betap3a) + alphap3a.*p3a);
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);T3b = T3b_ph(p3b,h3b);v3b = v3b_ph(p3b,h3b);
    rho3b = 1./v3b;alphap3b = alphap3_rhoT(rho3b,T3b);betap3b = betap3_rhoT(rho3b,T3b);
    dTdp(valid3b) = 1./(betap3b.*(cv3_rhoT(rho3b,T3b)*conversion_factor + p3b.*v3b.*alphap3b)./(T3b.*alphap3b - v3b.*betap3b) + alphap3b.*p3b);
end
if any(any(valid4))
    dTdp(valid4) = dTsatdpsat_p(p(valid4));
end
end
function cp = cp_ph(p,h)
% cp = cp_ph(p,h)
%   Specific heat at constant pressure of liquid, vapor or mixture, cp [kJ/kg/K], as functions of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 9, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
cp = initnan;
%% constants and calculated scalars
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4 = (p>=pmin & p<=pB13sat & h>h1L & h<=h2V) | (p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V); % valid range for region 4
if any(any(valid1))
    p1 = p(valid1);
    cp(valid1) = cp1_pT(p1,T1_ph(p1,h(valid1)));
end
if any(any(valid2a))
    p2a = p(valid2a);
    cp(valid2a) = cp2_pT(p2a,T2a_ph(p2a,h(valid2a)));
end
if any(any(valid2b))
    p2b = p(valid2b);
    cp(valid2b) = cp2_pT(p2b,T2b_ph(p2b,h(valid2b)));
end
if any(any(valid2c))
    p2c = p(valid2c);
    cp(valid2c) = cp2_pT(p2c,T2c_ph(p2c,h(valid2c)));
end
if any(any(valid3a))
    p3a = p(valid3a);h3a = h(valid3a);
    cp(valid3a) = cp3_rhoT(1./v3a_ph(p3a,h3a),T3a_ph(p3a,h3a));
end
if any(any(valid3b))
    p3b = p(valid3b);h3b = h(valid3b);
    cp(valid3b) = cp3_rhoT(1./v3b_ph(p3b,h3b),T3b_ph(p3b,h3b));
end
if any(any(valid4))
    cp(valid4) = Inf;
end
end
function h = h_pT(p,T)
% h = h_pT(p,T)
%   Enthalpy, h [kJ/kg], as a function of pressure, p [MPa], and temperature, T [K]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 9, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
h = initnan;
%% constants and calculated
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
TB23 = 863.15; % [K] temperature of boundary between region 2 and 3
Tmax = 1073.15; % [K] maximum valid temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pmax = 100; % [MPa] maximum valid pressure
psat = psat_T(T); % [MPa] saturation pressures
pB23 = initnan; valid = T>=TB13 & T<=TB23;
pB23(valid) = pB23_T(T(valid)); % [MPa] pressure on boundary between region 2 and region 3
%% valid ranges
valid1 = p>=psat & p<=pmax & T>=Tmin & T<=TB13; % valid range for region 1, include B13 in region 1
valid2 = p>=pmin & ((T>=Tmin & T<=TB13 & p<=psat) | (T>TB13 & T<=TB23 & p<=pB23) | (T>TB23 & T<=Tmax & p<=pmax)); % valid range for region 2, include B23 in region 2
valid3 = p>pB23 & p<=pmax & T>TB13 & T<TB23;
if any(any(valid1))
    h(valid1) = h1_pT(p(valid1),T(valid1));
end
if any(any(valid2))
    h(valid2) = h2_pT(p(valid2),T(valid2));
end
if any(any(valid3))
    T3 = T(valid3);
    h(valid3) = h3_rhoT(1./v_pT(p(valid3),T3),T3);
end
end
function v = v_pT(p,T)
% v = v_pT(p,T)
%   Specific volume, v [m^3/kg], as a function of pressure, p [MPa], and temperature, T [K]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 8, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
v = initnan;
%% constants and calculated
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
TB23 = 863.15; % [K] temperature of boundary between region 2 and 3
Tmax = 1073.15; % [K] maximum valid temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pmax = 100; % [MPa] maximum valid pressure
psat = psat_T(T); % [MPa] saturation pressures
pB23 = initnan; valid = T>=TB13 & T<=TB23;
pB23(valid) = pB23_T(T(valid)); % [MPa] pressure on boundary between region 2 and region 3
%% valid ranges for region 1 and region 2
valid1 = p>=psat & p<=pmax & T>=Tmin & T<=TB13; % valid range for region 1, include B13 in region 1
valid2 = p>=pmin & ((T>=Tmin & T<=TB13 & p<=psat) | (T>TB13 & T<=TB23 & p<=pB23) | (T>TB23 & T<=Tmax & p<=pmax)); % valid range for region 2, include B23 in region 2
valid3 = p>pB23 & p<=pmax & T>TB13 & T<TB23;
if any(any(valid1))
    v(valid1) = v1_pT(p(valid1),T(valid1));
end
if any(any(valid2))
    v(valid2) = v2_pT(p(valid2),T(valid2));
end
%% region 3
if any(any(valid3))
    %% region 3: constants, calculated and valid ranges
    pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and region 3, 16.5291643 MPa
    p3q = psat_T(643.15); % [MPa] pressure between region 3q and 3s, 21.0434 MPa
    p3cd = 19.00881189173929; % [MPa] where T3cd_p interested psat_T at 643.659 K
    pc = 22.064; % [MPa] critical pressure
    TB23 = initnan;valid = p>=pB13sat & p<=pmax;
    TB23(valid) = TB23_p(p(valid)); % [K] this replaces the previous scalar TB23 = 863.15 K with the curve from TB23 = 863.15 K at 100 MPa to TB23 = 623.15 K at 16.5292 MPa
    Tsat = Tsat_p(p); % [K] saturation temperatures
    valid3ab = p>40 & p<=pmax;
    valid3cdef = p>25 & p<=40;
    valid3cghijk = p>23.5 & p<=25;
    valid3clhijk = p>23 & p<=23.5;
    valid3clmnopjk = p>22.5 & p<=23;
    valid3cqrk = p>p3q & p<=22.5;
    valid3csrk = p>20.5 & p<=p3q;
    valid3cst = p>p3cd & p<=20.5;
    valid3ct = p>pB13sat & p<=p3cd;
    %% region 3:boundary functions
    validT3ab = p>25 & p<=pmax; % valid3ab | valid3cdef
    T3ab = initnan;
    T3ab(validT3ab) = T3ab_p(p(validT3ab));
    validT3cd = p>p3cd & p<=40; % valid3cdef | valid3cghijk | valid3clhijk | valid3clmnopjk | valid3cqrk | valid3csrk | valid3cst
    T3cd = initnan;
    T3cd(validT3cd) = T3cd_p(p(validT3cd));
    validT3ef = p>pc & p<=40; % valid3cdef | valid3cghijk | valid3clhijk | valid3clmnopjk | valid3cqrk | valid3uwvx | valid3uzyx, extends into region very close to critical point
    T3ef = initnan;
    T3ef(validT3ef) = T3ef_p(p(validT3ef));
    validT3ghij = p>22.5 & p<=25; % valid3cghijk | valid3clhijk | valid3clmnopjk
    T3gh = initnan;T3ij = initnan;
    T3gh(validT3ghij) = T3gh_p(p(validT3ghij));
    T3ij(validT3ghij) = T3ij_p(p(validT3ghij));
    valid3Tjk = p>20.5 & p<=25; % valid3cghijk | valid3clhijk | valid3clmnopjk | valid3cqrk | valid3csrk
    T3jk = initnan;
    T3jk(valid3Tjk) = T3jk_p(p(valid3Tjk));
    T3mn = initnan;T3op = initnan;
    T3mn(valid3clmnopjk) = T3mn_p(p(valid3clmnopjk));
    T3op(valid3clmnopjk) = T3op_p(p(valid3clmnopjk));
    T3qu = initnan;T3rx = initnan;
    T3qu(valid3cqrk) = T3qu_p(p(valid3cqrk));
    T3rx(valid3cqrk) = T3rx_p(p(valid3cqrk));
    %% region 3: valid ranges
    valid3a = valid3ab & T>TB13 & T<=T3ab; % B13 is already included in region 1
    valid3b = valid3ab & T>T3ab & T<TB23; % B23 is already included in region 2
    valid3c = ((valid3cdef | valid3cghijk | valid3clhijk | valid3clmnopjk | valid3cqrk | valid3csrk | valid3cst) & T>TB13 & T<=T3cd) | (valid3ct & T>TB13 & T<=Tsat); % B13 is already included in region 1
    valid3d = valid3cdef & T>T3cd & T<=T3ab;
    valid3e = valid3cdef & T>T3ab & T<=T3ef;
    valid3f = valid3cdef & T>T3ef & T<TB23; % B23 is already included in region 2
    valid3g = valid3cghijk & T>T3cd & T<=T3gh;
    valid3h = (valid3cghijk | valid3clhijk) & T>T3gh & T<=T3ef;
    valid3i = (valid3cghijk | valid3clhijk) & T>T3ef & T<=T3ij;
    valid3j = (valid3cghijk | valid3clhijk | valid3clmnopjk) & T>T3ij & T<=T3jk;
    valid3k = (valid3cghijk | valid3clhijk | valid3clmnopjk | valid3cqrk | valid3csrk) & T>T3jk & T<TB23; % B23 is already included in region 2
    valid3l = (valid3clhijk | valid3clmnopjk) & T>T3cd & T<=T3gh;
    valid3m = valid3clmnopjk & T>T3gh & T<=T3mn;
    valid3n = valid3clmnopjk & T>T3mn & T<=T3ef;
    valid3o = valid3clmnopjk & T>T3ef & T<=T3op;
    valid3p = valid3clmnopjk & T>T3op & T<=T3ij;
    valid3q = valid3cqrk & T>T3cd & T<=T3qu;
    valid3r = (valid3cqrk & T>T3rx & T<=T3jk) | (valid3csrk & T>Tsat & T<=T3jk);
    valid3s = (valid3csrk | valid3cst) & T>T3cd & T<=Tsat;
    valid3t = (valid3cst | valid3ct) & T>Tsat & T<TB23; % B23 is already included in region 2
    if any(any(valid3a))
        v(valid3a) = v3a_pT(p(valid3a),T(valid3a));
    end
    if any(any(valid3b))
        v(valid3b) = v3b_pT(p(valid3b),T(valid3b));
    end
    if any(any(valid3c))
        v(valid3c) = v3c_pT(p(valid3c),T(valid3c));
    end
    if any(any(valid3d))
        v(valid3d) = v3d_pT(p(valid3d),T(valid3d));
    end
    if any(any(valid3e))
        v(valid3e) = v3e_pT(p(valid3e),T(valid3e));
    end
    if any(any(valid3f))
        v(valid3f) = v3f_pT(p(valid3f),T(valid3f));
    end
    if any(any(valid3g))
        v(valid3g) = v3g_pT(p(valid3g),T(valid3g));
    end
    if any(any(valid3h))
        v(valid3h) = v3h_pT(p(valid3h),T(valid3h));
    end
    if any(any(valid3i))
        v(valid3i) = v3i_pT(p(valid3i),T(valid3i));
    end
    if any(any(valid3j))
        v(valid3j) = v3j_pT(p(valid3j),T(valid3j));
    end
    if any(any(valid3k))
        v(valid3k) = v3k_pT(p(valid3k),T(valid3k));
    end
    if any(any(valid3l))
        v(valid3l) = v3l_pT(p(valid3l),T(valid3l));
    end
    if any(any(valid3m))
        v(valid3m) = v3m_pT(p(valid3m),T(valid3m));
    end
    if any(any(valid3n))
        v(valid3n) = v3n_pT(p(valid3n),T(valid3n));
    end
    if any(any(valid3o))
        v(valid3o) = v3o_pT(p(valid3o),T(valid3o));
    end
    if any(any(valid3p))
        v(valid3p) = v3p_pT(p(valid3p),T(valid3p));
    end
    if any(any(valid3q))
        v(valid3q) = v3q_pT(p(valid3q),T(valid3q));
    end
    if any(any(valid3r))
        v(valid3r) = v3r_pT(p(valid3r),T(valid3r));
    end
    if any(any(valid3s))
        v(valid3s) = v3s_pT(p(valid3s),T(valid3s));
    end
    if any(any(valid3t))
        v(valid3t) = v3t_pT(p(valid3t),T(valid3t));
    end
    %% region 3: auxiliary equations for region very close to critical point
    if any(any(valid3cqrk & T>T3qu & T<=T3rx))
        p3y = 21.93161551; % [MPa]
        p3z = 21.90096265; % [MPa]
        valid3uwvx = p>22.11 & p<=22.5;
        valid3uzyx = p>pc & p<=22.11;
        valid3uy = p>p3y & p<=pc;
        valid3zx = p>p3z & p<=pc;
        validT3uv = valid3uwvx | valid3uzyx | valid3uy; T3uv = initnan;
        T3uv(validT3uv) = T3uv_p(p(validT3uv)); % [K]
        validT3wx = valid3uwvx | valid3uzyx | valid3zx; T3wx = initnan;
        T3wx(validT3wx) = T3wx_p(p(validT3wx)); % [K]
        valid3u = ((valid3uwvx | valid3uzyx | valid3uy) & T>T3qu & T<=T3uv) | (p>p3q & p<=p3y & T>T3qu & T<=Tsat);
        valid3v = valid3uwvx & T>T3uv & T<=T3ef;
        valid3w = valid3uwvx & T>T3ef & T<=T3wx;
        valid3x = ((valid3uwvx | valid3uzyx | valid3zx) & T>T3wx & T<=T3rx) | (p>p3q & p<=p3z & T>Tsat & T<=T3rx);
        valid3y = (valid3uzyx & T>T3uv & T<=T3ef) | (valid3uy & T>T3uv & T<=Tsat);
        valid3z = (valid3uzyx & T>T3ef & T<=T3wx) | (valid3zx & T>Tsat & T<=T3wx);
        if any(any(valid3u))
            v(valid3u) = v3u_pT(p(valid3u),T(valid3u));
        end
        if any(any(valid3v))
            v(valid3v) = v3v_pT(p(valid3v),T(valid3v));
        end
        if any(any(valid3w))
            v(valid3w) = v3w_pT(p(valid3w),T(valid3w));
        end
        if any(any(valid3x))
            v(valid3x) = v3x_pT(p(valid3x),T(valid3x));
        end
        if any(any(valid3y))
            v(valid3y) = v3y_pT(p(valid3y),T(valid3y));
        end
        if any(any(valid3z))
            v(valid3z) = v3z_pT(p(valid3z),T(valid3z));
        end
    end
end
end
function v = vL_p(p)
% v = vL_p(p)
%   Specific volume of saturated liquid, v [m^3/kg], as a function of pressure, p [MPa]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 5, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
v = NaN(dim);
%% constants and calculated
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pc = 22.064; % [MPa] critical pressure
Tsat = Tsat_p(p); % [K] saturation temperatures
%% valid ranges
valid4a = p>=pmin & p<=pB13sat; % valid range for saturated liquid in region 4a
valid4b = p>pB13sat & p<=pc; % valid range for saturated liquid in region 4b
if any(any(valid4a))
    v(valid4a) = v1_pT(p(valid4a),Tsat(valid4a)); % [kJ/kg] saturated liquid enthalpies in region 1
end
if any(any(valid4b))
    p3cd = 19.00881189173929; % [MPa] pressure given by T3cd_p(p) = Tsat_p(p)
    valid3c = p>pB13sat & p<=p3cd;
    p3q = psat_T(643.15); % [MPa] 21.0434 MPa
    valid3s = p>p3cd & p<=p3q;
    p3y = 21.93161551; % [MPa] p3sat_v(0.00264 m^3/kg), n.b. p3sat_v is not an available function yet
    valid3u = p>p3q & p<=p3y;
    valid3y = p>p3y & p<=pc;
    if any(any(valid3c))
        v(valid3c) = v3c_pT(p(valid3c),Tsat(valid3c));
    end
    if any(any(valid3s))
        v(valid3s) = v3s_pT(p(valid3s),Tsat(valid3s));
    end
    if any(any(valid3u))
        v(valid3u) = v3u_pT(p(valid3u),Tsat(valid3u));
    end
    if any(any(valid3y))
        v(valid3y) = v3y_pT(p(valid3y),Tsat(valid3y));
    end
end
end
function v = vV_p(p)
% v = vV_p(p)
%   Specific volume of saturated vapor, v [m^3/kg], as a function of pressure, p [MPa]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 5, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
v = NaN(dim);
%% constants and calculated
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pc = 22.064; % [MPa] critical pressure
Tsat = Tsat_p(p); % [K] saturation temperatures
%% valid ranges
valid4a = p>=pmin & p<=pB13sat; % valid range for saturated liquid in region 4a
valid4b = p>pB13sat & p<=pc; % valid range for saturated liquid in region 4b
if any(any(valid4a))
    v(valid4a) = v2_pT(p(valid4a),Tsat(valid4a)); % [kJ/kg] saturated liquid enthalpies in region 2
end
if any(any(valid4b))
    valid3t = p>pB13sat & p<=20.5;
    p3q = psat_T(643.15); % [MPa] 21.0434 MPa
    valid3r = p>20.5 & p<=p3q;
    p3z = 21.90096265; % [MPa] p3sat_v(0.00385 m^3/kg), n.b. p3sat_v is not an available function yet
    valid3x = p>p3q & p<=p3z;
    valid3z = p>p3z & p<=pc;
    if any(any(valid3t))
        v(valid3t) = v3t_pT(p(valid3t),Tsat(valid3t));
    end
    if any(any(valid3r))
        v(valid3r) = v3r_pT(p(valid3r),Tsat(valid3r));
    end
    if any(any(valid3x))
        v(valid3x) = v3x_pT(p(valid3x),Tsat(valid3x));
    end
    if any(any(valid3z))
        v(valid3z) = v3z_pT(p(valid3z),Tsat(valid3z));
    end
end
end
function h = hL_p(p)
% h = hL_p(p)
%   Enthalpy of saturated liquid, h [kJ/kg], as a function of pressure, p [MPa]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 2, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
h = NaN(dim);
%% constants and calculated
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pc = 22.064; % [MPa] critical pressure
Tsat = Tsat_p(p); % [K] saturation temperatures
%% valid ranges
valid4a = p>=pmin & p<=pB13sat; % valid range for saturated liquid in region 4a
valid4b = p>pB13sat & p<=pc; % valid range for saturated liquid in region 4b
if any(any(valid4a))
    h(valid4a) = h1_pT(p(valid4a),Tsat(valid4a)); % [kJ/kg] saturated liquid enthalpies in region 1
end
if any(any(valid4b))
    h(valid4b) = h3_rhoT(1./vL_p(p(valid4b)),Tsat(valid4b));
end
end
function h = hV_p(p)
% h = hV_p(p)
%   Enthalpy of saturated vapor, h [kJ/kg], as a function of pressure, p [MPa]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 2, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
h = NaN(dim);
%% constants and calculated
Tmin = 273.16; % [K] minimum temperature is triple point
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pc = 22.064; % [MPa] critical pressure
Tsat = Tsat_p(p); % [K] saturation temperatures
%% valid ranges
valid4a = p>=pmin & p<=pB13sat; % valid range for saturated liquid in region 4a
valid4b = p>pB13sat & p<=pc; % valid range for saturated liquid in region 4b
if any(any(valid4a))
    h(valid4a) = h2_pT(p(valid4a),Tsat(valid4a)); % [kJ/kg] saturated liquid enthalpies in region 2
end
if any(any(valid4b))
    h(valid4b) = h3_rhoT(1./vV_p(p(valid4b)),Tsat(valid4b));
end
end
function T = T_ph(p,h)
% T = T_ph(p,h)
%   Temperature of liquid, vapor or mixture, T [K], as functions of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 2, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
T = initnan;
%% constants and calculated scalars
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4 = (p>=pmin & p<=pB13sat & h>h1L & h<=h2V) | (p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V); % valid range for region 4
if any(any(valid1))
    T(valid1) = T1_ph(p(valid1),h(valid1));
end
if any(any(valid2a))
    T(valid2a) = T2a_ph(p(valid2a),h(valid2a));
end
if any(any(valid2b))
    T(valid2b) = T2b_ph(p(valid2b),h(valid2b));
end
if any(any(valid2c))
    T(valid2c) = T2c_ph(p(valid2c),h(valid2c));
end
if any(any(valid3a))
    T(valid3a) = T3a_ph(p(valid3a),h(valid3a));
end
if any(any(valid3b))
    T(valid3b) = T3b_ph(p(valid3b),h(valid3b));
end
if any(any(valid4))
    T(valid4) = Tsat(valid4);
end
end
function v = v_ph(p,h)
% v = v_ph(p,h)
%   Specific volume of liquid, vapor or mixture, v [m^3/kg], as functions of pressure, p [MPa], and enthalpy, h [kJ/kg]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 1, 2009
% Mark Mikofski
%% size of inputs
dim = size(p);
initnan = NaN(dim);
v = initnan;
%% constants and calculated scalars
Tmin = 273.16; % [K] minimum temperature is triple point
T2bcsat = 554.485; % [K] saturation temperature at 5.85 kJ/kg/K isentropic line between region 2b and 2c
TB13 = 623.15; % [K] temperature at boundary between region 1 and 3
Tmax = 1073.15; % [K] maximum temperature
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
p2ab = 4; % [MPa] pressure along boundary between region 2a and 2b
p2bcsat = psat_T(T2bcsat); % [MPa] saturation pressure at 5.85 kJ/kg/K isentropic line between region 2b and 2c
pB13sat = psat_T(TB13); % [MPa] saturation pressure at boundary between region 1 and 3, 16.5291643 MPa
pmax = 100; % [MPa] maximum pressure
h1B13L = h1_pT(pB13sat,TB13); % [kJ/kg] saturated liquid enthalpy at boundary between region 1, region 3 and region 4
h2B13V = h2_pT(pB13sat,TB13); % [kJ/kg] saturated vapor enthalpy at boundary between region 2, region 3 and region 4
%% calculated matrices
Tsat = Tsat_p(p); % [K] saturation temperatures
h1min = initnan;h2max = initnan;valid = p>=pmin & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    Tmin = Tmin*ones(dim);Tmax = Tmax*ones(dim); % copy to matrix of size dim
    h1min(valid) = h1_pT(pvalid,Tmin(valid)); % [kJ/kg] minimum enthalpies
    h2max(valid) = h2_pT(pvalid,Tmax(valid)); % [kJ/kg] maximum enthalpies in region 2
end
h1L = initnan;h2V = initnan;valid = p>=pmin & p<=pB13sat;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    h1L(valid) = h1_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated liquid enthalpies in region 1
    h2V(valid) = h2_pT(pvalid,Tsat(valid)); % [kJ/kg] saturated vapor enthalpies in region 2
end
h1B13 = initnan;h3ab = initnan;h2B23 = initnan;valid = p>=pB13sat & p<=pmax;pvalid = p(valid); % initialize matricies with NaN and set valid range of parameters
if any(any(valid))
    TB13 = TB13*ones(dim); % copy to matrix of size dim
    h1B13(valid) = h1_pT(pvalid,TB13(valid)); % [kJ/kg] enthalpies on boundary between region 1 and region 3
    h3ab(valid) = h3ab_p(pvalid); % [kJ/kg] enthalpies on critical entropy isentropic line between regions 3a and region 3b
    h2B23(valid) = h2_pT(pvalid,TB23_p(pvalid)); % [kJ/kg] enthalpies on boundary between region 2 and region 3
end
h2bc = initnan;valid = p>=p2bcsat & p<=pmax; % initialize matricies with NaN and set valid range of parameters
h2bc(valid) = h2bc_p(p(valid)); % [kJ/kg] enthalpies on boundary between region 2b and 2c
p3sat = pB13sat*ones(dim);valid = h>=h1B13L & h<=h2B13V; % % do NOT use NaN to initialize p3sat, b/c for h<h1B13L or h>h2B13V p>NaN = 0, instead use pB13sat
if any(any(valid))
    p3sat(valid) = p3sat_h(h(valid)); % [MPa] saturation pressure on boundary between region 3 and 4
end
%% valid ranges
valid1 = (p>=pmin & p<=pB13sat & h>=h1min & h<=h1L) | (p>pB13sat & p<=pmax & h>=h1min & h<=h1B13); % valid range for region 1
valid2a = p>=pmin & p<=p2ab & h>h2V & h<=h2max; % valid range for region 2a
valid2b = (p>p2ab & p<=p2bcsat & h>h2V & h<=h2max) | (p>p2bcsat & p<=pmax & h>h2bc & h<=h2max); % valid range for region 2b
valid2c = (p>p2bcsat & p<=pB13sat & h>h2V & h<=h2bc) | (p>pB13sat & p<=pmax & h>h2B23 & h<=h2bc); % valid range for region 2c
valid3a = p>p3sat & p<=pmax & h>h1B13 & h<=h3ab; % valid range for region 3a
valid3b = p>p3sat & p<=pmax & h>h3ab & h<=h2B23; % valid range for region 3b
valid4a = p>=pmin & p<=pB13sat & h>h1L & h<=h2V; % valid range for region 4a
valid4b = p>pB13sat & p<=p3sat & h>h1B13L & h<=h2B13V; % valid range for region 4b
if any(any(valid1))
    p1 = p(valid1);
    v(valid1) = v1_pT(p1,T1_ph(p1,h(valid1)));
end
if any(any(valid2a))
    p2a = p(valid2a);
    v(valid2a) = v2_pT(p2a,T2a_ph(p2a,h(valid2a)));
end
if any(any(valid2b))
    p2b = p(valid2b);
    v(valid2b) = v2_pT(p2b,T2b_ph(p2b,h(valid2b)));
end
if any(any(valid2c))
    p2c = p(valid2c);
    v(valid2c) = v2_pT(p2c,T2c_ph(p2c,h(valid2c)));
end
if any(any(valid3a))
    v(valid3a) = v3a_ph(p(valid3a),h(valid3a));
end
if any(any(valid3b))
    v(valid3b) = v3b_ph(p(valid3b),h(valid3b));
end
if any(any(valid4a))
    p4a = p(valid4a);Tsat4a = Tsat(valid4a);h1L4a = h1L(valid4a);
    x = (h(valid4a)-h1L4a)./(h2V(valid4a)-h1L4a); % quality
    v1L = v1_pT(p4a,Tsat4a); % [m^3/kg] saturated liquid specific volumes
    v2V = v2_pT(p4a,Tsat4a); % [m^3/kg] saturated vapor specific volumes
    v(valid4a) = v1L + x.*(v2V - v1L);
end
if any(any(valid4b))
    p4b = p(valid4b); Tsat4b = Tsat(valid4b);
    v3L = vL_p(p4b); v3V = vV_p(p4b);
    h3L = h3_rhoT(1./v3L,Tsat4b);
    h3V = h3_rhoT(1./v3V,Tsat4b);
    x = (h(valid4b)-h3L)./(h3V-h3L); % quality
    v(valid4b) = v3L + x.*(v3V - v3L);
end
end
function p = psat_T(T)
% p = psat_T(T)
%   Pressure of saturated liquid, mixture or steam, p [MPa], as a function of temperature, T [K]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 9, 2009
% Mark Mikofski
dim = size(T);
p = NaN(dim);
Tmin = 273.16; % [K] minimum temperature is triple point
Tc = 647.096; % [K] critical point temperature
valid = T>=Tmin & T<=Tc;
pstar = 1; % [Mpa]
Tstar = 1; % [K]
n = [1167.05214527670;-724213.167032060;-17.0738469400920;12020.8247024700;-3232555.03223330;14.9151086135300; ...
    -4823.26573615910;405113.405420570;-0.238555575678490;650.175348447980];
upsilon = T(valid)/Tstar + n(9)./(T(valid)/Tstar-n(10));
A = (upsilon + n(1)).*upsilon + n(2); % use Horner's Method to speed up calculations
B = (n(3)*upsilon + n(4)).*upsilon + n(5); % use Horner's Method to speed up calculations
C = (n(6)*upsilon + n(7)).*upsilon + n(8); % use Horner's Method to speed up calculations
beta = 2*C./(-B + (B.^2 - 4*A.*C).^0.5);
p(valid) = (beta.^4) * pstar;
end
function T = Tsat_p(p)
% T = Tsat_p(p)
%   Temperature of saturated liquid, mixture or steam, T [K], as a function of temperature, p [MPa]
% based on IAPWS-IF97
% Reference: http://www.iapws.org/
% June 9, 2009
% Mark Mikofski
dim = size(p);
T = NaN(dim);
Tmin = 273.16; % [K] minimum temperature is triple point
pmin = psat_T(Tmin); % [MPa] minimum pressure is 611.657 Pa
pc = 22.064; % [MPa] critical pressure
valid = p>=pmin & p<=pc; % initialize matricies with NaN and set valid range of parameters
pstar = 1; % [Mpa]
Tstar = 1; % [K]
n = [1167.05214527670;-724213.167032060;-17.0738469400920;12020.8247024700;-3232555.03223330;14.9151086135300; ...
    -4823.26573615910;405113.405420570;-0.238555575678490;650.175348447980];
beta = (p(valid)/pstar).^0.25;
E = (beta + n(3)).*beta + n(6); % use Horner's Method to speed up calculations
F = (n(1)*beta + n(4)).*beta + n(7); % use Horner's Method to speed up calculations
G = (n(2)*beta + n(5)).*beta + n(8); % use Horner's Method to speed up calculations
D = 2*G./(-F - (F.^2 - 4*E.*G).^0.5);
n11 = n(10) + D;
theta = (n11 - (n11.^2 - 4*(n(9) + n(10)*D)).^0.5)/2;
T(valid) = theta*Tstar;
end
%% basic and fundamental functions
function h = h1_pT(p,T) % [kJ/kg]
R = 0.461526; % [kJ/kg/K] specific gas constant
Tstar = 1386; % [K]
h = R*Tstar*dgammadtau1_pT(p,T);
end
function h = h2_pT(p,T) % [kJ/kg]
R = 0.461526; % [kJ/kg/K] specific gas constant
Tstar = 540; % [K]
h = R*Tstar*dgammadtau2_pT(p,T);
end
function h = h3_rhoT(rho,T)
R = 0.461526; % [kJ/kg/K] specific gas constant
Tc = 647.096; % [K] critical point temperature
rhoc = 322; % [kg/m^3] critical point density
delta = rho/rhoc;
h = R*(Tc*dphidtau3_rhoT(rho,T) + T.*delta.*dphiddelta3_rhoT(rho,T));
end
function v = v1_pT(p,T) % [m^3/kg]
R = 0.461526; % [kJ/kg/K] specific gas constant
conversion_factor = 1e-3; % [MPa/(kJ/m^3)]
pstar = 16.53; % [MPa]
v = conversion_factor*R*T/pstar.*dgammadpi1_pT(p,T);
end
function v = v2_pT(p,T) % [m^3/kg]
R = 0.461526; % [kJ/kg/K] specific gas constant
conversion_factor = 1e-3; % [MPa/(kJ/m^3)]
pstar = 1; % [MPa]
v = conversion_factor*R*T/pstar.*dgammadpi2_pT(p,T);
end
function cp = cp1_pT(p,T) % [kJ/kg/K]
R = 0.461526; % [kJ/kg/K] specific gas constant
Tstar = 1386; % [K]
tau = Tstar./T;
cp = -R*tau.^2.*dgammadtautau1_pT(p,T);
end
function cp = cp2_pT(p,T) % [kJ/kg/K]
R = 0.461526; % [kJ/kg/K] specific gas constant
Tstar = 540; % [K]
tau = Tstar./T;
cp = -R*tau.^2.*dgammadtautau2_pT(p,T);
end
function cp = cp3_rhoT(rho,T)
R = 0.461526; % [kJ/kg/K] specific gas constant
Tc = 647.096; % [K] critical point temperature
rhoc = 322; % [kg/m^3] critical point density
tau = Tc./T;
delta = rho/rhoc;
cp = R*(-tau.^2.*dphidtautau3_rhoT(rho,T) + (delta.*dphiddelta3_rhoT(rho,T) - delta.*tau.*dphiddeltatau3_rhoT(rho,T)).^2 ...
    ./(2*delta.*dphiddelta3_rhoT(rho,T) + delta.^2.*dphiddeltadelta3_rhoT(rho,T)));
end
function cv = cv3_rhoT(rho,T)
R = 0.461526; % [kJ/kg/K] specific gas constant
Tc = 647.096; % [K] critical point temperature
tau = Tc./T;
cv = R*(-tau.^2.*dphidtautau3_rhoT(rho,T));
end
function alphav = alphav1_pT(p,T)
Tstar = 1386; % [K]
tau = Tstar./T;
alphav = (1-tau.*dgammadpitau1_pT(p,T)./dgammadpi1_pT(p,T))./T;
end
function alphav = alphav2_pT(p,T)
Tstar = 540; % [K]
tau = Tstar./T;
alphav = (1-tau.*dgammadpitau2_pT(p,T)./dgammadpi2_pT(p,T))./T;
end
function alphap = alphap3_rhoT(rho,T)
Tc = 647.096; % [K] critical point temperature
tau = Tc./T;
alphap = (1-tau.*dphiddeltatau3_rhoT(rho,T)./dphiddelta3_rhoT(rho,T))./T;
end
function betap = betap3_rhoT(rho,T)
rhoc = 322; % [kg/m^3] critical point density
delta = rho/rhoc;
betap = rho.*(2+delta.*dphiddeltadelta3_rhoT(rho,T)./dphiddelta3_rhoT(rho,T));
end
function kappaT = kappaT1_pT(p,T)
pstar = 16.53; % [MPa]
kappaT = -dgammadpipi1_pT(p,T)./dgammadpi1_pT(p,T)/pstar;
end
function kappaT = kappaT2_pT(p,T)
pstar = 1; % [MPa]
kappaT = -dgammadpipi2_pT(p,T)./dgammadpi2_pT(p,T)/pstar;
end
function dgammadtau = dgammadtau1_pT(p,T)
dim = length(p);
pstar = 16.53; % [MPa]
Tstar = 1386; % [K]
pi = p/pstar;
tau = Tstar./T;
I = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,4,5,8,8,21,23,29,30,31,32];
J = [-2,-1,0,1,2,3,4,5,-9,-7,-1,0,1,3,-3,0,1,3,17,-4,0,6,-5,-2,10,-8,-11,-6,-29,-31,-38,-39,-40,-41];
n = [0.146329712131670,-0.845481871691140,-3.75636036720400,3.38551691683850,-0.957919633878720,0.157720385132280, ...
    -0.0166164171995010,0.000812146299835680,0.000283190801238040,-0.000607063015658740,-0.0189900682184190, ...
    -0.0325297487705050,-0.0218417171754140,-5.28383579699300e-05,-0.000471843210732670,-0.000300017807930260, ...
    4.76613939069870e-05,-4.41418453308460e-06,-7.26949962975940e-16,-3.16796448450540e-05,-2.82707979853120e-06, ...
    -8.52051281201030e-10,-2.24252819080000e-06,-6.51712228956010e-07,-1.43417299379240e-13,-4.05169968601170e-07, ...
    -1.27343017416410e-09,-1.74248712306340e-10,-6.87621312955310e-19,1.44783078285210e-20,2.63357816627950e-23, ...
    -1.19476226400710e-23,1.82280945814040e-24,-9.35370872924580e-26];
Nterms = 34;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dgammadtau = sum(n.*(7.1-pi).^I.*J.*(tau-1.222).^(J-1),2);
end
function dgammadpi = dgammadpi1_pT(p,T)
dim = length(p);
pstar = 16.53; % [MPa]
Tstar = 1386; % [K]
pi = p/pstar;
tau = Tstar./T;
I = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,4,5,8,8,21,23,29,30,31,32];
J = [-2,-1,0,1,2,3,4,5,-9,-7,-1,0,1,3,-3,0,1,3,17,-4,0,6,-5,-2,10,-8,-11,-6,-29,-31,-38,-39,-40,-41];
n = [0.146329712131670,-0.845481871691140,-3.75636036720400,3.38551691683850,-0.957919633878720,0.157720385132280, ...
    -0.0166164171995010,0.000812146299835680,0.000283190801238040,-0.000607063015658740,-0.0189900682184190, ...
    -0.0325297487705050,-0.0218417171754140,-5.28383579699300e-05,-0.000471843210732670,-0.000300017807930260, ...
    4.76613939069870e-05,-4.41418453308460e-06,-7.26949962975940e-16,-3.16796448450540e-05,-2.82707979853120e-06, ...
    -8.52051281201030e-10,-2.24252819080000e-06,-6.51712228956010e-07,-1.43417299379240e-13,-4.05169968601170e-07, ...
    -1.27343017416410e-09,-1.74248712306340e-10,-6.87621312955310e-19,1.44783078285210e-20,2.63357816627950e-23, ...
    -1.19476226400710e-23,1.82280945814040e-24,-9.35370872924580e-26];
Nterms = 34;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dgammadpi = sum(-n.*I.*(7.1-pi).^(I-1).*(tau-1.222).^J,2);
end
function dgammadtautau = dgammadtautau1_pT(p,T)
dim = length(p);
pstar = 16.53; % [MPa]
Tstar = 1386; % [K]
pi = p/pstar;
tau = Tstar./T;
I = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,4,5,8,8,21,23,29,30,31,32];
J = [-2,-1,0,1,2,3,4,5,-9,-7,-1,0,1,3,-3,0,1,3,17,-4,0,6,-5,-2,10,-8,-11,-6,-29,-31,-38,-39,-40,-41];
n = [0.146329712131670,-0.845481871691140,-3.75636036720400,3.38551691683850,-0.957919633878720,0.157720385132280, ...
    -0.0166164171995010,0.000812146299835680,0.000283190801238040,-0.000607063015658740,-0.0189900682184190, ...
    -0.0325297487705050,-0.0218417171754140,-5.28383579699300e-05,-0.000471843210732670,-0.000300017807930260, ...
    4.76613939069870e-05,-4.41418453308460e-06,-7.26949962975940e-16,-3.16796448450540e-05,-2.82707979853120e-06, ...
    -8.52051281201030e-10,-2.24252819080000e-06,-6.51712228956010e-07,-1.43417299379240e-13,-4.05169968601170e-07, ...
    -1.27343017416410e-09,-1.74248712306340e-10,-6.87621312955310e-19,1.44783078285210e-20,2.63357816627950e-23, ...
    -1.19476226400710e-23,1.82280945814040e-24,-9.35370872924580e-26];
Nterms = 34;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dgammadtautau = sum(n.*(7.1-pi).^I.*J.*(J-1).*(tau-1.222).^(J-2),2);
end
function dgammadpipi = dgammadpipi1_pT(p,T)
dim = length(p);
pstar = 16.53; % [MPa]
Tstar = 1386; % [K]
pi = p/pstar;
tau = Tstar./T;
I = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,4,5,8,8,21,23,29,30,31,32];
J = [-2,-1,0,1,2,3,4,5,-9,-7,-1,0,1,3,-3,0,1,3,17,-4,0,6,-5,-2,10,-8,-11,-6,-29,-31,-38,-39,-40,-41];
n = [0.146329712131670,-0.845481871691140,-3.75636036720400,3.38551691683850,-0.957919633878720,0.157720385132280, ...
    -0.0166164171995010,0.000812146299835680,0.000283190801238040,-0.000607063015658740,-0.0189900682184190, ...
    -0.0325297487705050,-0.0218417171754140,-5.28383579699300e-05,-0.000471843210732670,-0.000300017807930260, ...
    4.76613939069870e-05,-4.41418453308460e-06,-7.26949962975940e-16,-3.16796448450540e-05,-2.82707979853120e-06, ...
    -8.52051281201030e-10,-2.24252819080000e-06,-6.51712228956010e-07,-1.43417299379240e-13,-4.05169968601170e-07, ...
    -1.27343017416410e-09,-1.74248712306340e-10,-6.87621312955310e-19,1.44783078285210e-20,2.63357816627950e-23, ...
    -1.19476226400710e-23,1.82280945814040e-24,-9.35370872924580e-26];
Nterms = 34;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dgammadpipi = sum(n.*I.*(I-1).*(7.1-pi).^(I-2).*(tau-1.222).^J,2);
end
function dgammadpitau = dgammadpitau1_pT(p,T)
dim = length(p);
pstar = 16.53; % [MPa]
Tstar = 1386; % [K]
pi = p/pstar;
tau = Tstar./T;
I = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,4,4,4,5,8,8,21,23,29,30,31,32];
J = [-2,-1,0,1,2,3,4,5,-9,-7,-1,0,1,3,-3,0,1,3,17,-4,0,6,-5,-2,10,-8,-11,-6,-29,-31,-38,-39,-40,-41];
n = [0.146329712131670,-0.845481871691140,-3.75636036720400,3.38551691683850,-0.957919633878720,0.157720385132280, ...
    -0.0166164171995010,0.000812146299835680,0.000283190801238040,-0.000607063015658740,-0.0189900682184190, ...
    -0.0325297487705050,-0.0218417171754140,-5.28383579699300e-05,-0.000471843210732670,-0.000300017807930260, ...
    4.76613939069870e-05,-4.41418453308460e-06,-7.26949962975940e-16,-3.16796448450540e-05,-2.82707979853120e-06, ...
    -8.52051281201030e-10,-2.24252819080000e-06,-6.51712228956010e-07,-1.43417299379240e-13,-4.05169968601170e-07, ...
    -1.27343017416410e-09,-1.74248712306340e-10,-6.87621312955310e-19,1.44783078285210e-20,2.63357816627950e-23, ...
    -1.19476226400710e-23,1.82280945814040e-24,-9.35370872924580e-26];
Nterms = 34;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dgammadpitau = sum(-n.*I.*(7.1-pi).^(I-1).*J.*(tau-1.222).^(J-1),2);
end
function dgammadtau = dgammadtau2_pT(p,T)
dim = length(p);
pstar = 1; % [MPa] scaling pressure for nondimensional pressure, pi
Tstar = 540; % [K] scaling temperature for nondimensional temperature substitution variable
pi = p/pstar; % nondimensional pressure
tau = Tstar./T; % temperature substitution variable
%% ideal part
J0 = [0,1,-5,-4,-3,-2,-1,2,3]; % ideal part exponenets
n0 = [-9.69276865002170,10.0866559680180,-0.00560879112830200,0.0714527380814550,-0.407104982239280,1.42408191714440, ...
    -4.38395113194500,-0.284086324607720,0.0212684637533070];
N0terms = 9; % number of ideal terms in summation
J0 = ones(dim,1)*J0;
n0 = ones(dim,1)*n0;
tau0 = tau*ones(1,N0terms);
dgammadtau0 = sum(n0.*J0.*tau0.^(J0-1),2); % index sums of valid inputs into corresponding location in output array
%% residual part
IR = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,5,6,6,6,7,7,7,8,8,9,10,10,10,16,16,18,20,20,20,21,22,23,24,24,24];
JR = [0,1,2,3,6,1,2,4,7,36,0,1,3,6,35,1,2,3,7,3,16,35,0,11,25,8,36,13,4,10,14,29,50,57,20,35,48,21,53,39,26,40,58];
nR = [-0.00177317424732130,-0.0178348622923580,-0.0459960136963650,-0.0575812590834320,-0.0503252787279300, ...
    -3.30326416702030e-05,-0.000189489875163150,-0.00393927772433550,-0.0437972956505730,-2.66745479140870e-05, ...
    2.04817376923090e-08,4.38706672844350e-07,-3.22776772385700e-05,-0.00150339245421480,-0.0406682535626490, ...
    -7.88473095593670e-10,1.27907178522850e-08,4.82253727185070e-07,2.29220763376610e-06,-1.67147664510610e-11, ...
    -0.00211714723213550,-23.8957419341040,-5.90595643242700e-18,-1.26218088991010e-06,-0.0389468424357390, ...
    1.12562113604590e-11,-8.23113408979980,1.98097128020880e-08,1.04069652101740e-19,-1.02347470959290e-13, ...
    -1.00181793795110e-09,-8.08829086469850e-11,0.106930318794090,-0.336622505741710,8.91858453554210e-25, ...
    3.06293168762320e-13,-4.20024676982080e-06,-5.90560296856390e-26,3.78269476134570e-06,-1.27686089346810e-15, ...
    7.30876105950610e-29,5.54147153507780e-17,-9.43697072412100e-07];
NRterms = 43;
IR = ones(dim,1)*IR;
JR = ones(dim,1)*JR;
nR = ones(dim,1)*nR;
pi = pi*ones(1,NRterms);
tauR = tau*ones(1,NRterms);
dgammadtauR = sum(nR.*pi.^IR.*JR.*(tauR-0.5).^(JR-1),2);
dgammadtau = dgammadtau0 + dgammadtauR;
end
function dgammadpi = dgammadpi2_pT(p,T)
dim = length(p);
pstar = 1; % [MPa] scaling pressure for nondimensional pressure, pi
Tstar = 540; % [K] scaling temperature for nondimensional temperature substitution variable
pi = p/pstar; % nondimensional pressure
tau = Tstar./T; % temperature substitution variable
%% ideal part
dgammadpi0 = 1./pi;
%% residual part
IR = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,5,6,6,6,7,7,7,8,8,9,10,10,10,16,16,18,20,20,20,21,22,23,24,24,24];
JR = [0,1,2,3,6,1,2,4,7,36,0,1,3,6,35,1,2,3,7,3,16,35,0,11,25,8,36,13,4,10,14,29,50,57,20,35,48,21,53,39,26,40,58];
nR = [-0.00177317424732130,-0.0178348622923580,-0.0459960136963650,-0.0575812590834320,-0.0503252787279300, ...
    -3.30326416702030e-05,-0.000189489875163150,-0.00393927772433550,-0.0437972956505730,-2.66745479140870e-05, ...
    2.04817376923090e-08,4.38706672844350e-07,-3.22776772385700e-05,-0.00150339245421480,-0.0406682535626490, ...
    -7.88473095593670e-10,1.27907178522850e-08,4.82253727185070e-07,2.29220763376610e-06,-1.67147664510610e-11, ...
    -0.00211714723213550,-23.8957419341040,-5.90595643242700e-18,-1.26218088991010e-06,-0.0389468424357390, ...
    1.12562113604590e-11,-8.23113408979980,1.98097128020880e-08,1.04069652101740e-19,-1.02347470959290e-13, ...
    -1.00181793795110e-09,-8.08829086469850e-11,0.106930318794090,-0.336622505741710,8.91858453554210e-25, ...
    3.06293168762320e-13,-4.20024676982080e-06,-5.90560296856390e-26,3.78269476134570e-06,-1.27686089346810e-15, ...
    7.30876105950610e-29,5.54147153507780e-17,-9.43697072412100e-07];
NRterms = 43;
IR = ones(dim,1)*IR;
JR = ones(dim,1)*JR;
nR = ones(dim,1)*nR;
pi = pi*ones(1,NRterms);
tau = tau*ones(1,NRterms);
dgammadpiR = sum(nR.*IR.*pi.^(IR-1).*(tau-0.5).^JR,2);
dgammadpi = dgammadpi0 + dgammadpiR;
end
function dgammadtautau = dgammadtautau2_pT(p,T)
dim = length(p);
pstar = 1; % [MPa] scaling pressure for nondimensional pressure, pi
Tstar = 540; % [K] scaling temperature for nondimensional temperature substitution variable
pi = p/pstar; % nondimensional pressure
tau = Tstar./T; % temperature substitution variable
%% ideal part
J0 = [0,1,-5,-4,-3,-2,-1,2,3]; % ideal part exponenets
n0 = [-9.69276865002170,10.0866559680180,-0.00560879112830200,0.0714527380814550,-0.407104982239280,1.42408191714440, ...
    -4.38395113194500,-0.284086324607720,0.0212684637533070];
N0terms = 9; % number of ideal terms in summation
J0 = ones(dim,1)*J0;
n0 = ones(dim,1)*n0;
tau0 = tau*ones(1,N0terms);
dgammadtautau0 = sum(n0.*J0.*(J0-1).*tau0.^(J0-2),2); % summation terms
%% residual part
IR = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,5,6,6,6,7,7,7,8,8,9,10,10,10,16,16,18,20,20,20,21,22,23,24,24,24];
JR = [0,1,2,3,6,1,2,4,7,36,0,1,3,6,35,1,2,3,7,3,16,35,0,11,25,8,36,13,4,10,14,29,50,57,20,35,48,21,53,39,26,40,58];
nR = [-0.00177317424732130,-0.0178348622923580,-0.0459960136963650,-0.0575812590834320,-0.0503252787279300, ...
    -3.30326416702030e-05,-0.000189489875163150,-0.00393927772433550,-0.0437972956505730,-2.66745479140870e-05, ...
    2.04817376923090e-08,4.38706672844350e-07,-3.22776772385700e-05,-0.00150339245421480,-0.0406682535626490, ...
    -7.88473095593670e-10,1.27907178522850e-08,4.82253727185070e-07,2.29220763376610e-06,-1.67147664510610e-11, ...
    -0.00211714723213550,-23.8957419341040,-5.90595643242700e-18,-1.26218088991010e-06,-0.0389468424357390, ...
    1.12562113604590e-11,-8.23113408979980,1.98097128020880e-08,1.04069652101740e-19,-1.02347470959290e-13, ...
    -1.00181793795110e-09,-8.08829086469850e-11,0.106930318794090,-0.336622505741710,8.91858453554210e-25, ...
    3.06293168762320e-13,-4.20024676982080e-06,-5.90560296856390e-26,3.78269476134570e-06,-1.27686089346810e-15, ...
    7.30876105950610e-29,5.54147153507780e-17,-9.43697072412100e-07];
NRterms = 43;
IR = ones(dim,1)*IR;
JR = ones(dim,1)*JR;
nR = ones(dim,1)*nR;
pi = pi*ones(1,NRterms);
tauR = tau*ones(1,NRterms);
dgammadtautauR = sum(nR.*pi.^IR.*JR.*(JR-1).*(tauR-0.5).^(JR-2),2);
dgammadtautau = dgammadtautau0 + dgammadtautauR;
end
function dgammadpipi = dgammadpipi2_pT(p,T)
dim = length(p);
pstar = 1; % [MPa] scaling pressure for nondimensional pressure, pi
Tstar = 540; % [K] scaling temperature for nondimensional temperature substitution variable
pi = p/pstar; % nondimensional pressure
tau = Tstar./T; % temperature substitution variable
%% ideal part
dgammadpipi0 = -1./pi.^2;
%% residual part
IR = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,5,6,6,6,7,7,7,8,8,9,10,10,10,16,16,18,20,20,20,21,22,23,24,24,24];
JR = [0,1,2,3,6,1,2,4,7,36,0,1,3,6,35,1,2,3,7,3,16,35,0,11,25,8,36,13,4,10,14,29,50,57,20,35,48,21,53,39,26,40,58];
nR = [-0.00177317424732130,-0.0178348622923580,-0.0459960136963650,-0.0575812590834320,-0.0503252787279300, ...
    -3.30326416702030e-05,-0.000189489875163150,-0.00393927772433550,-0.0437972956505730,-2.66745479140870e-05, ...
    2.04817376923090e-08,4.38706672844350e-07,-3.22776772385700e-05,-0.00150339245421480,-0.0406682535626490, ...
    -7.88473095593670e-10,1.27907178522850e-08,4.82253727185070e-07,2.29220763376610e-06,-1.67147664510610e-11, ...
    -0.00211714723213550,-23.8957419341040,-5.90595643242700e-18,-1.26218088991010e-06,-0.0389468424357390, ...
    1.12562113604590e-11,-8.23113408979980,1.98097128020880e-08,1.04069652101740e-19,-1.02347470959290e-13, ...
    -1.00181793795110e-09,-8.08829086469850e-11,0.106930318794090,-0.336622505741710,8.91858453554210e-25, ...
    3.06293168762320e-13,-4.20024676982080e-06,-5.90560296856390e-26,3.78269476134570e-06,-1.27686089346810e-15, ...
    7.30876105950610e-29,5.54147153507780e-17,-9.43697072412100e-07];
NRterms = 43;
IR = ones(dim,1)*IR;
JR = ones(dim,1)*JR;
nR = ones(dim,1)*nR;
pi = pi*ones(1,NRterms);
tau = tau*ones(1,NRterms);
dgammadpipiR = sum(nR.*IR.*(IR-1).*pi.^(IR-2).*(tau-0.5).^JR,2);
dgammadpipi = dgammadpipi0 + dgammadpipiR;
end
function dgammadpitau = dgammadpitau2_pT(p,T)
dim = length(p);
pstar = 1; % [MPa] scaling pressure for nondimensional pressure, pi
Tstar = 540; % [K] scaling temperature for nondimensional temperature substitution variable
pi = p/pstar; % nondimensional pressure
tau = Tstar./T; % temperature substitution variable
%% ideal part
dgammadpitau0 = 0;
%% residual part
IR = [1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,5,6,6,6,7,7,7,8,8,9,10,10,10,16,16,18,20,20,20,21,22,23,24,24,24];
JR = [0,1,2,3,6,1,2,4,7,36,0,1,3,6,35,1,2,3,7,3,16,35,0,11,25,8,36,13,4,10,14,29,50,57,20,35,48,21,53,39,26,40,58];
nR = [-0.00177317424732130,-0.0178348622923580,-0.0459960136963650,-0.0575812590834320,-0.0503252787279300, ...
    -3.30326416702030e-05,-0.000189489875163150,-0.00393927772433550,-0.0437972956505730,-2.66745479140870e-05, ...
    2.04817376923090e-08,4.38706672844350e-07,-3.22776772385700e-05,-0.00150339245421480,-0.0406682535626490, ...
    -7.88473095593670e-10,1.27907178522850e-08,4.82253727185070e-07,2.29220763376610e-06,-1.67147664510610e-11, ...
    -0.00211714723213550,-23.8957419341040,-5.90595643242700e-18,-1.26218088991010e-06,-0.0389468424357390, ...
    1.12562113604590e-11,-8.23113408979980,1.98097128020880e-08,1.04069652101740e-19,-1.02347470959290e-13, ...
    -1.00181793795110e-09,-8.08829086469850e-11,0.106930318794090,-0.336622505741710,8.91858453554210e-25, ...
    3.06293168762320e-13,-4.20024676982080e-06,-5.90560296856390e-26,3.78269476134570e-06,-1.27686089346810e-15, ...
    7.30876105950610e-29,5.54147153507780e-17,-9.43697072412100e-07];
NRterms = 43;
IR = ones(dim,1)*IR;
JR = ones(dim,1)*JR;
nR = ones(dim,1)*nR;
pi = pi*ones(1,NRterms);
tau = tau*ones(1,NRterms);
dgammadpitauR = sum(nR.*IR.*pi.^(IR-1).*JR.*(tau-0.5).^(JR-1),2);
dgammadpitau = dgammadpitau0 + dgammadpitauR;
end
function dphidtau = dphidtau3_rhoT(rho,T)
dim = length(T);
Tc = 647.096; % [K] critical point temperature
rhoc = 322; % [kg/m^3] critical point density
tau = Tc./T;
delta = rho/rhoc;
I = [0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5,5,6,6,6,7,8,9,9,10,10,11];
J = [0,1,2,7,10,12,23,2,6,15,17,0,2,6,7,22,26,0,2,4,16,26,0,2,4,26,1,3,26,0,2,26,2,26,2,26,0,1,26];
n = [-15.7328452902390,20.9443969743070,-7.68677078787160,2.61859477879540,-2.80807811486200,1.20533696965170, ...
    -0.00845668128125020,-1.26543154777140,-1.15244078066810,0.885210439843180,-0.642077651816070,0.384934601866710, ...
    -0.852147088242060,4.89722815418770,-3.05026172569650,0.0394205368791540,0.125584084243080,-0.279993296987100, ...
    1.38997995694600,-2.01899150235700,-0.00821476371739630,-0.475960357349230,0.0439840744735000,-0.444764354287390, ...
    0.905720707197330,0.705224500879670,0.107705126263320,-0.329136232589540,-0.508710620411580,-0.0221754008730960, ...
    0.0942607516650920,0.164362784479610,-0.0135033722413480,-0.0148343453524720,0.000579229536280840, ...
    0.00323089047037110,8.09648029962150e-05,-0.000165576797950370,-4.49238990618150e-05];
Nterms = 39;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
delta = delta*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dphidtau = sum(n.*delta.^I.*J.*tau.^(J-1),2);
end
function dphiddelta = dphiddelta3_rhoT(rho,T)
dim = length(T);
Tc = 647.096; % [K] critical point temperature
rhoc = 322; % [kg/m^3] critical point density
tau = Tc./T;
delta = rho/rhoc;
I = [0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5,5,6,6,6,7,8,9,9,10,10,11];
J = [0,1,2,7,10,12,23,2,6,15,17,0,2,6,7,22,26,0,2,4,16,26,0,2,4,26,1,3,26,0,2,26,2,26,2,26,0,1,26];
n = [-15.7328452902390,20.9443969743070,-7.68677078787160,2.61859477879540,-2.80807811486200,1.20533696965170, ...
    -0.00845668128125020,-1.26543154777140,-1.15244078066810,0.885210439843180,-0.642077651816070,0.384934601866710, ...
    -0.852147088242060,4.89722815418770,-3.05026172569650,0.0394205368791540,0.125584084243080,-0.279993296987100, ...
    1.38997995694600,-2.01899150235700,-0.00821476371739630,-0.475960357349230,0.0439840744735000,-0.444764354287390, ...
    0.905720707197330,0.705224500879670,0.107705126263320,-0.329136232589540,-0.508710620411580,-0.0221754008730960, ...
    0.0942607516650920,0.164362784479610,-0.0135033722413480,-0.0148343453524720,0.000579229536280840, ...
    0.00323089047037110,8.09648029962150e-05,-0.000165576797950370,-4.49238990618150e-05];
Nterms = 39;
n0 = 1.065807002851300; % prexponential constant
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
deltaND = delta*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dphiddelta = n0./delta + sum(n.*I.*deltaND.^(I-1).*tau.^J,2);
end
function dphidtautau = dphidtautau3_rhoT(rho,T)
dim = length(T);
Tc = 647.096; % [K] critical point temperature
rhoc = 322; % [kg/m^3] critical point density
tau = Tc./T;
delta = rho/rhoc;
I = [0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5,5,6,6,6,7,8,9,9,10,10,11];
J = [0,1,2,7,10,12,23,2,6,15,17,0,2,6,7,22,26,0,2,4,16,26,0,2,4,26,1,3,26,0,2,26,2,26,2,26,0,1,26];
n = [-15.7328452902390,20.9443969743070,-7.68677078787160,2.61859477879540,-2.80807811486200,1.20533696965170, ...
    -0.00845668128125020,-1.26543154777140,-1.15244078066810,0.885210439843180,-0.642077651816070,0.384934601866710, ...
    -0.852147088242060,4.89722815418770,-3.05026172569650,0.0394205368791540,0.125584084243080,-0.279993296987100, ...
    1.38997995694600,-2.01899150235700,-0.00821476371739630,-0.475960357349230,0.0439840744735000,-0.444764354287390, ...
    0.905720707197330,0.705224500879670,0.107705126263320,-0.329136232589540,-0.508710620411580,-0.0221754008730960, ...
    0.0942607516650920,0.164362784479610,-0.0135033722413480,-0.0148343453524720,0.000579229536280840, ...
    0.00323089047037110,8.09648029962150e-05,-0.000165576797950370,-4.49238990618150e-05];
Nterms = 39;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
delta = delta*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dphidtautau = sum(n.*delta.^I.*J.*(J-1).*tau.^(J-2),2);
end
function dphiddeltatau = dphiddeltatau3_rhoT(rho,T)
dim = length(T);
Tc = 647.096; % [K] critical point temperature
rhoc = 322; % [kg/m^3] critical point density
tau = Tc./T;
delta = rho/rhoc;
I = [0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5,5,6,6,6,7,8,9,9,10,10,11];
J = [0,1,2,7,10,12,23,2,6,15,17,0,2,6,7,22,26,0,2,4,16,26,0,2,4,26,1,3,26,0,2,26,2,26,2,26,0,1,26];
n = [-15.7328452902390,20.9443969743070,-7.68677078787160,2.61859477879540,-2.80807811486200,1.20533696965170, ...
    -0.00845668128125020,-1.26543154777140,-1.15244078066810,0.885210439843180,-0.642077651816070,0.384934601866710, ...
    -0.852147088242060,4.89722815418770,-3.05026172569650,0.0394205368791540,0.125584084243080,-0.279993296987100, ...
    1.38997995694600,-2.01899150235700,-0.00821476371739630,-0.475960357349230,0.0439840744735000,-0.444764354287390, ...
    0.905720707197330,0.705224500879670,0.107705126263320,-0.329136232589540,-0.508710620411580,-0.0221754008730960, ...
    0.0942607516650920,0.164362784479610,-0.0135033722413480,-0.0148343453524720,0.000579229536280840, ...
    0.00323089047037110,8.09648029962150e-05,-0.000165576797950370,-4.49238990618150e-05];
Nterms = 39;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
delta = delta*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dphiddeltatau = sum(n.*I.*delta.^(I-1).*J.*tau.^(J-1),2);
end
function dphiddeltadelta = dphiddeltadelta3_rhoT(rho,T)
dim = length(T);
Tc = 647.096; % [K] critical point temperature
rhoc = 322; % [kg/m^3] critical point density
tau = Tc./T;
delta = rho/rhoc;
I = [0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5,5,6,6,6,7,8,9,9,10,10,11];
J = [0,1,2,7,10,12,23,2,6,15,17,0,2,6,7,22,26,0,2,4,16,26,0,2,4,26,1,3,26,0,2,26,2,26,2,26,0,1,26];
n = [-15.7328452902390,20.9443969743070,-7.68677078787160,2.61859477879540,-2.80807811486200,1.20533696965170, ...
    -0.00845668128125020,-1.26543154777140,-1.15244078066810,0.885210439843180,-0.642077651816070,0.384934601866710, ...
    -0.852147088242060,4.89722815418770,-3.05026172569650,0.0394205368791540,0.125584084243080,-0.279993296987100, ...
    1.38997995694600,-2.01899150235700,-0.00821476371739630,-0.475960357349230,0.0439840744735000,-0.444764354287390, ...
    0.905720707197330,0.705224500879670,0.107705126263320,-0.329136232589540,-0.508710620411580,-0.0221754008730960, ...
    0.0942607516650920,0.164362784479610,-0.0135033722413480,-0.0148343453524720,0.000579229536280840, ...
    0.00323089047037110,8.09648029962150e-05,-0.000165576797950370,-4.49238990618150e-05];
Nterms = 39;
n0 = 1.065807002851300; % prexponential constant
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
deltaND = delta*ones(1,Nterms);
tau = tau*ones(1,Nterms);
dphiddeltadelta = -n0./delta.^2 + sum(n.*I.*(I-1).*deltaND.^(I-2).*tau.^J,2);
end
function dTsatdpsat = dTsatdpsat_p(p)
pstar = 1; % [Mpa]
Tstar = 1; % [K]
n = [1167.05214527670;-724213.167032060;-17.0738469400920;12020.8247024700;-3232555.03223330;14.9151086135300; ...
    -4823.26573615910;405113.405420570;-0.238555575678490;650.175348447980];
beta = (p/pstar).^0.25;
E = beta.^2 + n(3)*beta + n(6);
F = n(1)*beta.^2 + n(4)*beta + n(7);
G = n(2)*beta.^2 + n(5)*beta + n(8);
D = 2*G./(-F - (F.^2 - 4*E.*G).^0.5);
dbetadp = 1./(4*pstar*beta.^3);
n11 = 4*E.*G;
discriminant = (F.^2 - n11).^0.5;
n12 = F+discriminant;
n13 = n12.^2;
dDdE = -4*G.^2./(discriminant.*n13);
dEdbeta = 2*beta + n(3);
dDdF = 2*G.*(F./discriminant + 1)./n13;
dFdbeta = 2*n(1)*beta + n(4);
dDdG = -2./n12 - n11./(discriminant.*n13);
dGdbeta = 2*n(2)*beta + n(5);
n14 = D - n(10);
ddthetadD = (1 - n14./((n14.^2 - 4*n(9)).^0.5))/2;
dTsatdpsat = Tstar*ddthetadD.*(dDdE.*dEdbeta + dDdF.*dFdbeta + dDdG.*dGdbeta).*dbetadp;
end
%% backward and boundary functions
function T = T1_ph(p,h) % [K]
dim = length(p);
pstar = 1; % [MPa]
Tstar = 1; % [K]
hstar = 2500; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
I = [0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,3,3,4,5,6];
J = [0,1,2,6,22,32,0,1,2,3,4,10,32,10,32,10,32,32,32,32];
n = [-238.724899245210,404.211886379450,113.497468817180,-5.84576160480390,-0.000152854824131400,-1.08667076953770e-06, ...
    -13.3917448726020,43.2110391835590,-54.0100671705060,30.5358922039160,-6.59647494236380,0.00939654008783630, ...
    1.15736475053400e-07,-2.58586412820730e-05,-4.06443630847990e-09,6.64561861916350e-08,8.06707341030270e-11, ...
    -9.34777712139470e-13,5.82654420206010e-15,-1.50201859535030e-17];
Nterms = 20;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
eta = eta*ones(1,Nterms);
theta = sum(n.*pi.^I.*(eta+1).^J,2);
T = Tstar*theta;
end
function T = T2a_ph(p,h) % [K]
dim = length(p);
pstar = 1; % [MPa]
Tstar = 1; % [K]
hstar = 2000; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
Ia = [0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,4,4,4,5,5,5,6,6,7];
Ja = [0,1,2,3,7,20,0,1,2,3,7,9,11,18,44,0,2,7,36,38,40,42,44,24,44,12,32,44,32,36,42,34,44,28];
na = [1089.89523182880,849.516544955350,-107.817480918260,33.1536548012630,-7.42320167902480,11.7650487243560, ...
    1.84457493557900,-4.17927005496240,6.24781969358120,-17.3445631081140,-200.581768620960,271.960654737960, ...
    -455.113182858180,3091.96886047550,252266.403578720,-0.00617074228683390,-0.310780466295830,11.6708730771070, ...
    128127984.040460,-985549096.232760,2822454697.30020,-3594897141.07030,1722734991.31970,-13551.3342407750, ...
    12848734.6646500,1.38657242832260,235988.325565140,-13105236.5450540,7399.98354747660,-551966.970300600, ...
    3715408.59962330,19127.7292396600,-415351.648356340,-62.4598551925070];
Naterms = 34;
Ia = ones(dim,1)*Ia;
Ja = ones(dim,1)*Ja;
na = ones(dim,1)*na;
pi = pi*ones(1,Naterms);
eta = eta*ones(1,Naterms);
theta = sum(na.*pi.^Ia.*(eta-2.1).^Ja,2);
T = Tstar*theta;
end
function T = T2b_ph(p,h) % [K]
dim = length(p);
pstar = 1; % [MPa]
Tstar = 1; % [K]
hstar = 2000; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
Ib = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,4,5,5,5,6,7,7,9,9];
Jb = [0,1,2,12,18,24,28,40,0,2,6,12,18,24,28,40,2,8,18,40,1,2,12,24,2,12,18,24,28,40,18,24,40,28,2,28,1,40];
nb = [1489.50410795160,743.077983140340,-97.7083187978370,2.47424647056740,-0.632813200160260,1.13859521296580, ...
    -0.478118636486250,0.00852081234315440,0.937471473779320,3.35931186049160,3.38093556014540,0.168445396719040, ...
    0.738757452366950,-0.471287374361860,0.150202731397070,-0.00217641142197500,-0.0218107553247610,-0.108297844036770, ...
    -0.0463333246358120,7.12803519595510e-05,0.000110328317899990,0.000189552483879020,0.00308915411605370, ...
    0.00135555045549490,2.86402374774560e-07,-1.07798573575120e-05,-7.64627124548140e-05,1.40523928183160e-05, ...
    -3.10838143314340e-05,-1.03027382121030e-06,2.82172816350400e-07,1.27049022719450e-06,7.38033534682920e-08, ...
    -1.10301392389090e-08,-8.14563652078330e-14,-2.51805456829620e-11,-1.75652339694070e-18,8.69341563441630e-15];
Nbterms = 38;
Ib = ones(dim,1)*Ib;
Jb = ones(dim,1)*Jb;
nb = ones(dim,1)*nb;
pi = pi*ones(1,Nbterms);
eta = eta*ones(1,Nbterms);
theta = sum(nb.*(pi-2).^Ib.*(eta-2.6).^Jb,2);
T = Tstar*theta;
end
function T = T2c_ph(p,h) % [K]
dim = length(p);
pstar = 1; % [MPa]
Tstar = 1; % [K]
hstar = 2000; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
Ic = [-7,-7,-6,-6,-5,-5,-2,-2,-1,-1,0,0,1,1,2,6,6,6,6,6,6,6,6];
Jc = [0,4,0,2,0,2,0,1,0,2,0,1,4,8,4,0,1,4,10,12,16,20,22];
nc = [-3236839855524.20,7326335090218.10,358250899454.470,-583401318515.900,-10783068217.4700,20825544563.1710, ...
    610747.835645160,859777.225355800,-25745.7236041700,31081.0884227140,1208.23158659360,482.197551092550, ...
    3.79660012724860,-10.8429848800770,-0.0453641726766600,1.45591156586980e-13,1.12615974072300e-12,-1.78049822406860e-11, ...
    1.23245796908320e-07,-1.16069211309840e-06,2.78463670885540e-05,-0.000592700384741760,0.00129185829918780];
Ncterms = 23;
Ic = ones(dim,1)*Ic;
Jc = ones(dim,1)*Jc;
nc = ones(dim,1)*nc;
pi = pi*ones(1,Ncterms);
eta = eta*ones(1,Ncterms);
theta = sum(nc.*(pi+25).^Ic.*(eta-1.8).^Jc,2);
T = Tstar*theta;
end
function T = T3a_ph(p,h) % [K]
dim = length(p);
pstar = 100; % [MPa]
Tstar = 760; % [K]
hstar = 2300; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
I = [-12,-12,-12,-12,-12,-12,-12,-12,-10,-10,-10,-8,-8,-8,-8,-5,-3,-2,-2,-2,-1,-1,0,0,1,3,3,4,4,10,12];
J = [0,1,2,6,14,16,20,22,1,5,12,0,2,4,10,2,0,1,3,4,0,2,0,1,1,0,1,0,3,4,5];
n = [-1.33645667811215e-07,4.55912656802978e-06,-1.46294640700979e-05,0.00639341312970080,372.783927268847, ...
    -7186.54377460447,573494.752103400,-2675693.29111439,-3.34066283302614e-05,-0.0245479214069597,47.8087847764996, ...
    7.64664131818904e-06,0.00128350627676972,0.0171219081377331,-8.51007304583213,-0.0136513461629781, ...
    -3.84460997596657e-06,0.00337423807911655,-0.551624873066791,0.729202277107470,-0.00992522757376041, ...
    -0.119308831407288,0.793929190615421,0.454270731799386,0.209998591259910,-0.00642109823904738,-0.0235155868604540, ...
    0.00252233108341612,-0.00764885133368119,0.0136176427574291,-0.0133027883575669];
Nterms = 31;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
eta = eta*ones(1,Nterms);
theta = sum(n.*(pi+0.240).^I.*(eta-0.615).^J,2);
T = Tstar*theta;
end
function T = T3b_ph(p,h) % [K]
dim = length(p);
pstar = 100; % [MPa]
Tstar = 860; % [K]
hstar = 2800; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
I = [-12,-12,-10,-10,-10,-10,-10,-8,-8,-8,-8,-8,-6,-6,-6,-4,-4,-3,-2,-2,-1,-1,-1,-1,-1,-1,0,0,1,3,5,6,8];
J = [0,1,0,1,5,10,12,0,1,2,4,10,0,1,2,0,1,5,0,4,2,4,6,10,14,16,0,2,1,1,1,1,1];
n = [3.23254573644920e-05,-0.000127575556587181,-0.000475851877356068,0.00156183014181602,0.105724860113781, ...
    -85.8514221132534,724.140095480911,0.00296475810273257,-0.00592721983365988,-0.0126305422818666,-0.115716196364853, ...
    84.9000969739595,-0.0108602260086615,0.0154304475328851,0.0750455441524466,0.0252520973612982,-0.0602507901232996, ...
    -3.07622221350501,-0.0574011959864879,5.03471360939849,-0.925081888584834,3.91733882917546,-77.3146007130190, ...
    9493.08762098587,-1410437.19679409,8491662.30819026,0.861095729446704,0.323346442811720,0.873281936020439, ...
    -0.436653048526683,0.286596714529479,-0.131778331276228,0.00676682064330275];
Nterms = 33;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
eta = eta*ones(1,Nterms);
theta = sum(n.*(pi+0.298).^I.*(eta-0.720).^J,2);
T = Tstar*theta;
end
function v = v3a_ph(p,h) % [m^3/kg]
dim = length(p);
vstar = 0.0028; % [m^3/kg]
pstar = 100; % [MPa]
hstar = 2100; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
I = [-12,-12,-12,-12,-10,-10,-10,-8,-8,-6,-6,-6,-4,-4,-3,-2,-2,-1,-1,-1,-1,0,0,1,1,1,2,2,3,4,5,8];
J = [6,8,12,18,4,7,10,5,12,3,4,22,2,3,7,3,16,0,1,2,3,0,1,0,1,2,0,2,0,2,2,2];
n = [0.00529944062966028,-0.170099690234461,11.1323814312927,-2178.98123145125,-0.000506061827980875,0.556495239685324, ...
    -9.43672726094016,-0.297856807561527,93.9353943717186,0.0192944939465981,0.421740664704763,-3689141.26282330, ...
    -0.00737566847600639,-0.354753242424366,-1.99768169338727,1.15456297059049,5683.66875815960,0.00808169540124668, ...
    0.172416341519307,1.04270175292927,-0.297691372792847,0.560394465163593,0.275234661176914,-0.148347894866012, ...
    -0.0651142513478515,-2.92468715386302,0.0664876096952665,3.52335014263844,-0.0146340792313332,-2.24503486668184, ...
    1.10533464706142,-0.0408757344495612];
Nterms = 32;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
eta = eta*ones(1,Nterms);
omega = sum(n.*(pi+0.128).^I.*(eta-0.727).^J,2);
v = vstar*omega;
end
function v = v3b_ph(p,h) % [m^3/kg]
dim = length(p);
vstar = 0.0088; % [m^3/kg]
pstar = 100; % [MPa]
hstar = 2800; % [kJ/kg]
pi = p/pstar;
eta = h/hstar;
I = [-12,-12,-8,-8,-8,-8,-8,-8,-6,-6,-6,-6,-6,-6,-4,-4,-4,-3,-3,-2,-2,-1,-1,-1,-1,0,1,1,2,2];
J = [0,1,0,1,3,6,7,8,0,1,2,5,6,10,3,6,10,0,2,1,2,0,1,4,5,0,0,1,2,6];
n = [-2.25196934336318e-09,1.40674363313486e-08,2.33784085280560e-06,-3.31833715229001e-05,0.00107956778514318, ...
    -0.271382067378863,1.07202262490333,-0.853821329075382,-2.15214194340526e-05,0.000769656088222730, ...
    -0.00431136580433864,0.453342167309331,-0.507749535873652,-100.475154528389,-0.219201924648793,-3.21087965668917, ...
    607.567815637771,0.000557686450685932,0.187499040029550,0.00905368030448107,0.285417173048685,0.0329924030996098, ...
    0.239897419685483,4.82754995951394,-11.8035753702231,0.169490044091791,-0.0179967222507787,0.0371810116332674, ...
    -0.0536288335065096,1.60697101092520];
Nterms = 30;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
pi = pi*ones(1,Nterms);
eta = eta*ones(1,Nterms);
omega = sum(n.*(pi+0.0661).^I.*(eta-0.720).^J,2);
v = vstar*omega;
end
function h = h2bc_p(p)
pstar = 1; % [MPa]
hstar = 1; % [kJ/kg]
pi = p/pstar;
n = [0.90584278514723e3;-0.67955786399241;0.12809002730136e-3;0.26526571908428e4;0.45257578905948e1];
eta = n(4) + ((pi-n(5))/n(3)).^0.5;
h = eta*hstar;
end
function h = h3ab_p(p)
pstar = 1; % [MPa]
hstar = 1; % [kJ/kg]
pi = p/pstar;
n = [0.201464004206875e4;0.374696550136983e1;-0.219921901054187e-1;0.875131686009950e-4];
eta = n(1) + pi.*(n(2) + pi.*(n(3) + pi*n(4))); % use Horner's Method to speed up calculations
h = eta*hstar;
end
function T = TB23_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [0.34805185628969e3; -0.11671859879975e1; 0.10192970039326e-2; 0.57254459862746e3; 0.13918839778870e2];
theta = n(4) + ((pi-n(5))/n(3)).^0.5;
T = theta*Tstar;
end
function p = pB23_T(T)
pstar = 1; % [MPa]
Tstar = 1; % [K]
theta = T/Tstar;
n = [0.34805185628969e3; -0.11671859879975e1; 0.10192970039326e-2; 0.57254459862746e3; 0.13918839778870e2];
pi = n(1) + theta.*(n(2) + theta*n(3)); % use Horner's Method to speed up calculations
p = pi*pstar;
end
function p = p3sat_h(h)
dim = length(h);
pstar = 22; % [MPa]
hstar = 2600; % [kJ/kg]
eta = h/hstar;
I = [0,1,1,1,1,5,7,8,14,20,22,24,28,36];
J = [0,1,3,4,36,3,0,24,16,16,3,18,8,24];
n = [0.600073641753024,-9.36203654849857,24.6590798594147,-107.014222858224,-91582131580576.8,-8623.32011700662, ...
    -23.5837344740032,2.52304969384128e+17,-3.89718771997719e+18,-3.33775713645296e+22,35649946963.6328, ...
    -1.48547544720641e+26,3.30611514838798e+18,8.13641294467829e+37];
Nterms = 14;
I = ones(dim,1)*I;
J = ones(dim,1)*J;
n = ones(dim,1)*n;
eta = eta*ones(1,Nterms);
pi = sum(n.*(eta-1.02).^I.*(eta-0.608).^J,2);
p = pstar*pi;
end
function v = v3a_pT(p,T)
dim = length(p);
Table4 = [0.00240000000000000,100,760,30,0.0850000000000000,0.817000000000000,1,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3);Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_1 = [-12,5,0.00110879558823853;-12,10,572.616740810616;-12,12,-76705.1948380852;-10,5,-0.0253321069529674; ...
    -10,10,6280.08049345689;-10,12,234105.654131876;-8,5,0.216867826045856;-8,8,-156.237904341963; ...
    -8,10,-26989.3956176612;-6,1,-0.000180407100085505;-5,1,0.00116732227668261;-5,5,26.6987040856040; ...
    -5,10,28277.6617243286;-4,8,-2424.31520029523;-3,0,0.000435217323022733;-3,1,-0.0122494831387441; ...
    -3,3,1.79357604019989;-3,6,44.2729521058314;-2,0,-0.00593223489018342;-2,2,0.453186261685774;-2,3,1.35825703129140; ...
    -1,0,0.0408748415856745;-1,1,0.474686397863312;-1,2,1.18646814997915;0,0,0.546987265727549;0,1,0.195266770452643; ...
    1,0,-0.0502268790869663;1,2,-0.369645308193377;2,0,0.00633828037528420;2,2,0.0797441793901017];
I = ones(dim,1)*TableA1_1(:,1)'; J = ones(dim,1)*TableA1_1(:,2)'; n = ones(dim,1)*TableA1_1(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3b_pT(p,T)
dim = length(p);
Table4 = [0.00410000000000000,100,860,32,0.280000000000000,0.779000000000000,1,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3);Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_2 = [-12,10,-0.0827670470003621;-12,12,41.6887126010565;-10,8,0.0483651982197059;-10,14,-29103.2084950276; ...
    -8,8,-111.422582236948;-6,5,-0.0202300083904014;-6,6,294.002509338515;-6,8,140.244997609658;-5,5,-344.384158811459; ...
    -5,8,361.182452612149;-5,10,-1406.99677420738;-4,2,-0.00202023902676481;-4,4,171.346792457471; ...
    -4,5,-4.25597804058632;-3,0,6.91346085000334e-06;-3,1,0.00151140509678925;-3,2,-0.0416375290166236; ...
    -3,3,-41.3754957011042;-3,5,-50.6673295721637;-2,0,-0.000572212965569023;-2,2,6.08817368401785; ...
    -2,5,23.9600660256161;-1,0,0.0122261479925384;-1,2,2.16356057692938;0,0,0.398198903368642;0,1,-0.116892827834085; ...
    1,0,-0.102845919373532;1,2,-0.492676637589284;2,0,0.0655540456406790;3,2,-0.240462535078530;4,0,-0.0269798180310075; ...
    4,1,0.128369435967012];
I = ones(dim,1)*TableA1_2(:,1)'; J = ones(dim,1)*TableA1_2(:,2)'; n = ones(dim,1)*TableA1_2(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3c_pT(p,T)
dim = length(p);
Table4 = [0.00220000000000000,40,690,35,0.259000000000000,0.903000000000000,1,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_3 = [-12,6,3.11967788763030;-12,8,27671.3458847564;-12,10,32258310.3403269;-10,6,-342.416065095363; ...
    -10,8,-899732.529907377;-10,10,-79389204.9821251;-8,5,95.3193003217388;-8,6,2297.84742345072;-8,7,175336.675322499; ...
    -6,8,7912143.65222792;-5,1,3.19933345844209e-05;-5,4,-65.9508863555767;-5,7,-833426.563212851; ...
    -4,2,0.0645734680583292;-4,8,-3820310.20570813;-3,0,4.06398848470079e-05;-3,3,31.0327498492008; ...
    -2,0,-0.000892996718483724;-2,4,234.604891591616;-2,5,3775.15668966951;-1,0,0.0158646812591361; ...
    -1,1,0.707906336241843;-1,2,12.6016225146570;0,0,0.736143655772152;0,1,0.676544268999101;0,2,-17.8100588189137; ...
    1,0,-0.156531975531713;1,2,11.7707430048158;2,0,0.0840143653860447;2,1,-0.186442467471949;2,3,-44.0170203949645; ...
    2,7,1232904.23502494;3,0,-0.0240650039730845;3,7,-1070777.16660869;8,1,0.0438319858566475];
I = ones(dim,1)*TableA1_3(:,1)'; J = ones(dim,1)*TableA1_3(:,2)'; n = ones(dim,1)*TableA1_3(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3d_pT(p,T)
dim = length(p);
Table4 = [0.00290000000000000,40,690,38,0.559000000000000,0.939000000000000,1,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_4 = [-12,4,-4.52484847171645e-10;-12,6,3.15210389538801e-05;-12,7,-0.00214991352047545;-12,10,508.058874808345; ...
    -12,12,-12712303.6845932;-12,16,1153711331204.97;-10,0,-1.97805728776273e-16;-10,2,2.41554806033972e-11; ...
    -10,4,-1.56481703640525e-06;-10,6,0.00277211346836625;-10,8,-20.3578994462286;-10,10,1443694.89909053; ...
    -10,14,-41125421794.6539;-8,3,6.23449786243773e-06;-8,7,-22.1774281146038;-8,8,-68931.5087933158; ...
    -8,10,-19541952.5060713;-6,6,3163.73510564015;-6,8,2240407.54426988;-5,1,-4.36701347922356e-06; ...
    -5,2,-0.000404213852833996;-5,5,-348.153203414663;-5,7,-385294.213555289;-4,0,1.35203700099403e-07; ...
    -4,1,0.000134648383271089;-4,7,125031.835351736;-3,2,0.0968123678455841;-3,4,225.660517512438; ...
    -2,0,-0.000190102435341872;-2,1,-0.0299628410819229;-1,0,0.00500833915372121;-1,1,0.387842482998411; ...
    -1,5,-1385.35367777182;0,0,0.870745245971773;0,2,1.71946252068742;1,0,-0.0326650121426383;1,6,4980.44171727877; ...
    3,0,0.00551478022765087];
I = ones(dim,1)*TableA1_4(:,1)'; J = ones(dim,1)*TableA1_4(:,2)'; n = ones(dim,1)*TableA1_4(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3e_pT(p,T)
dim = length(p);
Table4 = [0.00320000000000000,40,710,29,0.587000000000000,0.918000000000000,1,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_5 = [-12,14,715815808.404721;-12,16,-114328360753.449;-10,3,3.76531002015720e-12;-10,6,-9.03983668691157e-05; ...
    -10,10,665695.908836252;-10,14,5353641749.60127;-10,16,79497740233.5603;-8,7,92.2230563421437; ...
    -8,8,-142586.073991215;-8,10,-1117963.81424162;-6,6,8961.21629640760;-5,6,-6699.89239070491; ...
    -4,2,0.00451242538486834;-4,4,-33.9731325977713;-3,2,-1.20523111552278;-3,6,47599.2667717124; ...
    -3,7,-266627.750390341;-2,0,-0.000153314954386524;-2,1,0.305638404828265;-2,3,123.654999499486; ...
    -2,4,-1043.90794213011;-1,0,-0.0157496516174308;0,0,0.685331118940253;0,1,1.78373462873903;1,0,-0.544674124878910; ...
    1,4,2045.29931318843;1,6,-22834.2359328752;2,0,0.413197481515899;2,2,-34.1931835910405];
I = ones(dim,1)*TableA1_5(:,1)'; J = ones(dim,1)*TableA1_5(:,2)'; n = ones(dim,1)*TableA1_5(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3f_pT(p,T)
dim = length(p);
Table4 = [0.00640000000000000,40,730,42,0.587000000000000,0.891000000000000,0.500000000000000,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_6 = [0,-3,-2.51756547792325e-08;0,-2,6.01307193668763e-06;0,-1,-0.00100615977450049;0,0,0.999969140252192; ...
    0,1,2.14107759236486;0,2,-16.5175571959086;1,-1,-0.00141987303638727;1,1,2.69251915156554;1,2,34.9741815858722; ...
    1,3,-30.0208695771783;2,0,-1.31546288252539;2,1,-8.39091277286169;3,-5,1.81545608337015e-10; ...
    3,-2,-0.000591099206478909;3,0,1.52115067087106;4,-3,2.52956470663225e-05;5,-8,1.00726265203786e-15; ...
    5,1,-1.49774533860650;6,-6,-7.93940970562969e-10;7,-4,-0.000150290891264717;7,1,1.51205531275133; ...
    10,-6,4.70942606221652e-06;12,-10,1.95049710391712e-13;12,-8,-9.11627886266077e-09;12,-4,0.000604374640201265; ...
    14,-12,-2.25132933900136e-16;14,-10,6.10916973582981e-12;14,-8,-3.03063908043404e-07; ...
    14,-6,-1.37796070798409e-05;14,-4,-0.000919296736666106;16,-10,6.39288223132545e-10;16,-8,7.53259479898699e-07; ...
    18,-12,-4.00321478682929e-13;18,-10,7.56140294351614e-09;20,-12,-9.12082054034891e-12; ...
    20,-10,-2.37612381140539e-08;20,-6,2.69586010591874e-05;22,-12,-7.32828135157839e-11; ...
    24,-12,2.41995578306660e-10;24,-4,-0.000405735532730322;28,-12,1.89424143498011e-10;32,-12,-4.86632965074563e-10];
I = ones(dim,1)*TableA1_6(:,1)'; J = ones(dim,1)*TableA1_6(:,2)'; n = ones(dim,1)*TableA1_6(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3g_pT(p,T)
dim = length(p);
Table4 = [0.00270000000000000,25,660,38,0.872000000000000,0.971000000000000,1,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_7 = [-12,7,4.12209020652996e-05;-12,12,-1149872.38280587;-12,14,9481808850.32080; ...
    -12,18,-1.95788865718971e+17;-12,22,4.96250704871300e+24;-12,24,-1.05549884548496e+28; ...
    -10,14,-758642165988.278;-10,20,-9.22172769596101e+22;-10,24,7.25379072059348e+29;-8,7,-61.7718249205859; ...
    -8,8,10755.5033344858;-8,10,-37954580.2336487;-8,12,228646846221.831;-6,8,-4997410.93010619; ...
    -6,22,-2.80214310054101e+30;-5,7,1049154.06769586;-5,20,6.13754229168619e+27;-4,22,8.02056715528378e+31; ...
    -3,7,-29861781.9828065;-2,3,-91.0782540134681;-2,5,135033.227281565;-2,14,-7.12949383408211e+18; ...
    -2,24,-1.04578785289542e+36;-1,2,30.4331584444093;-1,8,5932507979.59445;-1,18,-3.64174062110798e+27; ...
    0,0,0.921791403532461;0,1,-0.337693609657471;0,2,-72.4644143758508;1,0,-0.110480239272601;1,1,5.36516031875059; ...
    1,3,-2914.41872156205;3,24,6.16338176535305e+39;5,22,-1.20889175861180e+38;6,12,8.18396024524612e+22; ...
    8,3,940781944.835829;10,0,-36727.9669545448;10,6,-8.37513931798655e+15];
I = ones(dim,1)*TableA1_7(:,1)'; J = ones(dim,1)*TableA1_7(:,2)'; n = ones(dim,1)*TableA1_7(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3h_pT(p,T)
dim = length(p);
Table4 = [0.00320000000000000,25,660,29,0.898000000000000,0.983000000000000,1,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_8 = [-12,8,0.0561379678887577;-12,12,7741354215.87083;-10,4,1.11482975877938e-09;-10,6,-0.00143987128208183; ...
    -10,8,1936.96558764920;-10,10,-605971823.585005;-10,14,17195156812433.7;-10,16,-1.85461154985145e+16; ...
    -8,0,3.87851168078010e-17;-8,1,-3.95464327846105e-14;-8,6,-170.875935679023;-8,7,-2120.10620701220; ...
    -8,8,17768333.7348191;-6,4,11.0177443629575;-6,6,-234396.091693313;-6,8,-6561744.21999594; ...
    -5,2,1.56362212977396e-05;-5,3,-2.12946257021400;-5,4,13.5249306374858;-4,2,0.177189164145813; ...
    -4,4,1394.99167345464;-3,1,-0.00703670932036388;-3,2,-0.152011044389648;-2,0,9.81916922991113e-05; ...
    -1,0,0.00147199658618076;-1,2,20.2618487025578;0,0,0.899345518944240;1,0,-0.211346402240858;1,2,24.9971752957491];
I = ones(dim,1)*TableA1_8(:,1)'; J = ones(dim,1)*TableA1_8(:,2)'; n = ones(dim,1)*TableA1_8(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3i_pT(p,T)
dim = length(p);
Table4 = [0.00410000000000000,25,660,42,0.910000000000000,0.984000000000000,0.500000000000000,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_9 = [0,0,1.06905684359136;0,1,-1.48620857922333;0,10,259862256980408;1,-4,-4.46352055678749e-12; ...
    1,-2,-5.66620757170032e-07;1,-1,-0.00235302885736849;1,0,-0.269226321968839;2,0,9.22024992944392; ...
    3,-5,3.57633505503772e-12;3,0,-17.3942565562222;4,-3,7.00681785556229e-06;4,-2,-0.000267050351075768; ...
    4,-1,-2.31779669675624;5,-6,-7.53533046979752e-13;5,-1,4.81337131452891;5,12,-2.23286270422356e+21; ...
    7,-4,-1.18746004987383e-05;7,-3,0.00646412934136496;8,-6,-4.10588536330937e-10;8,10,4.22739537057241e+19; ...
    10,-8,3.13698180473812e-13;12,-12,1.64395334345040e-24;12,-6,-3.39823323754373e-06;12,-4,-0.0135268639905021; ...
    14,-10,-7.23252514211625e-15;14,-8,1.84386437538366e-09;14,-4,-0.0463959533752385;14,5,-99226310037675.0; ...
    18,-12,6.88169154439335e-17;18,-10,-2.22620998452197e-11;18,-8,-5.40843018624083e-08;18,-6,0.00345570606200257; ...
    18,2,42227580030.4086;20,-12,-1.26974478770487e-15;20,-10,9.27237985153679e-10;22,-12,6.12670812016489e-14; ...
    24,-12,-7.22693924063497e-12;24,-8,-0.000383669502636822;32,-10,0.000374684572410204;32,-5,-93197.6897511086; ...
    36,-10,-0.0247690616026922;36,-8,65.8110546759474];
I = ones(dim,1)*TableA1_9(:,1)'; J = ones(dim,1)*TableA1_9(:,2)'; n = ones(dim,1)*TableA1_9(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3j_pT(p,T)
dim = length(p);
Table4 = [0.00540000000000000,25,670,29,0.875000000000000,0.964000000000000,0.500000000000000,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_10 = [0,-1,-0.000111371317395540;0,0,1.00342892423685;0,1,5.30615581928979;1,-2,1.79058760078792e-06; ...
    1,-1,-0.000728541958464774;1,1,-18.7576133371704;2,-1,0.00199060874071849;2,1,24.3574755377290; ...
    3,-2,-0.000177040785499444;4,-2,-0.00259680385227130;4,2,-198.704578406823;5,-3,7.38627790224287e-05; ...
    5,-2,-0.00236264692844138;5,0,-1.61023121314333;6,3,6223.22971786473;10,-6,-9.60754116701669e-09; ...
    12,-8,-5.10572269720488e-11;12,-3,0.00767373781404211;14,-10,6.63855469485254e-15;14,-8,-7.17590735526745e-10; ...
    14,-5,1.46564542926508e-05;16,-10,3.09029474277013e-12;18,-12,-4.64216300971708e-16; ...
    20,-12,-3.90499637961161e-14;20,-10,-2.36716126781431e-10;24,-12,4.54652854268717e-12; ...
    24,-6,-0.00422271787482497;28,-12,2.83911742354706e-11;28,-5,2.70929002720228];
I = ones(dim,1)*TableA1_10(:,1)'; J = ones(dim,1)*TableA1_10(:,2)'; n = ones(dim,1)*TableA1_10(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3k_pT(p,T)
dim = length(p);
Table4 = [0.00770000000000000,25,680,34,0.802000000000000,0.935000000000000,1,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_11 = [-2,10,-401215699.576099;-2,12,48450147831.8406;-1,-5,3.94721471363678e-15;-1,6,37262.9967374147; ...
    0,-12,-3.69794374168666e-30;0,-6,-3.80436407012452e-15;0,-2,4.75361629970233e-07;0,-1,-0.000879148916140706; ...
    0,0,0.844317863844331;0,1,12.2433162656600;0,2,-104.529634830279;0,3,589.702771277429;0,14,-29102685116444.4; ...
    1,-3,1.70343072841850e-06;1,-2,-0.000277617606975748;1,0,-3.44709605486686;1,1,22.1333862447095; ...
    1,2,-194.646110037079;2,-8,8.08354639772825e-16;2,-6,-1.80845209145470e-11;2,-3,-6.96664158132412e-06; ...
    2,-2,-0.00181057560300994;2,0,2.55830298579027;2,4,3289.13873658481;5,-12,-1.73270241249904e-19; ...
    5,-6,-6.61876792558034e-07;5,-3,-0.00395688923421250;6,-12,6.04203299819132e-18;6,-10,-4.00879935920517e-14; ...
    6,-8,1.60751107464958e-09;6,-5,3.83719409025556e-05;8,-12,-6.49565446702457e-15;10,-12,-1.49095328506000e-12; ...
    12,-10,5.41449377329581e-09];
I = ones(dim,1)*TableA1_11(:,1)'; J = ones(dim,1)*TableA1_11(:,2)'; n = ones(dim,1)*TableA1_11(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3l_pT(p,T)
dim = length(p);
Table4 = [0.00260000000000000,24,650,43,0.908000000000000,0.989000000000000,1,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_12 = [-12,14,2607020586.47537;-12,16,-188277213604704;-12,18,5.54923870289667e+18; ...
    -12,20,-7.58966946387758e+22;-12,22,4.13865186848908e+26;-10,14,-815038000738.060;-10,24,-3.81458260489955e+32; ...
    -8,6,-0.0123239564600519;-8,10,22609563.1437174;-8,12,-495017809506.720;-8,14,5.29482996422863e+15; ...
    -8,18,-4.44359478746295e+22;-8,24,5.21635864527315e+34;-8,36,-4.87095672740742e+54;-6,8,-714430.209937547; ...
    -5,4,0.127868634615495;-5,5,-10.0752127917598;-4,7,7774514.37960990;-4,16,-1.08105480796471e+24; ...
    -3,1,-3.57578581169659e-06;-3,3,-2.12857169423484;-3,18,2.70706111085238e+29;-3,20,-6.95953622348829e+32; ...
    -2,2,0.110609027472280;-2,3,72.1559163361354;-2,10,-306367307532219;-1,0,2.65839618885530e-05; ...
    -1,1,0.0253392392889754;-1,3,-214.443041836579;0,0,0.937846601489667;0,1,2.23184043101700; ...
    0,2,33.8401222509191;0,12,4.94237237179718e+20;1,0,-0.198068404154428;1,16,-1.41415349881140e+30; ...
    2,1,-99.3862421613651;4,0,125.070534142731;5,0,-996.473529004439;5,1,47313.7909872765;6,14,1.16662121219322e+32; ...
    10,4,-3.15874976271533e+15;10,12,-4.45703369196945e+32;14,10,6.42794932373694e+32];
I = ones(dim,1)*TableA1_12(:,1)'; J = ones(dim,1)*TableA1_12(:,2)'; n = ones(dim,1)*TableA1_12(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3m_pT(p,T)
dim = length(p);
Table4 = [0.00280000000000000,23,650,40,1,0.997000000000000,1,0.250000000000000,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_13 = [0,0,0.811384363481847;3,0,-5681.99310990094;8,0,-17865719817.2556;20,2,7.95537657613427e+31; ...
    1,5,-81456.8209346872;3,5,-65977456.7602874;4,5,-15286114865.9302;5,5,-560165667510.446;1,6,458384.828593949; ...
    6,6,-38575400038384.8;2,7,45373580.0004273;4,8,939454935735.563;14,8,2.66572856432938e+27; ...
    2,10,-5475783138.99097;5,10,200725701112386;3,12,1850072455632.39;0,14,185135446.828337;1,14,-170451090076.385; ...
    1,18,157890366037614;1,20,-2.02530509748774e+15;28,20,3.68193926183570e+59;2,22,1.70215539458936e+17; ...
    16,22,6.39234909918741e+41;0,24,-821698160721956;5,24,-7.95260241872306e+23;0,28,2.33415869478510e+17; ...
    3,28,-6.00079934586803e+22;4,28,5.94584382273384e+24;12,28,1.89461279349492e+39;16,28,-8.10093428842645e+45; ...
    1,32,1.88813911076809e+21;8,32,1.11052244098768e+35;14,32,2.91133958602503e+45;0,36,-3.29421923951460e+21; ...
    2,36,-1.37570282536696e+25;3,36,1.81508996303902e+27;4,36,-3.46865122768353e+29;8,36,-2.11961148774260e+37; ...
    14,36,-1.28617899887675e+48;24,36,4.79817895699239e+64];
I = ones(dim,1)*TableA1_13(:,1)'; J = ones(dim,1)*TableA1_13(:,2)'; n = ones(dim,1)*TableA1_13(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3n_pT(p,T)
dim = length(p);
Table4 = [0.00310000000000000,23,650,39,0.976000000000000,0.997000000000000];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);
pi = p/pstar;theta = T/Tstar;
TableA1_14 = [0,-12,2.80967799943151e-39;3,-12,6.14869006573609e-31;4,-12,5.82238667048942e-28; ...
    6,-12,3.90628369238462e-23;7,-12,8.21445758255119e-21;10,-12,4.02137961842776e-15;12,-12,6.51718171878301e-13; ...
    14,-12,-2.11773355803058e-08;18,-12,0.00264953354380072;0,-10,-1.35031446451331e-32;3,-10,-6.07246643970893e-24; ...
    5,-10,-4.02352115234494e-19;6,-10,-7.44938506925544e-17;8,-10,1.89917206526237e-13;12,-10,3.64975183508473e-06; ...
    0,-8,1.77274872361946e-26;3,-8,-3.34952758812999e-19;7,-8,-4.21537726098389e-09;12,-8,-0.0391048167929649; ...
    2,-6,5.41276911564176e-14;3,-6,7.05412100773699e-12;4,-6,2.58585887897486e-09;2,-5,-4.93111362030162e-11; ...
    4,-5,-1.58649699894543e-06;7,-5,-0.525037427886100;4,-4,0.00220019901729615;3,-3,-0.00643064132636925; ...
    5,-3,62.9154149015048;6,-3,135.147318617061;0,-2,2.40560808321713e-07;0,-1,-0.000890763306701305; ...
    3,-1,-4402.09599407714;1,0,-302.807107747776;0,1,1591.58748314599;1,1,232534.272709876;0,2,-792681.207132600; ...
    1,4,-86987136466.2769;0,5,354542769185.671;1,6,400849240129329];
I = ones(dim,1)*TableA1_14(:,1)'; J = ones(dim,1)*TableA1_14(:,2)'; n = ones(dim,1)*TableA1_14(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = exp(sum(n.*(pi-a).^I.*(theta-b).^J,2));
v = vstar*omega;
end
function v = v3o_pT(p,T)
dim = length(p);
Table4 = [0.00340000000000000,23,650,24,0.974000000000000,0.996000000000000,0.500000000000000,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_15 = [0,-12,1.28746023979718e-35;0,-4,-7.35234770382342e-12;0,-1,0.00289078692149150;2,-1,0.244482731907223; ...
    3,-10,1.41733492030985e-24;4,-12,-3.54533853059476e-29;4,-8,-5.94539202901431e-18;4,-5,-5.85188401782779e-09; ...
    4,-4,2.01377325411803e-06;4,-1,1.38647388209306;5,-4,-1.73959365084772e-05;5,-3,0.00137680878349369; ...
    6,-8,8.14897605805513e-15;7,-12,4.25596631351839e-26;8,-10,-3.87449113787755e-18;8,-8,1.39814747930240e-13; ...
    8,-4,-0.00171849638951521;10,-12,6.41890529513296e-22;10,-8,1.18960578072018e-11;14,-12,-1.55282762571611e-18; ...
    14,-8,2.33907907347507e-08;20,-12,-1.74093247766213e-13;20,-10,3.77682649089149e-09;24,-12,-5.16720236575302e-11];
I = ones(dim,1)*TableA1_15(:,1)'; J = ones(dim,1)*TableA1_15(:,2)'; n = ones(dim,1)*TableA1_15(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3p_pT(p,T)
dim = length(p);
Table4 = [0.00410000000000000,23,650,27,0.972000000000000,0.997000000000000,0.500000000000000,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_16 = [0,-1,-9.82825342010366e-05;0,0,1.05145700850612;0,1,116.033094095084;0,2,3246.64750281543; ...
    1,1,-1235.92348610137;2,-1,-0.0561403450013495;3,-3,8.56677401640869e-08;3,0,236.313425393924; ...
    4,-2,0.00972503292350109;6,-2,-1.03001994531927;7,-5,-1.49653706199162e-09;7,-4,-2.15743778861592e-05; ...
    8,-2,-8.34452198291445;10,-3,0.586602660564988;12,-12,3.43480022104968e-26;12,-6,8.16256095947021e-06; ...
    12,-5,0.00294985697916798;14,-10,7.11730466276584e-17;14,-8,4.00954763806941e-10;14,-3,10.7766027032853; ...
    16,-8,-4.09449599138182e-07;18,-8,-7.29121307758902e-06;20,-10,6.77107970938909e-09;22,-10,6.02745973022975e-08; ...
    24,-12,-3.82323011855257e-11;24,-8,0.00179946628317437;36,-12,-0.000345042834640005];
I = ones(dim,1)*TableA1_16(:,1)'; J = ones(dim,1)*TableA1_16(:,2)'; n = ones(dim,1)*TableA1_16(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3q_pT(p,T)
dim = length(p);
Table4 = [0.00220000000000000,23,650,24,0.848000000000000,0.983000000000000,1,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_17 = [-12,10,-82043.3843259950;-12,12,47327151846.1586;-10,6,-0.0805950021005413;-10,7,32.8600025435980; ...
    -10,8,-3566.17029982490;-10,10,-1729857814.33335;-8,8,35176923.2729192;-6,6,-775489.259985144; ...
    -5,2,7.10346691966018e-05;-5,5,99349.9883820274;-4,3,-0.642094171904570;-4,4,-6128.42816820083; ...
    -3,3,232.808472983776;-2,0,-1.42808220416837e-05;-2,1,-0.00643596060678456;-2,2,-4.28577227475614; ...
    -2,4,2256.89939161918;-1,0,0.00100355651721510;-1,1,0.333491455143516;-1,2,1.09697576888873; ...
    0,0,0.961917379376452;1,0,-0.0838165632204598;1,1,2.47795908411492;1,3,-3191.14969006533];
I = ones(dim,1)*TableA1_17(:,1)'; J = ones(dim,1)*TableA1_17(:,2)'; n = ones(dim,1)*TableA1_17(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3r_pT(p,T)
dim = length(p);
Table4 = [0.00540000000000000,23,650,27,0.874000000000000,0.982000000000000,1,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_18 = [-8,6,0.00144165955660863;-8,14,-7014385996282.58;-3,-3,-8.30946716459219e-17;-3,3,0.261975135368109; ...
    -3,4,393.097214706245;-3,5,-10433.4030654021;-3,8,490112654.154211;0,-1,-0.000147104222772069; ...
    0,0,1.03602748043408;0,1,3.05308890065089;0,5,-3997452.76971264;3,-6,5.69233719593750e-12; ...
    3,-2,-0.0464923504407778;8,-12,-5.35400396512906e-18;8,-10,3.99988795693162e-13;8,-8,-5.36479560201811e-07; ...
    8,-5,0.0159536722411202;10,-12,2.70303248860217e-15;10,-10,2.44247453858506e-08;10,-8,-9.83430636716454e-06; ...
    10,-6,0.0663513144224454;10,-5,-9.93456957845006;10,-4,546.491323528491;10,-3,-14336.5406393758; ...
    10,-2,150764.974125511;12,-12,-3.37209709340105e-10;14,-12,3.77501980025469e-09];
I = ones(dim,1)*TableA1_18(:,1)'; J = ones(dim,1)*TableA1_18(:,2)'; n = ones(dim,1)*TableA1_18(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3s_pT(p,T)
dim = length(p);
Table4 = [0.00220000000000000,21,640,29,0.886000000000000,0.990000000000000,1,1,4];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_19 = [-12,20,-5.32466612140254e+22;-12,24,1.00415480000824e+31;-10,22,-1.91540001821367e+29; ...
    -8,14,1.05618377808847e+16;-6,36,2.02281884477061e+58;-5,8,88458547.2596134;-5,16,1.66540181638363e+22; ...
    -4,6,-313563.197669111;-4,32,-1.85662327545324e+53;-3,3,-0.0624942093918942;-3,8,-5041607241.32590; ...
    -2,4,18751.4491833092;-1,1,0.00121399979993217;-1,2,1.88317043049455;-1,3,-1670.73503962060; ...
    0,0,0.965961650599775;0,1,2.94885696802488;0,4,-65391.5627346115;0,28,6.04012200163444e+49; ...
    1,0,-0.198339358557937;1,32,-1.75984090163501e+57;3,0,3.56314881403987;3,1,-575.991255144384; ...
    3,2,45621.3415338071;4,3,-10917404.4987829;4,18,4.37796099975134e+33;4,24,-6.16552611135792e+45; ...
    5,4,1935687689.17797;14,24,9.50898170425042e+53];
I = ones(dim,1)*TableA1_19(:,1)'; J = ones(dim,1)*TableA1_19(:,2)'; n = ones(dim,1)*TableA1_19(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3t_pT(p,T)
dim = length(p);
Table4 = [0.00880000000000000,20,650,33,0.803000000000000,1.02000000000000,1,1,1];
vstar = Table4(1);pstar = Table4(2);Tstar = Table4(3); Nterms = Table4(4);
a = Table4(5);b = Table4(6);c = Table4(7);d = Table4(8);e = Table4(9);
pi = p/pstar;theta = T/Tstar;
TableA1_20 = [0,0,1.55287249586268;0,1,6.64235115009031;0,4,-2893.66236727210;0,12,-3859232023098.48; ...
    1,0,-2.91002915783761;1,10,-829088246858.083;2,0,1.76814899675218;2,6,-534686695.713469; ...
    2,14,1.60464608687834e+17;3,3,196435.366560186;3,8,1566374275417.29;4,0,-1.78154560260006; ...
    4,10,-2.29746237623692e+15;7,3,38565900.1648006;7,4,1105544467.90543;7,7,-67707383068734.9; ...
    7,20,-3.27910592086523e+30;7,36,-3.41552040860644e+50;10,10,-5.27251339709047e+20;10,12,2.45375640937055e+23; ...
    10,14,-1.68776617209269e+26;10,16,3.58958955867578e+28;10,22,-6.56475280339411e+35;18,18,3.55286045512301e+38; ...
    20,32,5.69021454413270e+57;22,22,-7.00584546433113e+47;22,36,-7.05772623326374e+64;24,24,1.66861176200148e+52; ...
    28,28,-3.00475129680486e+60;32,22,-6.68481295196808e+50;32,32,4.28432338620678e+68;32,36,-4.44227367758304e+71; ...
    36,36,-2.81396013562745e+76];
I = ones(dim,1)*TableA1_20(:,1)'; J = ones(dim,1)*TableA1_20(:,2)'; n = ones(dim,1)*TableA1_20(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3u_pT(p,T)
dim = length(p);
Table12 = [0.00260000000000000,23,650,38,0.902000000000000,0.988000000000000,1,1,1];
vstar = Table12(1);pstar = Table12(2);Tstar = Table12(3); Nterms = Table12(4);
a = Table12(5);b = Table12(6);c = Table12(7);d = Table12(8);e = Table12(9);
pi = p/pstar;theta = T/Tstar;
TableA2_1 = [-12,14,1.22088349258355e+17;-10,10,1042164686.08488;-10,12,-8.82666931564652e+15; ...
    -10,14,2.59929510849499e+19;-8,10,222612779142211;-8,12,-8.78473585050085e+17;-8,14,-3.14432577551552e+21; ...
    -6,8,-2169349169962.85;-6,12,1.59079648196849e+20;-5,4,-339.567617303423;-5,8,8843876513378.36; ...
    -5,12,-8.43405926846418e+20;-3,2,11.4178193518022;-1,-1,-0.000122708229235641;-1,1,-106.201671767107; ...
    -1,12,9.03443213959313e+24;-1,14,-6.93996270370852e+27;0,-3,6.48916718965575e-09;0,1,7189.57567127851; ...
    1,-2,0.00105581745346187;2,5,-651903203602581;2,10,-1.60116813274676e+24;3,-5,-5.10254294237837e-09; ...
    5,-4,-0.152355388953402;5,2,677143292290.144;5,3,276378438378930;6,-5,0.0116862983141686;6,2,-30142694798017.1; ...
    8,-8,1.69719813884840e-08;8,8,1.04674840020929e+26;10,-4,-10801.6904560140;12,-12,-9.90623601934295e-13; ...
    12,-4,5361164.83602738;12,4,2.26145963747881e+21;14,-12,-4.88731565776210e-10;14,-10,1.51001548880670e-05; ...
    14,-6,-22770.0464643920;14,6,-7.81754507698846e+27];
I = ones(dim,1)*TableA2_1(:,1)'; J = ones(dim,1)*TableA2_1(:,2)'; n = ones(dim,1)*TableA2_1(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3v_pT(p,T)
dim = length(p);
Table12 = [0.00310000000000000,23,650,39,0.960000000000000,0.995000000000000,1,1,1];
vstar = Table12(1);pstar = Table12(2);Tstar = Table12(3); Nterms = Table12(4);
a = Table12(5);b = Table12(6);c = Table12(7);d = Table12(8);e = Table12(9);
pi = p/pstar;theta = T/Tstar;
TableA2_2 = [-10,-8,-4.15652812061591e-55;-8,-12,1.77441742924043e-61;-6,-12,-3.57078668203377e-55; ...
    -6,-3,3.59252213604114e-26;-6,5,-25.9123736380269;-6,6,59461.9766193460;-6,8,-62418400710.3158; ...
    -6,10,3.13080299915944e+16;-5,1,1.05006446192036e-09;-5,2,-1.92824336984852e-06;-5,6,654144.373749937; ...
    -5,8,5131174628650.44;-5,10,-6.97595750347391e+18;-5,14,-1.03977184454767e+28;-4,-12,1.19563135540666e-48; ...
    -4,-10,-4.36677034051655e-42;-4,-6,9.26990036530639e-30;-4,10,5.87793105620748e+20;-3,-3,2.80375725094731e-18; ...
    -3,10,-1.92359972440634e+22;-3,12,7.42705723302738e+26;-2,2,-51.7429682450605;-2,4,8206120.48645469; ...
    -1,-2,-1.88214882341448e-09;-1,0,0.0184587261114837;0,-2,-1.35830407782663e-06;0,6,-7.23681885626348e+16; ...
    0,10,-2.23449194054124e+26;1,-12,-1.11526741826431e-35;1,-10,2.76032601145151e-29;3,3,134856491567853; ...
    4,-6,6.52440293345860e-10;4,3,5.10655119774360e+16;4,10,-4.68138358908732e+31;5,2,-7.60667491183279e+15; ...
    8,-12,-4.17247986986821e-19;10,-2,31254567775610.4;12,-3,-100375333864186;14,1,2.47761392329058e+26];
I = ones(dim,1)*TableA2_2(:,1)'; J = ones(dim,1)*TableA2_2(:,2)'; n = ones(dim,1)*TableA2_2(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3w_pT(p,T)
dim = length(p);
Table12 = [0.00390000000000000,23,650,35,0.959000000000000,0.995000000000000,1,1,4];
vstar = Table12(1);pstar = Table12(2);Tstar = Table12(3); Nterms = Table12(4);
a = Table12(5);b = Table12(6);c = Table12(7);d = Table12(8);e = Table12(9);
pi = p/pstar;theta = T/Tstar;
TableA2_3 = [-12,8,-5.86219133817016e-08;-12,14,-89446035500.5526;-10,-1,5.31168037519774e-31; ...
    -10,8,0.109892402329239;-8,6,-0.0575368389425212;-8,8,22827.6853990249;-8,14,-1.58548609655002e+18; ...
    -6,-4,3.29865748576503e-28;-6,-3,-6.34987981190669e-25;-6,2,6.15762068640611e-09;-6,8,-96110924.0985747; ...
    -5,-10,-4.06274286652625e-45;-4,-1,-4.71103725498077e-13;-4,3,0.725937724828145;-3,-10,1.87768525763682e-39; ...
    -3,3,-1033.08436323771;-2,1,-0.0662552816342168;-2,2,579.514041765710;-1,-8,2.37416732616644e-27; ...
    -1,-4,2.71700235739893e-15;-1,1,-90.7886213483600;0,-12,-1.71242509570207e-37;0,1,156.792067854621; ...
    1,-1,0.923261357901470;2,-1,-5.97865988422577;2,2,3219887.67636389;3,-12,-3.99441390042203e-30; ...
    3,-5,4.93429086046981e-08;5,-10,8.12036983370565e-20;5,-8,-2.07610284654137e-12;5,-6,-3.40821291419719e-07; ...
    8,-12,5.42000573372233e-18;8,-10,-8.56711586510214e-13;10,-12,2.66170454405981e-14;10,-8,8.58133791857099e-06];
I = ones(dim,1)*TableA2_3(:,1)'; J = ones(dim,1)*TableA2_3(:,2)'; n = ones(dim,1)*TableA2_3(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3x_pT(p,T)
dim = length(p);
Table12 = [0.00490000000000000,23,650,36,0.910000000000000,0.988000000000000,1,1,1];
vstar = Table12(1);pstar = Table12(2);Tstar = Table12(3); Nterms = Table12(4);
a = Table12(5);b = Table12(6);c = Table12(7);d = Table12(8);e = Table12(9);
pi = p/pstar;theta = T/Tstar;
TableA2_4 = [-8,14,3.77373741298151e+18;-6,10,-5071008837229.13;-5,10,-1.03363225598860e+15; ...
    -4,1,1.84790814320773e-06;-4,2,-0.000924729378390945;-4,14,-4.25999562292738e+23;-3,-2,-4.62307771873973e-13; ...
    -3,12,1.07319065855767e+21;-1,5,64866249228.0682;0,0,2.44200600688281;0,4,-8515357334.84258; ...
    0,10,1.69894481433592e+21;1,-10,2.15780222509020e-27;1,-1,-0.320850551367334;2,6,-3.82642448458610e+16; ...
    3,-12,-2.75386077674421e-29;3,0,-563199.253391666;3,8,-3.26068646279314e+20;4,3,39794900155318.4; ...
    5,-6,1.00824008584757e-07;5,-2,16223.4569738433;5,1,-43235522531.9745;6,1,-592874245598.610; ...
    8,-6,1.33061647281106;8,-3,1573381.97797544;8,1,25818961427085.3;8,8,2.62413209706358e+24; ...
    10,-8,-0.0920011937431142;12,-10,0.00220213765905426;12,-8,-11.0433759109547;12,-5,8470048.70612087; ...
    12,-4,-592910695.762536;14,-12,-1.83027173269660e-05;14,-10,0.181339603516302;14,-8,-1192.28759669889; ...
    14,-6,4308676.58061468];
I = ones(dim,1)*TableA2_4(:,1)'; J = ones(dim,1)*TableA2_4(:,2)'; n = ones(dim,1)*TableA2_4(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3y_pT(p,T)
dim = length(p);
Table12 = [0.00310000000000000,22,650,20,0.996000000000000,0.994000000000000,1,1,4];
vstar = Table12(1);pstar = Table12(2);Tstar = Table12(3); Nterms = Table12(4);
a = Table12(5);b = Table12(6);c = Table12(7);d = Table12(8);e = Table12(9);
pi = p/pstar;theta = T/Tstar;
TableA2_5 = [0,-3,-5.25597995024633e-10;0,1,5834.41305228407;0,5,-1.34778968457925e+16;0,8,1.18973500934212e+25; ...
    1,8,-1.59096490904708e+26;2,-4,-3.15839902302021e-07;2,-1,496.212197158239;2,4,3.27777227273171e+18; ...
    2,5,-5.27114657850696e+21;3,-8,2.10017506281863e-17;3,4,7.05106224399834e+20;3,8,-2.66713136106469e+30; ...
    4,-6,-1.45370512554562e-08;4,6,1.49333917053130e+27;5,-2,-14979562.0287641;5,1,-3.81881906271100e+15; ...
    8,-8,7.24660165585797e-05;8,-2,-93780816955019.3;10,-5,5144114683.76383;12,-8,-82819.8594040141];
I = ones(dim,1)*TableA2_5(:,1)'; J = ones(dim,1)*TableA2_5(:,2)'; n = ones(dim,1)*TableA2_5(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function v = v3z_pT(p,T)
dim = length(p);
Table12 = [0.00380000000000000,22,650,23,0.993000000000000,0.994000000000000,1,1,4];
vstar = Table12(1);pstar = Table12(2);Tstar = Table12(3); Nterms = Table12(4);
a = Table12(5);b = Table12(6);c = Table12(7);d = Table12(8);e = Table12(9);
pi = p/pstar;theta = T/Tstar;
TableA2_6 = [-8,3,2.44007892290650e-11;-6,6,-4630574.30331242;-5,6,7288032747.77712;-5,8,3.27776302858856e+15; ...
    -4,5,-1105981701.18409;-4,6,-3238999157299.57;-4,8,9.23814007023245e+15;-3,-2,8.42250080413712e-13; ...
    -3,5,663221436245.506;-3,6,-167170186672139;-2,2,2537.49358701391;-1,-6,-8.19731559610523e-21; ...
    0,3,328380587890.663;1,1,-62500479.1171543;2,6,8.03197957462023e+20;3,-6,-2.04397011338353e-11; ...
    3,-2,-3783.91047055938;6,-6,0.00972876545938620;6,-5,15.4355721681459;6,-4,-3739.62862928643; ...
    6,-1,-68285901137.4572;8,-8,-0.000248488015614543;8,-4,3945360.49497068];
I = ones(dim,1)*TableA2_6(:,1)'; J = ones(dim,1)*TableA2_6(:,2)'; n = ones(dim,1)*TableA2_6(:,3)';
pi = pi*ones(1,Nterms);
theta = theta*ones(1,Nterms);
omega = (sum(n.*((pi-a).^c).^I.*((theta-b).^d).^J,2)).^e;
v = vstar*omega;
end
function T = T3ab_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
I = [0;1;2;-1;-2];
n = [1547.93642129415;-187.661219490113;21.3144632222113;-1918.87498864292;918.419702359447];
theta = n(1)*log(pi).^I(1) + n(2)*log(pi).^I(2) + n(3)*log(pi).^I(3) + n(4)*log(pi).^I(4) + n(5)*log(pi).^I(5);
T = theta*Tstar;
end
function T = T3cd_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [585.276966696349;2.78233532206915;-0.0127283549295878;0.000159090746562729];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi*n(4))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3ef_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
dthetasatdpi_c = 3.727888004; % dervative at critical point
pcstar = 22.064; % critical point
Tcstar = 647.096; % critical point
pi = p/pstar;
theta = dthetasatdpi_c*(pi-pcstar) + Tcstar;
T = theta*Tstar;
end
function T = T3gh_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [-24928.4240900418;4281.43584791546;-269.029173140130;7.51608051114157;-0.0787105249910383];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi.*(n(4) + pi*n(5)))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3ij_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [584.814781649163;-0.616179320924617;0.260763050899562;-0.00587071076864459;5.15308185433082e-05];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi.*(n(4) + pi*n(5)))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3jk_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [617.229772068439;-7.70600270141675;0.697072596851896;-0.0157391839848015;0.000137897492684194];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi.*(n(4) + pi*n(5)))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3mn_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [535.339483742384;7.61978122720128;-0.158365725441648;0.00192871054508108];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi*n(4))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3op_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
I = [0;1;2;-1;-2];
n = [969.461372400213;-332.500170441278;64.2859598466067;773.845935768222;-1523.13732937084];
theta = n(1)*log(pi).^I(1) + n(2)*log(pi).^I(2) + n(3)*log(pi).^I(3) + n(4)*log(pi).^I(4) + n(5)*log(pi).^I(5);
T = theta*Tstar;
end
function T = T3qu_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [565.603648239126;5.29062258221222;-0.102020639611016;0.00122240301070145];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi*n(4))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3rx_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [584.561202520006;-1.02961025163669;0.243293362700452;-0.00294905044740799];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi*n(4))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3uv_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
n = [528.199646263062;8.90579602135307;-0.222814134903755;0.00286791682263697];
theta = n(1) + pi.*(n(2) + pi.*(n(3) + pi*n(4))); % use Horner's Method to speed up calculations
T = theta*Tstar;
end
function T = T3wx_p(p)
pstar = 1; % [MPa]
Tstar = 1; % [K]
pi = p/pstar;
I = [0;1;2;-1;-2];
n = [7.28052609145380;97.3505869861952;14.7370491183191;329.196213998375;873.371668682417];
theta = n(1)*log(pi).^I(1) + n(2)*log(pi).^I(2) + n(3)*log(pi).^I(3) + n(4)*log(pi).^I(4) + n(5)*log(pi).^I(5);
T = theta*Tstar;
end