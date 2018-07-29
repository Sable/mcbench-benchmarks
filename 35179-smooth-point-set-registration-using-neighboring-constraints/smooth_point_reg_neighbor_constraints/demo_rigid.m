% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Demo of the rigid method
% 
% For the correct execution of this demo you will need the synthetic 
% datasets by Dr. Haili Chui and Prof. Anand Rangarajan, available at:
% http://www.umiacs.umd.edu/~zhengyf/PointMatchDemo/DataChui.zip
% 

clear variables;

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
        
        % Adjacencies
        if ~isempty(strfind(exp_type,'outlier'))
            K = 4;
            [aD1,aD2] = adjZD_eff(gD,K);
            [aM1,aM2] = adjZD_eff(gM,K);
        else
            K = 5;
            [aD1,aD2] = adjKNN_eff(gD,K);
            [aM1,aM2] = adjKNN_eff(gM,K);
        end
        
        % gm 
        Pe = 0.1; 
        Nd = 1;
        Sini = ini_pos(gD,gM);  % Match to closest points (initialization)
        mu_inc = 1.075;  % Softassign control var
        % 
        S = gm_em_soft(gD,aD1,aD2,gM,aM1,aM2,Pe,Nd,Sini,mu_inc);
        assig = munkres(-S); % Hungarian method to assign all the points
                                % according to the matrix of match coefs.
        sD = find(assig~=0);
        sM = assig(sD);
        r = gD(sD,:) - gD(sM,:);  % point-wise errors
        E(perturb,sample) = mean(sqrt(diag(r*r')));
        disp(['ERROR=',num2str(E(perturb,sample))]);
        

    end
end

save(strcat('rigid_',exp_type),'E');

