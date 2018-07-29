% sep_ltot.m      April 29, 2008

% low-thrust orbit transfer between
% non-coplanar circular orbits using
% solar-electric propulsion (sep)

% Edelbaum equations

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% conversion factors

dtr = pi/180;               % degrees to radians

rtd = 180/pi;               % radians to degrees

% astrodynamic constants

req = 6378.14;              % Earth equatorial radius (kilometers)

mu = 398600.5;              % Earth gravitational constant (km^3/sec^2)

% request inputs

clc; home;

fprintf('\n   SEP Low-thrust Orbit Transfer Analysis\n');

while (1)
    fprintf('\n\nplease input the initial altitude (kilometers)\n');

    alt1 = input('? ');

    if (alt1 > 0)
        break;
    end
end

while (1)
    fprintf('\nplease input the final altitude (kilometers)\n');

    alt2 = input('? ');

    if (alt2 > 0)
        break;
    end
end

while (1)
    fprintf('\nplease input the initial orbital inclination (degrees)');
    fprintf('\n(0 <= inclination <= 180)\n');

    inc1 = input('? ');

    if (inc1 >= 0 && inc1 <= 180)
        break;
    end
end

while (1)
    fprintf('\nplease input the final orbital inclination (degrees)');
    fprintf('\n(0 <= inclination <= 180)\n');

    inc2 = input('? ');

    if (inc2 >= 0 && inc2 <= 180)
        break;
    end
end

while (1)
    fprintf('\nplease input the initial spacecraft mass (kilograms)\n');

    xmass0 = input('? ');

    if (xmass0 > 0)
        break;
    end
end

while (1)
    fprintf('\nplease input the SEP propulsive efficiency (non-dimensional)\n');

    teff = input('? ');

    if (teff > 0 && teff <= 1)
        break;
    end
end

while (1)
    fprintf('\nplease input the SEP input power (kilowatts)\n');

    tpower = input('? ');

    if (tpower > 0)
        break;
    end
end

while (1)
    fprintf('\nplease input the SEP specific impulse (seconds)\n');

    xisp = input('? ');

    if (xisp > 0)
        break;
    end
end

% compute thrust (newtons)

thrust = 1000.0d0 * (2.0d0 * teff * tpower / (9.80665d0 * xisp));

% compute the thrust acceleration to km/sec^2

thracc = (thrust / xmass0) / 1000;

% convert inclinations to radians

inc1 = inc1 * dtr;

inc2 = inc2 * dtr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve the orbit transfer problem %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate total inclination change

dinct = abs(inc2 - inc1);

% check for coplanar orbits

if (dinct == 0)
    dinct = 1.0e-8;
end

% compute geocentric radii of initial and final orbits (kilometers)

r1 = req + alt1;

r2 = req + alt2;

% compute "local circular velocity" of initial and final orbits

v1 = sqrt(mu / r1);

v2 = sqrt(mu / r2);

% initial yaw angle

beta0 = atan(sin(0.5 * pi * dinct) / ((v1/v2) - cos(0.5 * pi * dinct)));

% delta-v

dvt = v1 * cos(beta0) - v1 * sin(beta0) / tan(0.5 * pi * dinct + beta0);

% thrust duration

tdur = dvt / thracc;

if (tdur < 3600)
    % minutes
    tdflag = 1;
    tdur = tdur / 60;
elseif (tdur < 86400)
    % hours
    tdflag = 2;
    tdur = tdur / 3600;
else
    % days
    tdflag = 3;
    tdur = tdur / 86400;
end

dtstep = tdur / 100;

tsim = - dtstep;

