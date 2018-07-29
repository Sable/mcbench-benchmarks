% maneuver1.m       July 15, 2013

% one impulse orbital transfer between intersecting circular orbits

% combined inclination and RAAN change

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global mu req rtd

% astrodynamic and utility constants

om_constants;

clc; home;

fprintf('\n                 program maneuver1 \n\n');

fprintf(' < one impulse transfer between circular orbits > \n');

% request orbit elements of first orbit

fprintf('\ninitial orbit\n');

while (1)
    
    fprintf('\nplease input the circular orbit altitude (kilometers)');
    fprintf('\n(altitude > 0)\n');

    alt = input('? ');

    if (alt > 0.0)
        break;
    end
    
end

oevi = getoe([0; 0; 1; 0; 1; 0]);

oevi(1) = alt + req;

% request orbit elements of second orbit

fprintf('\nfinal orbit\n');

oevf = getoe([0; 0; 1; 0; 1; 0]);

oevf(1) = alt + req;

% local circular velocity

vlc = sqrt(mu / oevi(1));

sinci = sin(oevi(3));

cinci = cos(oevi(3));

sincf = sin(oevf(3));

cincf = cos(oevf(3));

draan = oevf(5) - oevi(5);

% total plane change angle (radians)

theta = acos(sinci * sincf * cos(draan) + cinci * cincf);

% cosine of impulse argument of latitude on initial orbit

if (theta ~= 0.0)
    
    carglati = (cinci * cos(theta) - cincf) / (sinci * sin(theta));
    
    arglati = acos(carglati);
    
end

% arguments of latitude of impulse on initial orbit

if (abs(carglati) >= 1.0)
    
    arglati1(1) = 0.0;
    
    arglati1(2) = pi;
    
    arglati2(1) = 0.0;
    
    arglati2(2) = pi;
    
else
    
    if (draan > 0.0)
        
        imp1 = 1;
        
        imp2 = 3;
        
    else
        
        imp1 = 2;
        
        imp2 = 4;
        
    end

    arglati1(1) = fix(imp1 / 2) * pi - (-1) ^ imp1 * arglati;

    arglati1(2) = fix(imp2 / 2) * pi - (-1) ^ imp2 * arglati;

    % arguments of latitude of impulse on final orbit

    oevi(6) = arglati1(1);

    [r1, v1] = orb2eci(mu, oevi);

    oevf(6) = 0;

    [r2, v2] = orb2eci(mu, oevf);

    uv1 = r1 / norm(r1);

    uv2 = r2 / norm(r2);

    uv1dotuv2 = dot(uv1, uv2);

    arglati2(1) = acos(uv1dotuv2);

    arglati2(2) = mod(pi + arglati2(1), 2.0 * pi);

end

% compute delta-V vectors

oevi(6) = arglati1(1);

oevf(6) = arglati2(1);

[r11, v11] = orb2eci(mu, oevi);

[r21, v21] = orb2eci(mu, oevf);

for i = 1:1:3
    
    dv(i) = v21(i) - v11(i);
    
end

dv1 = 1000.0 * norm(dv);

upeci = dv / norm(dv);

