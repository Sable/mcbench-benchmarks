function nodal_prt(jdtdb)

% print nodal crossing conditions

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global smu iplanet1 pnames

% compute current state vector

[r1, v1] = pecliptic(jdtdb, iplanet1, 11);

% convert julian day to calendar date and time strings

[cdstr, utstr] = jd2str(jdtdb);

% check for type of nodal crossing

fprintf('\n');

if (v1(3) > 0.0)
    
    % ascending node
    
    textstr = horzcat('time and conditions at ascending node of ', pnames(iplanet1, 1:7));

    disp(textstr);
    fprintf('================================================\n\n');
    
else
    
    % descending node
    
    textstr = horzcat('time and conditions at descending node of ', pnames(iplanet1, 1:7));

    disp(textstr);    
    fprintf('=================================================\n\n');
    
end

fprintf('calendar date                ');

disp(cdstr);

fprintf('\nTDB time                     ');

disp(utstr);

fprintf('\nTDB Julian date              %16.8f \n', jdtdb);

jdutc = tdb2utc (jdtdb);

[cdstr, utstr] = jd2str(jdutc);

fprintf('\nUTC time                     ');

disp(utstr);

fprintf('\nUTC Julian date              %16.8f \n', jdutc);

fprintf('\n\n');

% create text string

textstr = horzcat('heliocentric orbital elements and state vector of ', pnames(iplanet1, 1:7));

disp(textstr);
fprintf ('(mean ecliptic and equinox J2000)');
fprintf ('\n---------------------------------\n');

oev = eci2orb1 (smu, r1, v1);

% print orbital elements and state vector

oeprint1(smu, oev, 3);

svprint(r1, v1);