for i = 1:1:101
    tsim = tsim + dtstep;

    if (tdflag == 1)
        tsec = 60 * tsim;
    elseif (tdflag == 2)
        tsec = 3600 * tsim;
    else
        tsec = 86400 * tsim;
    end

    t(i) = tsim;

    beta(i) = rtd * atan(v1 * sin(beta0) / (v1 * cos(beta0) ...
        - thracc * tsec));

    tmp1 = atan((thracc * tsec - v1 * cos(beta0))/(v1 * sin(beta0)));

    dinc = rtd * (2/pi) * (tmp1 + 0.5 * pi - beta0);

    inc(i) = rtd * inc1 - dinc;

    v(i) = 1000 * sqrt(v1 * v1 - 2 * v1 * thracc * tsec * cos(beta0) ...
        + thracc * thracc * tsec * tsec);

    sma(i) = 1.0e6 * mu / (v(i) * v(i));
end

xmprop = xmass0 * (1.0d0 - exp(-1000.0d0 * dvt / (9.80665d0 * xisp)));

xmassf = xmass0 - xmprop;

% print results

clc; home;

fprintf('\n   SEP Low-thrust Orbit Transfer Analysis \n\n\n');

fprintf('initial orbit altitude      %10.4f kilometers \n\n', alt1);

fprintf('initial orbit inclination   %10.4f degrees \n\n', inc1 * rtd);

fprintf('initial orbit velocity      %10.4f meters/second \n\n\n', 1000 * v1);

fprintf('final orbit altitude        %10.4f kilometers \n\n', alt2);

fprintf('final orbit inclination     %10.4f degrees \n\n', inc2 * rtd);

fprintf('final orbit velocity        %10.4f meters/second \n\n', 1000 * v2);


fprintf('\npropulsive efficiency      %10.4f \n\n', teff);

fprintf('input power                 %10.4f kilowatts\n\n', tpower);

fprintf('specific impulse            %10.4f seconds\n\n', xisp);

fprintf('thrust                      %10.4f newtons\n\n', thrust);

fprintf('initial spacecraft mass     %10.4f kilograms\n\n', xmass0);

fprintf('final spacecraft mass       %10.4f kilograms\n\n', xmassf);

fprintf('propellant mass             %10.4f kilograms\n\n', xmprop);


fprintf('\ntotal inclination change    %10.4f degrees\n\n', rtd * dinct);

fprintf('total delta-v               %10.4f meters/second \n\n', 1000 * dvt);

if (tdflag == 1)
    fprintf('thrust duration             %10.4f minutes \n\n', tdur);
elseif (tdflag == 2)
    fprintf('thrust duration             %10.4f hours \n\n', tdur);
else
    fprintf('thrust duration             %10.4f days \n\n', tdur);
end

fprintf('initial yaw angle           %10.4f degrees \n\n', rtd * beta0);

fprintf('thrust acceleration         %10.6f meters/second^2 \n\n', 1000 * thracc);

keycheck;

% display graphics

subplot(2,1,1);

plot(t, beta);

title('SEP Low-thrust Orbit Transfer', 'FontSize', 16);

ylabel('Yaw Angle (deg)', 'FontSize', 12);

grid;

subplot(2,1,2);

plot(t, inc);

if (tdflag == 1)
    xlabel('Simulation Time (minutes)', 'FontSize', 12);
elseif (tdflag == 2)
    xlabel('Simulation Time (hours)', 'FontSize', 12);
else
    xlabel('Simulation Time (days)', 'FontSize', 12);
end

ylabel('Inclination (deg)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 sep_ltot1.eps

keycheck;

subplot(2,1,1);

plot(t, v);

title('SEP Low-thrust Orbit Transfer', 'FontSize', 16);

ylabel('Velocity (m/s)', 'FontSize', 12);

grid;

subplot(2,1,2);

plot(t, sma);

if (tdflag == 1)
    xlabel('Simulation Time (minutes)', 'FontSize', 12);
elseif (tdflag == 2)
    xlabel('Simulation Time (hours)', 'FontSize', 12);
else
    xlabel('Simulation Time (days)', 'FontSize', 12);
end

ylabel('Semimajor Axis (kilometers)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 sep_ltot2.eps
