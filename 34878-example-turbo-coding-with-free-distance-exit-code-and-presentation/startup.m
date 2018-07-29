home = pwd;

if ispc
    % setup the path
    addpath( strcat( home, '\turboUtils'), ...
        strcat( home, '\turboUtils\freeDistance' ), ...
    strcat( home, '\turboUtils\EXIT' ));
else
    % setup the path
    addpath( strcat( home, '/turboUtils'), ...
        strcat( home, '/turboUtils/freeDistance' ), ...
        strcat( home, '/turboUtils/EXIT' ));
end

cd cml
CmlStartup
cd ..