[pitch1, yaw1] = ueci2angles(r11', v11', upeci');

%[uplvlh, pitch1, yaw1] = eci2lvlh (r11', v11', upeci');

oevi(6) = arglati1(2);

oevf(6) = arglati2(2);

[r12, v12] = orb2eci(mu, oevi);

[r22, v22] = orb2eci(mu, oevf);

for i = 1:1:3
    
    dv(i) = v22(i) - v12(i);
    
end

dv2 = 1000.0 * norm(dv);

upeci = dv / norm(dv);

[pitch2, yaw2] = ueci2angles(r12', v12', upeci');

%[uplvlh, pitch2, yaw2] = eci2lvlh (r12', v12', upeci');

% print true anomalies and delta-v at intersection

i = 1;

fprintf('\n\nsolution # %g \n\n', i);

fprintf('initial orbit true anomaly  %12.4f degrees \n', rtd * arglati1(1));

fprintf('final orbit true anomaly    %12.4f degrees \n\n', rtd * arglati2(1));

fprintf('delta-V required            %12.4f meters/second \n\n', dv1);

fprintf('LVLH pitch angle            %12.4f degrees\n', rtd * pitch1);

fprintf('LVLH yaw angle              %12.4f degrees\n\n', rtd * yaw1);

i = 2;

fprintf('solution # %g \n\n', i);

fprintf('initial orbit true anomaly  %12.4f degrees \n', rtd * arglati1(2));

fprintf('final orbit true anomaly    %12.4f degrees \n\n', rtd * arglati2(2));

fprintf('delta-V required            %12.4f meters/second \n\n', dv2);

fprintf('LVLH pitch angle            %12.4f degrees\n', rtd * pitch2);

fprintf('LVLH yaw angle              %12.4f degrees\n\n', rtd * yaw2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create trajectory graphics for both solutions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute orbital periods

period1 = 2.0 * pi * oevi(1) * sqrt(oevi(1) / mu);

period2 = 2.0 * pi * oevf(1) * sqrt(oevf(1) / mu);

deltat1 = period1 / 300;

simtime1 = -deltat1;

deltat2 = period2 / 300;

simtime2 = -deltat2;

for i = 1:1:301
    
    simtime1 = simtime1 + deltat1;
    
    simtime2 = simtime2 + deltat2;
    
    % compute initial orbit "normalized" position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime1, r11, v11);
    
    rp1_x(i) = rwrk(1) / req;
    
    rp1_y(i) = rwrk(2) / req;
    
    rp1_z(i) = rwrk(3) / req;
    
    % compute final orbit position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime2, r21, v21);
    
    rp2_x(i) = rwrk(1) / req;
    
    rp2_y(i) = rwrk(2) / req;
    
    rp2_z(i) = rwrk(3) / req;
        
end

figure(1);

% create axes vectors

xaxisx = [1 1.5];
xaxisy = [0 0];
xaxisz = [0 0];

yaxisx = [0 0];
yaxisy = [1 1.5];
yaxisz = [0 0];

zaxisx = [0 0];
zaxisy = [0 0];
zaxisz = [1 1.5];

hold on;

grid on;

% plot earth

[x y z] = sphere(24);

h = surf(x, y, z);

colormap([127/255 1 222/255]);

set (h, 'edgecolor', [1 1 1]);

% plot coordinate system axes

plot3(xaxisx, xaxisy, xaxisz, '-g', 'LineWidth', 1);

plot3(yaxisx, yaxisy, yaxisz, '-r', 'LineWidth', 1);

plot3(zaxisx, zaxisy, zaxisz, '-b', 'LineWidth', 1);

% plot initial orbit

plot3(rp1_x, rp1_y, rp1_z, '-r', 'LineWidth', 1.5);

plot3(rp1_x(1), rp1_y(1), rp1_z(1), 'ob');

% plot final orbit

plot3(rp2_x, rp2_y, rp2_z, '-b', 'LineWidth', 1.5);

plot3(rp2_x(end), rp2_y(end), rp2_z(end), 'ob');

xlabel('X coordinate (ER)', 'FontSize', 12);

ylabel('Y coordinate (ER)', 'FontSize', 12);

zlabel('Z coordinate (ER)', 'FontSize', 12);

title('Circular Orbit Plane Change - Solution #1', 'FontSize', 16);

axis equal;

view(-50, 20);

rotate3d on;

print('-depsc', 'plane_change1.eps');

saveas(h, 'plane_change1.fig');

for i = 1:1:301
    
    simtime1 = simtime1 + deltat1;
    
    simtime2 = simtime2 + deltat2;
    
    % compute initial orbit "normalized" position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime1, r12, v12);
    
    rp1_x(i) = rwrk(1) / req;
    
    rp1_y(i) = rwrk(2) / req;
    
    rp1_z(i) = rwrk(3) / req;
    
    % compute final orbit position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime2, r22, v22);
    
    rp2_x(i) = rwrk(1) / req;
    
    rp2_y(i) = rwrk(2) / req;
    
    rp2_z(i) = rwrk(3) / req;
        
end

figure(2);

% create axes vectors

xaxisx = [1 1.5];
xaxisy = [0 0];
xaxisz = [0 0];

yaxisx = [0 0];
yaxisy = [1 1.5];
yaxisz = [0 0];

zaxisx = [0 0];
zaxisy = [0 0];
zaxisz = [1 1.5];

hold on;

grid on;

% plot earth

[x y z] = sphere(24);

h = surf(x, y, z);

colormap([127/255 1 222/255]);

set (h, 'edgecolor', [1 1 1]);

% plot coordinate system axes

plot3(xaxisx, xaxisy, xaxisz, '-g', 'LineWidth', 1);

plot3(yaxisx, yaxisy, yaxisz, '-r', 'LineWidth', 1);

plot3(zaxisx, zaxisy, zaxisz, '-b', 'LineWidth', 1);

% plot initial orbit

plot3(rp1_x, rp1_y, rp1_z, '-r', 'LineWidth', 1.5);

plot3(rp1_x(1), rp1_y(1), rp1_z(1), 'ob');

% plot final orbit

plot3(rp2_x, rp2_y, rp2_z, '-b', 'LineWidth', 1.5);

plot3(rp2_x(end), rp2_y(end), rp2_z(end), 'ob');

xlabel('X coordinate (ER)', 'FontSize', 12);

ylabel('Y coordinate (ER)', 'FontSize', 12);

zlabel('Z coordinate (ER)', 'FontSize', 12);

title('Circular Orbit Plane Change - Solution #2', 'FontSize', 16);

axis equal;

view(-50, 20);

rotate3d on;

print('-depsc', 'plane_change2.eps');

saveas(h, 'plane_change2.fig');


