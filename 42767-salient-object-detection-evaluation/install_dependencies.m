% @author: B. Schauerte
% @date:   2013
% @url:    http://cvhci.anthropomatik.kit.edu/~bschauer/

% create sub-folder
libs_folder = 'libs';
mkdir(libs_folder);

% install the spectral saliency toolbox
mkdir(libs_folder,'svst');
unzip('http://www.mathworks.com/matlabcentral/fileexchange/32455-spectral-phase-based-visual-saliency?download=true',fullfile(libs_folder,'svst',''));
cd(fullfile('libs','svst',''));
get_additional_files();
cd(fileparts(mfilename('fullpath')));

% install the progressbar package
mkdir(libs_folder,'prog');
unzip('http://www.mathworks.com/matlabcentral/fileexchange/6922-progressbar?download=true',fullfile(libs_folder,'prog',''));