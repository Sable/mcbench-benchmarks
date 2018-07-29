%US_NAVY1A	Explains the application of the US-Navy stability regulations
%   Plots Figure 8.5. The same like script file US_Navy1, but
%   limits the reserve-of-stability area to 60 degrees. For explanations see
%   Section 8.3.
%   After entering US_Navy1a a plot of the righting arm and of the wind arm
%   appears. Bring the crosshair over the first intersection of these
%   curves. The heel angle situated 25 degrees windwards of the first
%   static angle is marked. The areas under the curves are painted in grey. 
%   The programme displays the values required for checking the intact-stability
%   criteria of the US Navy, mainly the ratio of the righting arm at the first
%   static angle to the maximum righting arm, and the ratio of the areas a
%   and b. To make the plot look like in Figure 8.5 use the arrow facility
%   on the plot toolbar. 
% Companion file to Biran, A. (2003), Ship Hydrostatics and Stability,
% Oxford: Butterworth-Heunemann.

% Data of small cargo ship
W     = 2625;				% salt water displacement, t
KM    = 5.16;				% transverse metacentre above BL, m
KG    = 5.0; 				% CG above BL, m
GM    = KM - KG;	   		% metacentric height, m
l_F   = 0.04;				% free-surface effect, m
GMeff = GM - l_F			% effective metacentric height, m

% heel angles, degrees
heel = [ 0 10 20 30 45 60 75 90 ];
hi    = 0: 1: 90;			% interpolating heel scale, deg
l_pi  = spline(heel, l_p, hi);
GZ    = l_pi - (KG + l_F)*sin(pi*hi/180);		% effective righting arm, m
% lenh  = length(hi) - 1;
n     = 25;										% number of points at left of 0
hneg  = zeros(1, n);						    % allocate space for negative angles
GZneg = zeros(1, n);							% allocate space for negative GZ
for k = 1:n
	hneg(k)  = -hi(n - k + 2);
	GZneg(k) = -GZ(n - k + 2);
end
hext  = [ hneg hi ];							% extended angle axis, -25 +90				
GZext = [ GZneg GZ ];
rad1  = 180/pi;
Hp = plot(hext, GZext, 'k-');
set(Hp, 'LineWidth', 1.1)
Ht = text(hext(53), GZext(62), 'GZ') ;
set(Ht, 'FontSize', 14)
hold on
grid
Hl = xlabel('Heel angle, degrees');
set(Hl, 'FontSize', 14)
Hl = ylabel('Lever arms, m');
set(Hl, 'FontSize', 14)

Ht = title([ '75.4 m ship, \Delta = 2625 t, KG = 5 m, US Navy weather criterion' ]);
set(Ht, 'FontSize', 14)
% plot wind arm
V    = 80;										% wind speed, knots
A    = 175;										% sail area, m^2
ell  = 4.19;									% sail-area centroid above half-draught, m
disp('Wind arm in upright condition, m')
l_w0 = (0.017*V^2*A*ell)/(1000*W)				% wind arm at 0 degrees, m
l_w  = l_w0*cos(hext*pi/180).^2;				% wind arm, m
plot(hext, l_w, 'k-')
disp('First static angle, deg,  and corresponding righting arm, m')
[ theta0 l1 ] = ginput(1)						% find first static angle
theta1 = 25;
disp('Angle 25 deg windwards of first static angle, deg')
THETA  = theta0 - theta1
GZth = spline(hext, GZext, THETA);				% GZ at angle THETA		
plot([ THETA THETA ], [ GZth l1 ], 'k-')
plot([ THETA THETA ], [ -0.16 GZth ], 'k-')		% auxiliary line for 25 deg
plot([ theta0 theta0 ], [ -0.16 l1 ], 'k-')		% auxiliary line for 25 deg
Ht = text(-5, -0.15, '25^o');
set(Ht, 'FontSize', 14)

plot([ THETA (THETA + 3) ], [ -0.15 -0.15 ], 'k:')
plot([ theta0 (theta0 - 3) ], [ -0.15 -0.15 ], 'k:')
Ht = text(-29, 0.046, 'Wind arm, l_V');
set(Ht, 'FontSize', 14)


% paint area b
phi_st2 = 60;			% second static angle
I2  = find(hext == phi_st2);
GZ2 = GZext(I2);
Ia  = find((hext >= theta0)&(hext <= phi_st2));
ha  = [ theta0 hext(Ia) phi_st2 ];
GZ2 = spline(hext, GZext, phi_st2);
Ht = text(theta0, -0.17, '\phi_{st1}');
set(Ht, 'FontSize', 14)

plot([ phi_st2 phi_st2 ], [ -0.15, GZ2 ], 'k-')
Ht = text(phi_st2, -0.17, '\phi_{st2}');
set(Ht, 'FontSize', 14)


GZa = [ l1 GZext(Ia)  GZ2 ];
hai = zeros(size(ha));
na  = length(ha);
for k = 1:na
	hai(k) = ha(na - k + 1);
end	

l2i = l_w0*cos(hai*pi/180).^2;					% wind arm, m
l3  = [ GZ2 l2i l1 ];
patch([ ha hai ], [ GZa l2i ], [ 0.9 0.9 0.9 ])
% paint area a
Ib  = find((hext >= THETA)&(hext <= theta0));
hb  = [ THETA hext(Ib) theta0  ];
GZb = [ GZth GZext(Ib) l1 ];
nb  = length(hb);
hbi = zeros(size(hb));
for k = 1:nb
	hbi(k) = hb(nb - k + 1);
end	
lb  = l_w0*cos(hbi*pi/180).^2;
% patch([ hb haa THETA ], [ GZb l_w2 l_w2 ], [ 0.9 0.9 0.9 ])
patch([ hb hbi ], [ GZb lb  ], [ 0.9 0.9 0.9 ])

% plot([ min(hext) 15 ], [ l_w1 l_w1 ], 'k-')
Ht = text(-9, -0.007, 'a');
set(Ht, 'FontSize', 14)

Ht = text(45, 0.15, 'b');
set(Ht, 'FontSize', 14)


disp('GZst/GZmax ratio')
l1/max(GZext)

% calculate areas under the curve
la     = l_w0*cos(ha*pi/180).^2;					% wind arm, m
Area_b = trapz(ha, (GZa - la));						% metre-degree
disp('Area b, m.rad')
A_b    = pi*Area_b/180								% metre-radian
lb     = l_w0*cos(hb*pi/180).^2;
Area_a = trapz(hb, (GZb - lb)); 					% metre-degree
disp('Area a, m.rad')
A_a    = pi*Area_a/180								% metre-radian
disp('Area of ratios')
A_b/A_a
disp('Maximum GZ, m')
max(GZext)
hold off
