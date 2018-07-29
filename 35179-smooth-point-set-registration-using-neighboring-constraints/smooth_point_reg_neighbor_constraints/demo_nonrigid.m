% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Demo of the non-rigid method
% 
% For the execution of the non-rigid version you will need the 'ctps_gen'
% and 'ctps_warp_pts' functions from the TPS-RPM implementation by
% Haili Chui and Anand Rangarajan ("A new algorithm for non-rigid point
% matching",IEEE CVPR 2000) available from:
% http://www.cise.ufl.edu/~anand/students/chui/rpm/TPS-RPM.zip
% 
% For the correct execution of this demo you will need the synthetic 
% datasets by Dr. Haili Chui and Prof. Anand Rangarajan, available at:
% http://www.umiacs.umd.edu/~zhengyf/PointMatchDemo/DataChui.zip
% 

clear variables;

if exist('ctps_gen') ~= 2 || exist('ctps_warp_pts') ~= 2
    disp('The MATLAB m-files (i.e., functions) "ctps_gen" and "ctps_warp_pts" are not available');
    disp('You can get them from the TPS-RPM implementation by Haili Chui and Anand Rangarajan');
    disp('"A new algorithm for non-rigid point matching",IEEE CVPR 2000');
    disp('http://www.cise.ufl.edu/~anand/students/chui/rpm/TPS-RPM.zip');
    return;
end

if exist('DataChui','dir') == 0
    disp('Fish and Chinese character datasets are not available');
    disp('You can download them from:')
    disp('http://www.umiacs.umd.edu/~zhengyf/PointMatchDemo/DataChui.zip');
    return;
end

% Type of experiments (uncomment the appropriate one)
exp_type = 'fish_def';
% exp_type = 'fish_noise';
% exp_type = 'fish_outlier';
% exp_type = 'chinese_def';
% exp_type = 'chinese_noise';
% exp_type = 'chinese_outlier';

% Path to the Chui's dataset
path = 'DataChui';
file_pattern = strcat('save_',exp_type,'_');

sample_range = 1:100;
if ~isempty(strfind(exp_type,'noise'))
    perturb_range = 1:6;
else
    perturb_range = 1:5;
end

E = inf(length(perturb_range),length(sample_range));

for perturb = perturb_range
    for sample = sample_range
        
        disp(['perturb = ',num2str(perturb),' sample = ',num2str(sample)]);
        
        % Read sample
        load(fullfile(path,strcat(file_pattern,num2str(perturb),'_',num2str(sample))),...
            'x1','y2a');
        gM = [-x1(:,2) x1(:,1)];
        gD = [-y2a(:,2) y2a(:,1)];
        lD = length(gD);
        lM = length(gM);
        
        if ~isempty(strfind(exp_type,'outlier'))
            vgM = match_chui_outl(gM,gD);
        else
            vgM = match_chui(gM,gD);
        end

        % gm 
        r = gD(1:lM,:) - vgM;
        E(perturb,sample) = mean(sqrt(diag(r*r')));
        disp(['ERROR=',num2str(E(perturb,sample))]);

    end
end

save(strcat('nonrigid_',exp_type),'E');

