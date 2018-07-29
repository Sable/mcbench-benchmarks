function capproach_prt(jdtdb)

% print closest approach conditions

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global au drsaved iplanet1 iplanet2 pnames

% convert julian day to calendar date and time strings

[cdstr, utstr] = jd2str(jdtdb);
 
% create text string

textstr = horzcat('time and conditions at closest approach between ', ...
    deblank(pnames(iplanet1, 1:7)), ' and ', deblank(pnames(iplanet2, 1:7)));

fprintf('\n\n');

disp(textstr);
fprintf('===============================================================\n\n');
    
fprintf('calendar date                ');

disp(cdstr);

fprintf('\nTDB time                     ');

disp(utstr);

fprintf('\nTDB Julian date              %16.8f \n', jdtdb);

jdutc = tdb2utc (jdtdb);

[cdstr, utstr] = jd2str(jdutc);

fprintf('\nUTC time                     ');

disp(utstr);

fprintf('\nUTC Julian date              %16.8f \n\n', jdutc);

% display heliocentric distance (kilometers and AU)

fprintf('close approach distance      %16.6f kilometers\n', drsaved);

fprintf('                             %16.12f AU\n', drsaved / au);



