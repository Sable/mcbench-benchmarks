%US_NAVY2	US NAvy turning criterion 
%   Plots Figure 8.7. For explanations see Section 8.3. It is assumed that
%   the speed in turning equals 0.65 the straight-line speed, and the
%   turning radius is 2.5 times the ship length.
%   After entering US_Navy2 a plot of the righting arm and of the heeling arm
%   appears. Bring the crosshair over the first intersection of these
%   curves and click the left-hand mouse button. The crosshair appears again. 
%   Bring it over the second intersection of the righting-arm and heeling-arm
%   curves. A third crosshair appears; click it over the angle of vanishing 
%   stability. The area between the curves is painted in grey. The programme
%   displays the values required for checking the stability-in-turning criteria
%   of the US Navy.
% Companion file to Biran, A. (2003), Ship Hydrostatics and Stability,
% Oxford: Butterworth-Heunemann.

% Data of small cargo ship
W     = 2625;				% salt water displacement, t
KM    = 5.16;				% transverse metacentre above BL, m
KG    = 5.0; 				% CG above BL, m
GM    = KM - KG;	   		% metacentric height, m
Tm    = 4.32;				% mean draught, m
l_F   = 0.04;				% free-surface effect, m
disp('Effective metacentric height, m')
GMeff = GM - l_F			% effective metacentric height, m
% heel angles, degrees
heel = [ 0 10 20 30 45 60 75 90 ];
% l_p, levers of form stability (cross-curves), m
l_p   = [ 0 0.918 1.833 2.717 3.847 4.653 5.007 4.994  ];
hi    = 0: 2.5: 90;			% interpolating heel scale, deg
l_pi  = spline(heel, l_p, hi);
GZ    = l_pi - (KG + l_F)*sin(pi*hi/180);		% effective righting arm, m

rad1  = 180/pi;             % value of 1 radian in degrees
Hp = plot(hi, GZ, 'k-');
set(Hp, 'LineWidth', 1.5)
Ht = text(hi(19), 1.1*GZ(19), 'GZ_{eff}');
set(Ht, 'FontSize', 14)

hold on
grid
Hl = xlabel('Heel angle, degrees');
set(Hl, 'FontSize', 14)
Hl = ylabel('Lever arms, m');
set(Hl, 'FontSize', 14)

Ht = title([ '75.4 m ship, \Delta = 2625 t, KG = 5 m, US Navy turning criterion' ]);
set(Ht, 'FontSize', 14)

L    = 75.4;										% ship length, m
disp('Ship speed in turning circle, m/s')
V0   = 0.65*16*0.5144								% ship speed in turning, m/s
disp('Radius of turning circle, m')
R    = 2.5*L										% turning radius
disp('Heeling arm in upright position')
l_T0 = V0^2*(KG - Tm/2)/(9.81*R)  	     			% heeling arm in turning
l_TC = l_T0*cos(hi*pi/180);
plot(hi, l_TC, 'k-')
% find important angles
[ phi_st1 l1 ]    = ginput(1);                      % click over 1st static angle
[ phi_st2 l2 ]    = ginput(1);                      % click over 2nd static angle
[ phi_vanish l3 ] = ginput(1);                       % click over angle of vanishing stability
disp('GZ at first static angle, m')
l1
disp('maximum GZ, m')
max(GZ)
disp('GZ ratio')
l1/max(GZ)
% calculate area under GZ curve
I_GZ  = find(hi <= phi_vanish);
GZpos = [ GZ(I_GZ) 0 ];								% positive righting arms
Hipos = [ hi(I_GZ) phi_vanish ];					% positive range
disp('Area under positive GZ curve')
AreaT = trapz(Hipos, GZpos)*(pi/180)				% total area in metre-radian
I_A   = find((hi >= phi_st1)&(hi <= phi_st2));
GZ_A  = [ l1 GZ(I_A) l2 ];
hi_A  = hi(I_A);
h_TA  = [ phi_st1 hi_A phi_st2 ];
l_TA  = l_T0*cos(h_TA*pi/180);
disp('Area representing reserve of stability, m.rad')
AreaA = trapz(h_TA, (GZ_A - l_TA))*(pi/180)			% reserve of stability, metre-radian
disp('Ratio of areas')
AreaA/AreaT

% paint reserve of stability
na  = length(h_TA);
for k = 1:na
	hai(k) = h_TA(na - k + 1);
end	
h_Ti  = [ phi_st2 hai ];
l_Ti  = l_T0*cos(h_Ti*pi/180);
patch([ h_TA h_Ti ], [ GZ_A l_Ti ], [ 0.9 0.9 0.9 ])
Ht = text(hi(10), 1.2*l_TC(10), 'l_{TC}');
set(Ht, 'FontSize', 14)


hold off
