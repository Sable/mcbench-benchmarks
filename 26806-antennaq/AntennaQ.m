% AntennaQ computes physical bounds on Q and D/Q for linearly polarized antennas composed by non-magnetic materials.
%
%%% Examples: 
%   [DQ,Q,ka,polarizability] = AntennaQ(height, width, geometry, frequency, abs_eff, fig_num)
%   [DQ,Q,ka,polarizability] = AntennaQ(logspace(-2,2,301), 1, 'rectangle_v');
%   [DQ,Q,ka,polarizability] = AntennaQ(logspace(-2,2,301), 1, 'rectangle_v', 1e9, 0.5, 1);
%   [DQ,Q,ka,polarizability] = AntennaQ(1, 1, 'cylinder_v', 1e6);
%   [DQ,Q,ka,polarizability] = AntennaQ(0.05, 0.02, 'spheroid_h', 1e9, 0.5)
%
%%% Input parameters
% height, width : height and diameter for {cylinder_h, cylinder_v, spheroid_h, spheroid_v}
%                    height and width for rectangles. Unit meter [m]
% geometry: {'rec_v', 'rec_h', 'cyl_v', 'cyl_h', 'spheroid_h', 'spheroid_v', }   
%     _h for horizontal (along the width) and _v for vertical (along the height) polarization
%   'rec_v', 'rectangle_v' – planar rectangle, zero thickness;
%   'cyl_h’, ‘cylinder_h’ – cylinder;
% frequency: resonance frequency in Hz (scalar). Default frequency = c0/(2*pi), ie k=1.
% abs_eff: generalized (all spectrum) absorption efficiency (scalar). Default abs_eff=1/2.
% fig_num: if fig_no>0 plots the D/Q results in figure number fig_no.
%
%%% Output parameters
% DQ: bound on D/Q (directivity/Q factor) 
% Q: Q factor (or antenna Q, radiation Q) for the case D=3/2
% ka: electrical size, ka = 2*pi*frequency*a/c0, where a is the radius of the smallest circumscribing sphere, ie
%        a=sqrt(height^2+diameter^2)/2 for geo={'rec','cyl'} and a=max(height,diameter)/2 for the spheroids;  
% polarizability: polarizability of the structure in unit meter^3 [m^3]
%
%%%
% Copyright (C) Mats Gustafsson 2009
% http://www.eit.lth.se/staff/mats.gustafsson
%%%
% This function calculates physical bounds on Q and D/Q for linearly
% polarized antennas composed by non-magnetic materials
% and circumscribed by various geometries as described in: 
% Gustafsson, Sohl, and Kristensson
% Illustrations of new physical bounds on linearly polarized antennas, 
% IEEE Trans. Antennas Propagat., Vol. 57, No. 5, pp. 1319-1327, 2009.
% http://dx.doi.org/10.1109/TAP.2009.2016683
% and
% Physical limitations on antennas of arbitrary shape, 
% Proc. Roy. Soc. A, Vol. 463, No. 2086, pp. 2589-2607, 2007. 
% http://dx.doi.org/10.1098/rspa.2007.1893
%
% The polarizability is based on analytic results for spheroids and approximations of integral equation (MoM) data with rational
% functions for cylinders and rectangles. 

function [DQ,Q,ka,polarizability] = AntennaQ(height, width, geometry, frequency, abs_eff, fig_no)

c0 = 299792458;  % speed of light

if nargin < 6
    fig_num = 0; % no figures
end
if nargin < 5
    abs_eff = 1/2; % small dipole type antennas
end
if nargin < 4
    frequency = c0/(2*pi); % given by k = 1;
end
if nargin < 3  % plot the D/Q-bound for a rectangle with
    height = logspace(-2,3,301);
    width = 1;
    geometry = 'rectangle';
    fig_num = 1;
end

