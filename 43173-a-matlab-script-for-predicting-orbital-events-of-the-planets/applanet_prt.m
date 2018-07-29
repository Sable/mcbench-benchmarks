function applanet_prt(jdtdb)

% print aphelion/perihelion conditions

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global au pnames drsaved iap_flg iplanet1

% convert julian day to calendar date and time strings

[cdstr, utstr] = jd2str(jdtdb);

if (iap_flg == 1)
    
    % perihelion
    
    fprintf('\ntime and conditions at perihelion of ');
    disp(deblank(pnames(iplanet1, 1:7)));
    fprintf('============================================\n\n');
    
else
    
    % aphelion
    
    fprintf('\ntime and conditions at aphelion of ');
    disp(deblank(pnames(iplanet1, 1:7)));
    fprintf('==========================================\n\n');
    
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

fprintf('\nUTC Julian date              %16.8f \n\n', jdutc);

% display heliocentric distance (kilometers and AU)

fprintf('heliocentric distance        %16.6f kilometers\n', drsaved);

fprintf('                             %16.12f AU', drsaved / au);

% toggle minima flag

iap_flg = -iap_flg;


