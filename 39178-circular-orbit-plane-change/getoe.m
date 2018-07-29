function oev = getoe(ioev)

% interactive request of classical orbital elements

% NOTE: all angular elements are returned in radians

% input

%  ioev = request array (1 = yes, 0 = no)

% output

%  oev(1) = semimajor
%  oev(2) = orbital eccentricity
%  oev(3) = orbital inclination
%  oev(4) = argument of perigee
%  oev(5) = right ascension of the ascending node (ioev(5) = 1)
%  oev(5) = east longitude of the ascending node (ioev(5) = 2)
%  oev(6) = true anomaly

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dtr = pi / 180;

oev = zeros(6,1);

if (ioev(1) == 1)
    % semimajor axis (kilometers)
    % (semimajor axis > req)

    for itry = 1:1:5
        fprintf('\nplease input the semimajor axis (kilometers)');
        fprintf('\n(semimajor axis > 0)\n');

        sma = input('? ');

        if (sma > 0)
            break;
        end
    end
    oev(1) = sma;
end

if (ioev(2) == 1)
    % orbital eccentricity (non-dimensional)
    % (0 <= eccentricity < 1)

    for itry = 1:1:5
        fprintf('\nplease input the orbital eccentricity (non-dimensional)');
        fprintf('\n(0 <= eccentricity < 1)\n');

        ecc = input('? ');

        if (ecc >= 0 && ecc < 1)
            break;
        end
    end
    oev(2) = ecc;
end

if (ioev(3) == 1)
    % orbital inclination (degrees)
    % (0 <= inclination <= 180)

    for itry = 1:1:5
        fprintf('\nplease input the orbital inclination (degrees)');
        fprintf('\n(0 <= inclination <= 180)\n');

        orbinc = input('? ');

        if (orbinc >= 0 && orbinc <= 180)
            break;
        end
    end
    oev(3) = dtr * orbinc;
end

if (ioev(4) == 1)
    % argument of perigee (degrees)
    % (0 <= argument of perigee <= 360)

    if (ecc > 0)

        for itry = 1:1:5

            fprintf('\nplease input the argument of perigee (degrees)');
            fprintf('\n(0 <= argument of perigee <= 360)\n');

            argper = input('? ');

            if (argper >= 0 && argper <= 360)
                break;
            end
        end
    else
        argper = 0;
    end
    oev(4) = dtr * argper;
end

if (ioev(5) >= 1)

    if (ioev(5) == 1)
        % raan (degrees)
        % (0 <= raan <= 360)

        if (oev(3) > 0)
            for itry = 1:1:5
                fprintf('\nplease input the right ascension of the ascending node (degrees)');
                fprintf('\n(0 <= raan <= 360)\n');

                raan = input('? ');

                if (raan >= 0 && raan <= 360)
                    break;
                end
            end
            oev(5) = dtr * raan;
        else
            oev(5) = 0;
        end
    end

    if (ioev(5) == 2)
        % elan (degrees)
        % (0 <= elan <= 360)

        if (oev(3) > 0)
            for itry = 1:1:5
                fprintf('\nplease input the east longitude of the ascending node (degrees)');
                fprintf('\n(0 <= elan <= 360)\n');

                elan = input('? ');

                if (elan >= 0 && elan <= 360)
                    break;
                end
            end
            oev(5) = dtr * elan;
        else
            oev(5) = 0;
        end
    end
end

if (ioev(6) == 1)
    % true anomaly (degrees)
    % (0 <= true anomaly <= 360)

    for itry = 1:1:5
        fprintf('\nplease input the true anomaly (degrees)');
        fprintf('\n(0 <= true anomaly <= 360)\n');

        tanom = input('? ');

        if (tanom >= 0 && tanom <= 360)
            break;
        end
    end
    oev(6) = dtr * tanom;
end