% test of input format
Nl = length(height);
Nd = length(width);
Nf = length(frequency);
Nxi = max([Nl Nd Nf]);
formatcheck = ([Nl Nd Nf]==Nxi | [Nl Nd Nf]==1);
if sum(formatcheck)~=3
    disp('Wrong input format, see help AntennaQ');
    DQ=[]; Q=[]; xi=[]; gamma=[]; a=[]; ka=[];
    return
end
        
k = frequency/c0*2*pi;  % wavenumber
xi = height./width;  % semi axis ratio
Nxi = length(xi);       % Number of evaluation points


switch geometry
    case {'rec','rectangle','rec_v','rectangle_v'}
        % for xi \leq 1
        % gamma/a^3 = p1(xi)/q1(xi)*xi^2
        p1 = [-1.651 7.328 6.275];
        q1 = [1.242 1.025 0.8 1];
        ind1 = find(xi<=1);  % case 1
        xi1 = xi(ind1);
        gamma1 = polyval(p1,xi1)./polyval(q1,xi1).*xi1.^2;

        % for xi > 1
        % gamma/a^3 = gammasv*p2(1/xi)/q2(1/xi)
        p2 = [2.266 -11.42 18.098 1.001];
        q2 = [24.78 -0.309 17.074 1];
        ind2 = find(xi>1);  % case 2
        xi2 = 1./xi(ind2);
        e = sqrt(1-xi2.^2);       
        gammasv = 8*pi/3*e.^3./(log((1+e)./(1-e))-2*e);  % polarizability of a spheroid
        
        gamma2 = gammasv.*polyval(p2,xi2)./polyval(q2,xi2);

        gamma = zeros(1,Nxi);
        gamma(ind1) = gamma1;
        gamma(ind2) = gamma2;
        
        a = sqrt(height.^2+width.^2)/2;  % circumscribing sphere radius
    case {'rec_h','rectangle_h'}
        % for xi \leq 1
        % gamma/a^3 = p1(xi)/q1(xi)*xi^2
        p1 = [-1.651 7.328 6.275];
        q1 = [1.242 1.025 0.8 1];
        ind1 = find(xi>=1);  % case 1
        xi1 = 1./xi(ind1);
        gamma1 = polyval(p1,xi1)./polyval(q1,xi1).*xi1.^2;

        % for xi > 1
        % gamma/a^3 = gammasv*p2(1/xi)/q2(1/xi)
        p2 = [2.266 -11.42 18.098 1.001];
        q2 = [24.78 -0.309 17.074 1];
        ind2 = find(xi<1);  % case 2
        xi2 = xi(ind2);
        e = sqrt(1-xi2.^2);       
        gammasv = 8*pi/3*e.^3./(log((1+e)./(1-e))-2*e);  % polarizability of a spheroid
        
        gamma2 = gammasv.*polyval(p2,xi2)./polyval(q2,xi2);

        gamma = zeros(1,Nxi);
        gamma(ind1) = gamma1;
        gamma(ind2) = gamma2;
        
        a = sqrt(height.^2+width.^2)/2;  % circumscribing sphere radius       
    case {'cyl_h','cylinder_h'}
        % for xi \leq 1
        % gamma/a^3 = p1(xi)/q1(xi)
        p1 = [28.064  59.47 16/3];
        q1 = [9.032 -2.935 6.087 1];        
        ind1 = find(xi<=1);  % case 1
        xi1 = xi(ind1);
        gamma1 = polyval(p1,xi1)./polyval(q1,xi1);

        % for xi > 1
        % gamma/a^3 = p2(1/xi)/q2(1/xi)/xi^2
        p2 = [-2.804 13.932 12.565];
        q2 = [0.809 1.1 0.456 1];        
        
        ind2 = find(xi>1);  % case 2
        xi2 = 1./xi(ind2);
        gamma2 = xi2.^2.*polyval(p2,xi2)./polyval(q2,xi2);

        gamma = zeros(1,Nxi);
        gamma(ind1) = gamma1;
        gamma(ind2) = gamma2;  
        
        a = sqrt(height.^2+width.^2)/2;  % circumscribing sphere radius    
    case {'cyl_v','cylinder_v'}
        % for xi \leq 1
        % gamma/a^3 = p1(xi)/q1(xi)*xi^1       
        p1 = [36.097 59.056 6.241];
        q1 = [7.453 -1.92 5.2995 1]; 
        
        ind1 = find(xi<=1);  % case 1
        xi1 = xi(ind1);
        gamma1 = polyval(p1,xi1)./polyval(q1,xi1).*xi1;

        % for xi > 1
        % gamma = gammasv.*p2(l/xi)/q2(1/xi)
        p2 = [-4.355 24.004 1.135];        
        q2 = [21.706 -6.093 13.851 1];
        
        ind2 = find(xi>1);  % case 2
        xi2 = 1./xi(ind2);
        e = sqrt(1-xi2.^2);       
        gammasv = 8*pi/3*e.^3./(log((1+e)./(1-e))-2*e);
        
        gamma2 = gammasv.*polyval(p2,xi2)./polyval(q2,xi2);

        gamma = zeros(1,Nxi);
        gamma(ind1) = gamma1;
        gamma(ind2) = gamma2;         
        
        a = sqrt(height.^2+width.^2)/2;  % circumscribing sphere radius    
    case {'sph_h','spheroid_h'}
        ind1 = find(xi<1);  % case 1
        xi1 = xi(ind1);
        Va = 4*pi*xi1/3;
        e = sqrt(1-xi1.^2);
        gamma1 = 8*pi/3*e.^3./(acos(xi1)-xi1.*e);
        
        ind2 = find(xi>1);  % case 2
        xi2 = 1./xi(ind2);
        e = sqrt(1-xi2.^2);
        gamma2 = 16*pi/3*xi2.^2.*e.^3./(2*e-xi2.^2.*log((1+e)./(1-e)));

        ind3 = find(xi==1);  % case 3
        xi3 = xi(ind3);
        gamma3 = 4*pi*xi3;
        
        ind4 = find(xi<1e-7);  % case 4
        xi4 = xi(ind4);
        gamma4 = 16/3+0*xi4;        
        
        gamma = zeros(1,Nxi);
        gamma(ind1) = gamma1;
        gamma(ind2) = gamma2;
        gamma(ind3) = gamma3;
        gamma(ind4) = gamma4;     
        
        a = max(height, width)/2;  % circumscribing sphere radius    
    case {'sph_v','spheroid_v'}
        ind1 = find(xi<1);  % case 1
        xi1 = xi(ind1);
        e = sqrt(1-xi1.^2);
        gamma1 = 4*pi/3*xi1.*e.^3./(e-xi1.*acos(xi1));

        ind2 = find(xi>1);  % case 2
        xi2 = 1./xi(ind2);
        e = sqrt(1-xi2.^2);       
        gamma2 = 8*pi/3*e.^3./(log((1+e)./(1-e))-2*e);

        ind3 = find(xi==1);  % case 1
        xi3 = xi(ind3);
        gamma3 = 4*pi*xi3;
        
        gamma = zeros(1,Nxi);
        gamma(ind1) = gamma1;
        gamma(ind2) = gamma2;
        gamma(ind3) = gamma3; 
        
        a = max(height, width)/2;  % circumscribing sphere radius 
    otherwise
        disp('Wrong input format, see help AntennaQ');    
        DQ=[]; Q=[]; xi=[]; gamma=[]; a=[]; ka=[]; 
        return
end

ka = k.*a;

DQ = abs_eff*gamma.*ka.^3/(2*pi);
Q = 3./DQ/2;   % Q as determined from a single dipole mode with D=3/2 (assuming small antennas)
polarizability = gamma.*a.^3;

if fig_num
    figure(fig_num); clf
    loglog(xi,DQ./ka.^3,'b','linewidth',1)
    xlabel('\xi=height/width')
    ylabel('Physical bound on D/(Q(ka)^3)')
    title(strcat('Circumscribing: ', geometry))
    box off
    ylim([5e-4 1.5])    
end