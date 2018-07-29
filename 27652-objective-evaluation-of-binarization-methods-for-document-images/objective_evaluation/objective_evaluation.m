function objective_evaluation(listfilename, outputfile, varargin) 
% September 16th, 2013, By Reza FARRAHI MOGHADDAM, Synchromedia Lab, ETS, Montreal, Canada
% May 20th, 2009, By Reza Farrahi Moghaddam
%

% get the parameters
[u_tag, u_extention, back_shift_for_u, back_shift_for_GT, GT_tag_and_ext, SKL_GT_tag_and_ext, SKL_GT_flag, text_region_flag, meddir, GT_meddir, No_DIBCO] = cehck_the_argin_infile(nargin, varargin{:});

% read list
fidparam = fopen(strcat(listfilename), 'r');  
filenumbercount=1;
while 1
    tline = fgetl(fidparam);
    if ~ischar(tline),   break,   end
    disp(tline)
    u0filelist(filenumbercount)={tline};
    filenumbercount=filenumbercount+1;
end
status = fclose(fidparam);

% open output file 0
fidparamout = fopen(strcat(outputfile), 'w');
fprintf(fidparamout, 'Please note that MPM is amplified by a factor of 1000, and NRM by a factor of 100.\n');
fprintf(fidparamout, '%16.16s %9.9s  %9.9s  %10.10s  %8.8s  %9.9s  %9.9s  %9.9s %10.10s  %9.9s  %9.9s  %9.9s  %8.8s  %9.9s  %9.9s  %9.9s  %9.9s \n', ...
    'Filename', 'precision', 'recall', 'f-measure (%%)', 'PSNR', 'DRD', 'MPM', 'NRM', 'p-re', 'p-f-measure (%%)','sens', 'spec', 'BCR', 'BER (%%)', 's-f-measure (%%)', 'accu', 'SSIM');

% 1
sum_temp_p = [];
sum_temp_r = [];
sum_temp_f = []; 
sum_temp_PSNR = [];
sum_temp_DRD = [];
sum_temp_MPM = [];  
sum_temp_NRM = []; 
sum_temp_pseudo_p = [];
sum_temp_pseudo_r = [];
sum_temp_pseudo_f = []; 
sum_temp_sens = []; 
sum_temp_spec = []; 
sum_temp_BCR = []; 
sum_temp_BER = []; 
sum_temp_s_f_measure = []; 
sum_temp_accu = [];
%
sum_temp_ssim = [];
%
sum_temp = 0;
for i=1:size(u0filelist,2)
    close all;
    u0filelist{i} = strtrim(u0filelist{i});
	u0name_full = u0filelist{i}(1:size(u0filelist{i},2))
    u0name = u0name_full(1:end - back_shift_for_u);
    
    % clear
    u0_GT = [];
    u_SKL_GT = [];
    u = [];
    xm = [];
    ym = [];
    temp_objective_eval = [];
    
    % get the GT
    got_the_GT_flag = false;
    for temp_label_GT=1:numel(GT_tag_and_ext)
        try 
            u0_GT = imread([GT_meddir, u0name_full(1:end - back_shift_for_GT + 0), GT_tag_and_ext{temp_label_GT}]); %
            u0_GT = [mat2gray(u0_GT) > 0.5];    %
            [xm ym zm] = size(u0_GT);
            u0_GT_filename = [GT_meddir, u0name_full(1:end - back_shift_for_GT + 0), GT_tag_and_ext{temp_label_GT}];
            if (zm ~= 1)
                u0_GT = u0_GT(:, :, 1);
            end
            got_the_GT_flag = true;
        catch ME
            % not this one. Good luck with the next one.
        end
        if (got_the_GT_flag)
            break;
        end
    end
    
    % get SKL_GT
    try
        u_SKL_GT = imread([meddir,u0name_full(1:end - back_shift + 0), SKL_GT_tag_and_ext]); %
        u_SKL_GT = [mat2gray(u_SKL_GT) > 0.5];    % 
        u_SKL_GT_filename = [meddir,u0name_full(1:end - back_shift + 0), SKL_GT_tag_and_ext];
        no_SLK_image_flag = false;
    catch ME
        try
            u_SKL_GT = NaN * ones([xm ym]);
            no_SLK_image_flag = true;
        catch MEE
            continue;
        end
    end    
    
    % apply the text_region_flag
    if (text_region_flag)
        temp_max_radius = my_get_max_radius(u0_GT);
        u0_GT_mask = bwmorph(u0_GT, 'erode', temp_max_radius);
        u0_GT_mask(1:temp_max_radius, :) = u0_GT(1:temp_max_radius, :);
        u0_GT_mask(end - temp_max_radius + 1:end, :) = u0_GT(end - temp_max_radius + 1:end, :);
        u0_GT_mask(:, 1:temp_max_radius) = u0_GT(:, 1:temp_max_radius);
        u0_GT_mask(:, end - temp_max_radius + 1:end) = u0_GT(:, end - temp_max_radius + 1:end);   
        % figure, imshow(u0_GT_mask)    
    else
        u0_GT_mask = zeros([xm ym]);
    end
    
    % 1
    break_the_u_loop_flag = false;
    for temp_label_u_extention = 1 : numel(u_extention)
        % get target
        try
            u = imread([meddir, u0name, u_tag, u_extention{temp_label_u_extention}]);
            u = [mat2gray(u) > .5];
            u_filename = [meddir, u0name, u_tag, u_extention{temp_label_u_extention}];
        catch ME
            u = NaN * ones([xm ym]);
            break_the_u_loop_flag = true;
        end
        % figure, imshow(u0_GT)
        % figure, imshow(u)   
        
        % inverse if text is white
        u_NaN = double(u);
        u0_GT_mask_NaN = double(u0_GT_mask);
        u_NaN(find(u0_GT == 1)) = NaN;
        u0_GT_mask_NaN(find(u0_GT == 1)) = NaN;
        % figure, imshow(u0_GT_mask_thin)  
        % figure, imshow(u_NaN)  
        % figure, imshow(u0_GT_mask_NaN) 

        % apply the text_region_flag
        if (text_region_flag)&&(not(break_the_u_loop_flag))
            u = or(u, u0_GT_mask);
        end        

        try
            temp_ssim = ssim_index(u, u0_GT);   
        catch ME
            temp_ssim = NaN;
        end
        if (no_SLK_image_flag)
            [temp_objective_eval_for_current_u_extention] = objective_evaluation_core(u, u0_GT);
        else
            [temp_objective_eval_for_current_u_extention] = objective_evaluation_core(u, u0_GT, u_SKL_GT);
        end
        %
        if (temp_label_u_extention == 1)
            temp_objective_eval = temp_objective_eval_for_current_u_extention;
        end
        try
            if (temp_objective_eval_for_current_u_extention.Fmeasure > temp_objective_eval.Fmeasure)
                temp_objective_eval = temp_objective_eval_for_current_u_extention;
            end        
        catch ME
            %
        end
        % 
        if (break_the_u_loop_flag)
            break;
        end
    end
    
    % DIBCO part
    if not(No_DIBCO)
        try 
            temp_nam = tempname;
            [u0_GT_filename_path, u0_GT_filename_core] = fileparts(u0_GT_filename);
            u0_GT_Rweights_filename = [u0_GT_filename_path, '/', u0_GT_filename_core, '_RWeights.dat'];
            u0_GT_Pweights_filename = [u0_GT_filename_path, '/', u0_GT_filename_core, '_PWeights.dat'];
            % eval_str = ['! D:\Desktop\papers\toolboxes\DIBCO\DIBCO11_metrics.exe ', u0_GT_filename, ' ',  u_filename, ' > ', temp_nam];
            eval_str = ['! D:\Desktop\papers\toolboxes\DIBCO\DIBCO13_metrics.exe ', u0_GT_filename, ' ',  u_filename, ' ',  u0_GT_Rweights_filename, ' ',  u0_GT_Pweights_filename, ' > ', temp_nam];
            eval(eval_str);
            temp_fid = fopen(temp_nam, 'r');
            temp_text_0 = textscan(temp_fid,  '%s', 'delimiter', '\n');
            temp_text_0 = temp_text_0{end}{end};
            % temp_text = textscan(temp_text_0, '%f %f %f %f %f %f', 1, 'Delimiter', ' '); % DIBCO11_metrics
            temp_text = textscan(temp_text_0, '%f %f %f %f %f %f %f %f', 1, 'Delimiter', ' ');
            fclose(temp_fid);
            temp_objective_eval.Fmeasure = temp_text{1}; % DIBCO13_metrics
            temp_objective_eval.P_Fmeasure = temp_text{2}; % DIBCO13_metrics
            temp_objective_eval.PSNR = temp_text{3}; % DIBCO13_metrics
            temp_objective_eval.DRD = temp_text{4}; % DIBCO13_metrics
            temp_objective_eval.Recall = 0.01 * temp_text{5}; % DIBCO13_metrics
            temp_objective_eval.Precision = 0.01 * temp_text{6}; % DIBCO13_metrics
            temp_objective_eval.P_Recall = 0.01 * temp_text{7}; % DIBCO13_metrics
            temp_objective_eval.P_Precision = 0.01 * temp_text{8}; % DIBCO13_metrics            
            % temp_objective_eval.PSNR = temp_text{4};
            % temp_objective_eval.DRD = temp_text{5};
            % temp_objective_eval.MPM = temp_text{6};
        catch ME
            %
            try
                temp_objective_eval.MPM;
            catch ME
                temp_objective_eval.MPM = NaN;
            end
        end
    else
        try
            temp_objective_eval.MPM;
        catch ME
            temp_objective_eval.MPM = NaN;
        end
    end
    
    % 2
	sum_temp_p = [sum_temp_p temp_objective_eval.Precision];
    sum_temp_r = [sum_temp_r temp_objective_eval.Recall];
    sum_temp_f = [sum_temp_f temp_objective_eval.Fmeasure]; 
    
	sum_temp_PSNR = [sum_temp_PSNR temp_objective_eval.PSNR];
    sum_temp_DRD = [sum_temp_DRD temp_objective_eval.DRD];
    sum_temp_MPM = [sum_temp_MPM 1000 * temp_objective_eval.MPM];   
    sum_temp_NRM = [sum_temp_NRM 100 * temp_objective_eval.NRM];     
    
    sum_temp_pseudo_p = [sum_temp_pseudo_p temp_objective_eval.P_Precision];
    sum_temp_pseudo_r = [sum_temp_pseudo_r temp_objective_eval.P_Recall];
    sum_temp_pseudo_f = [sum_temp_pseudo_f temp_objective_eval.P_Fmeasure];     
    
    sum_temp_sens = [sum_temp_sens temp_objective_eval.Sensitivity];
    sum_temp_spec = [sum_temp_spec temp_objective_eval.Specificity]; 
    sum_temp_BCR = [sum_temp_BCR temp_objective_eval.BCR];
    sum_temp_BER = [sum_temp_BER temp_objective_eval.BER];
    sum_temp_s_f_measure = [sum_temp_s_f_measure temp_objective_eval.SFmeasure];
    sum_temp_accu = [sum_temp_accu temp_objective_eval.GAccuracy];
    
	sum_temp_ssim = [sum_temp_ssim temp_ssim]; 
	
    %
    sum_temp = sum_temp + 1;
    
    % write to the file 3
    fprintf(fidparamout, '%16s %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', u0name, ...
        temp_objective_eval.Precision, temp_objective_eval.Recall, temp_objective_eval.Fmeasure, ... 
        temp_objective_eval.PSNR, temp_objective_eval.DRD, 1000 * temp_objective_eval.MPM, 100 * temp_objective_eval.NRM, ... 
        temp_objective_eval.P_Recall, temp_objective_eval.P_Fmeasure, ... 
        temp_objective_eval.Sensitivity, temp_objective_eval.Specificity, temp_objective_eval.BCR, temp_objective_eval.BER, ...
        temp_objective_eval.SFmeasure, temp_objective_eval.GAccuracy, temp_ssim);
    
end
% write the avearges 4
avg_temp_p = mean(sum_temp_p);
avg_temp_r = mean(sum_temp_r);
avg_temp_f = mean(sum_temp_f);
avg_temp_f_DIBCO = 200 * (avg_temp_p * avg_temp_r) / (avg_temp_p + avg_temp_r);

avg_temp_PSNR = mean(sum_temp_PSNR);
avg_temp_DRD = mean(sum_temp_DRD);
avg_temp_MPM = mean(sum_temp_MPM);
avg_temp_NRM = mean(sum_temp_NRM);

avg_temp_pseudo_p = mean(sum_temp_pseudo_p);
avg_temp_pseudo_r = mean(sum_temp_pseudo_r);
avg_temp_pseudo_f = mean(sum_temp_pseudo_f);
avg_temp_pseudo_f_DIBCO = 200 * (avg_temp_p * avg_temp_pseudo_r) / (avg_temp_p + avg_temp_pseudo_r);

avg_temp_sens = mean(sum_temp_sens);
avg_temp_spec = mean(sum_temp_spec);
avg_temp_BCR = mean(sum_temp_BCR);
avg_temp_BER = mean(sum_temp_BER);
avg_temp_s_f_measure = mean(sum_temp_s_f_measure);
avg_temp_accu = mean(sum_temp_accu);

avg_temp_ssim = mean(sum_temp_ssim);
% write the avearges 4': excluding NaNs.
avg_exp_nan_temp_p = mean_except_nan(sum_temp_p);
avg_exp_nan_temp_r = mean_except_nan(sum_temp_r);
avg_exp_nan_temp_f = mean_except_nan(sum_temp_f);

avg_exp_nan_temp_PSNR = mean_except_nan(sum_temp_PSNR);
avg_exp_nan_temp_DRD = mean_except_nan(sum_temp_DRD);
avg_exp_nan_temp_MPM = mean_except_nan(sum_temp_MPM);
avg_exp_nan_temp_NRM = mean_except_nan(sum_temp_NRM);

avg_exp_nan_temp_pseudo_r = mean_except_nan(sum_temp_pseudo_r);
avg_exp_nan_temp_pseudo_f = mean_except_nan(sum_temp_pseudo_f);

avg_exp_nan_temp_sens = mean_except_nan(sum_temp_sens);
avg_exp_nan_temp_spec = mean_except_nan(sum_temp_spec);
avg_exp_nan_temp_BCR = mean_except_nan(sum_temp_BCR);
avg_exp_nan_temp_BER = mean_except_nan(sum_temp_BER);
avg_exp_nan_temp_s_f_measure = mean_except_nan(sum_temp_s_f_measure);
avg_exp_nan_temp_accu = mean_except_nan(sum_temp_accu);

avg_exp_nan_temp_ssim = mean_except_nan(sum_temp_ssim);
% write the avearges 4'': driopping the worst one.
avg_exp_worst_temp_p = mean_except_the_worst(sum_temp_p);
avg_exp_worst_temp_r = mean_except_the_worst(sum_temp_r);
avg_exp_worst_temp_f = mean_except_the_worst(sum_temp_f);

avg_exp_worst_temp_PSNR = mean_except_the_worst(sum_temp_PSNR);
avg_exp_worst_temp_DRD = mean_except_the_worst(sum_temp_DRD, 1);
avg_exp_worst_temp_MPM = mean_except_the_worst(sum_temp_MPM, 1);
avg_exp_worst_temp_NRM = mean_except_the_worst(sum_temp_NRM, 1);

avg_exp_worst_temp_pseudo_r = mean_except_the_worst(sum_temp_pseudo_r);
avg_exp_worst_temp_pseudo_f = mean_except_the_worst(sum_temp_pseudo_f);

avg_exp_worst_temp_sens = mean_except_the_worst(sum_temp_sens);
avg_exp_worst_temp_spec = mean_except_the_worst(sum_temp_spec);
avg_exp_worst_temp_BCR = mean_except_the_worst(sum_temp_BCR);
avg_exp_worst_temp_BER = mean_except_the_worst(sum_temp_BER, 1);
avg_exp_worst_temp_s_f_measure = mean_except_the_worst(sum_temp_s_f_measure);
avg_exp_worst_temp_accu = mean_except_the_worst(sum_temp_accu);

avg_exp_worst_temp_ssim = mean_except_the_worst(sum_temp_ssim);

% write the std 4
std_temp_p = std(sum_temp_p);
std_temp_r = std(sum_temp_r);
std_temp_f = std(sum_temp_f);

std_temp_PSNR = std(sum_temp_PSNR);
std_temp_DRD = std(sum_temp_DRD);
std_temp_MPM = std(sum_temp_MPM);
std_temp_NRM = std(sum_temp_NRM);

std_temp_pseudo_r = std(sum_temp_pseudo_r);
std_temp_pseudo_f = std(sum_temp_pseudo_f);

std_temp_sens = std(sum_temp_sens);
std_temp_spec = std(sum_temp_spec);
std_temp_BCR = std(sum_temp_BCR);
std_temp_BER = std(sum_temp_BER);
std_temp_s_f_measure = std(sum_temp_s_f_measure);
std_temp_accu = std(sum_temp_accu);

std_temp_ssim = std(sum_temp_ssim);

% write the std 4'': driopping the worst one.
std_exp_worst_temp_p = std_except_the_worst(sum_temp_p);
std_exp_worst_temp_r = std_except_the_worst(sum_temp_r);
std_exp_worst_temp_f = std_except_the_worst(sum_temp_f);

std_exp_worst_temp_PSNR = std_except_the_worst(sum_temp_PSNR);
std_exp_worst_temp_DRD = std_except_the_worst(sum_temp_DRD, 1);
std_exp_worst_temp_MPM = std_except_the_worst(sum_temp_MPM, 1);
std_exp_worst_temp_NRM = std_except_the_worst(sum_temp_NRM, 1);

std_exp_worst_temp_pseudo_r = std_except_the_worst(sum_temp_pseudo_r);
std_exp_worst_temp_pseudo_f = std_except_the_worst(sum_temp_pseudo_f);

std_exp_worst_temp_sens = std_except_the_worst(sum_temp_sens);
std_exp_worst_temp_spec = std_except_the_worst(sum_temp_spec);
std_exp_worst_temp_BCR = std_except_the_worst(sum_temp_BCR);
std_exp_worst_temp_BER = std_except_the_worst(sum_temp_BER, 1);
std_exp_worst_temp_s_f_measure = std_except_the_worst(sum_temp_s_f_measure);
std_exp_worst_temp_accu = std_except_the_worst(sum_temp_accu);

std_exp_worst_temp_ssim = std_except_the_worst(sum_temp_ssim);

% write the std 4'': driopping the TWO worst ones.
std_exp_TWO_worsts_temp_p = std_except_TWO_worsts(sum_temp_p);
std_exp_TWO_worsts_temp_r = std_except_TWO_worsts(sum_temp_r);
std_exp_TWO_worsts_temp_f = std_except_TWO_worsts(sum_temp_f);

std_exp_TWO_worsts_temp_PSNR = std_except_TWO_worsts(sum_temp_PSNR);
std_exp_TWO_worsts_temp_DRD = std_except_TWO_worsts(sum_temp_DRD, 1);
std_exp_TWO_worsts_temp_MPM = std_except_TWO_worsts(sum_temp_MPM, 1);
std_exp_TWO_worsts_temp_NRM = std_except_TWO_worsts(sum_temp_NRM, 1);

std_exp_TWO_worsts_temp_pseudo_r = std_except_TWO_worsts(sum_temp_pseudo_r);
std_exp_TWO_worsts_temp_pseudo_f = std_except_TWO_worsts(sum_temp_pseudo_f);

std_exp_TWO_worsts_temp_sens = std_except_TWO_worsts(sum_temp_sens);
std_exp_TWO_worsts_temp_spec = std_except_TWO_worsts(sum_temp_spec);
std_exp_TWO_worsts_temp_BCR = std_except_TWO_worsts(sum_temp_BCR);
std_exp_TWO_worsts_temp_BER = std_except_TWO_worsts(sum_temp_BER, 1);
std_exp_TWO_worsts_temp_s_f_measure = std_except_TWO_worsts(sum_temp_s_f_measure);
std_exp_TWO_worsts_temp_accu = std_except_TWO_worsts(sum_temp_accu);

std_exp_TWO_worsts_temp_ssim = std_except_TWO_worsts(sum_temp_ssim);

%%%%%

% 5
fprintf(fidparamout, 'Averages       : %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f   %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', avg_temp_p, avg_temp_r, avg_temp_f, ...
    avg_temp_PSNR, avg_temp_DRD, avg_temp_MPM, avg_temp_NRM, ...
    avg_temp_pseudo_r, avg_temp_pseudo_f, ...
    avg_temp_sens, avg_temp_spec, avg_temp_BCR, avg_temp_BER, avg_temp_s_f_measure, avg_temp_accu, avg_temp_ssim);

fprintf(fidparamout, 'Averages ex NaN: %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f   %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', avg_exp_nan_temp_p, avg_exp_nan_temp_r, avg_exp_nan_temp_f, ...
    avg_exp_nan_temp_PSNR, avg_exp_nan_temp_DRD, avg_exp_nan_temp_MPM, avg_exp_nan_temp_NRM, ...
    avg_exp_nan_temp_pseudo_r, avg_exp_nan_temp_pseudo_f, ...
    avg_exp_nan_temp_sens, avg_exp_nan_temp_spec, avg_exp_nan_temp_BCR, avg_exp_nan_temp_BER, avg_exp_nan_temp_s_f_measure, avg_exp_nan_temp_accu, avg_exp_nan_temp_ssim);

fprintf(fidparamout, 'Averg ex 1 wrst: %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f   %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', avg_exp_worst_temp_p, avg_exp_worst_temp_r, avg_exp_worst_temp_f, ...
    avg_exp_worst_temp_PSNR, avg_exp_worst_temp_DRD, avg_exp_worst_temp_MPM, avg_exp_worst_temp_NRM, ...
    avg_exp_worst_temp_pseudo_r, avg_exp_worst_temp_pseudo_f, ...
    avg_exp_worst_temp_sens, avg_exp_worst_temp_spec, avg_exp_worst_temp_BCR, avg_exp_worst_temp_BER, avg_exp_worst_temp_s_f_measure, avg_exp_worst_temp_accu, avg_exp_worst_temp_ssim);

fprintf(fidparamout, 'Averg DIBCO: %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f   %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', NaN, NaN, avg_temp_f_DIBCO, ...
    NaN, NaN, NaN, NaN, ...
    NaN, avg_temp_pseudo_f_DIBCO, ...
    NaN, NaN, NaN, NaN, NaN, NaN, NaN);

fprintf(fidparamout, 'Std            : %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', ...
    std_temp_p, std_temp_r, std_temp_f, ...
    std_temp_PSNR, std_temp_DRD, std_temp_MPM, std_temp_NRM, ...
    std_temp_pseudo_r, std_temp_pseudo_f, ...
    std_temp_sens, std_temp_spec, std_temp_BCR, std_temp_BER, std_temp_s_f_measure, std_temp_accu, std_temp_ssim);

fprintf(fidparamout, 'Std ex 1 wrst  : %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', ...
    std_exp_worst_temp_p, std_exp_worst_temp_r, std_exp_worst_temp_f, ...
    std_exp_worst_temp_PSNR, std_exp_worst_temp_DRD, std_exp_worst_temp_MPM, std_exp_worst_temp_NRM, ...
    std_exp_worst_temp_pseudo_r, std_exp_worst_temp_pseudo_f, ...
    std_exp_worst_temp_sens, std_exp_worst_temp_spec, std_exp_worst_temp_BCR, std_exp_worst_temp_BER, std_exp_worst_temp_s_f_measure, std_exp_worst_temp_accu, std_exp_worst_temp_ssim);

fprintf(fidparamout, 'Std ex 2 wrsts : %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n', ...
    std_exp_TWO_worsts_temp_p, std_exp_TWO_worsts_temp_r, std_exp_TWO_worsts_temp_f, ...
    std_exp_TWO_worsts_temp_PSNR, std_exp_TWO_worsts_temp_DRD, std_exp_TWO_worsts_temp_MPM, std_exp_TWO_worsts_temp_NRM, ...
    std_exp_TWO_worsts_temp_pseudo_r, std_exp_TWO_worsts_temp_pseudo_f, ...
    std_exp_TWO_worsts_temp_sens, std_exp_TWO_worsts_temp_spec, std_exp_TWO_worsts_temp_BCR, std_exp_TWO_worsts_temp_BER, std_exp_TWO_worsts_temp_s_f_measure, ...
    std_exp_TWO_worsts_temp_accu, std_exp_TWO_worsts_temp_ssim);

% 6
status = fclose(fidparamout);



%
end












function [u_tag, u_extention, back_shift_for_u, back_shift_for_GT, GT_tag_and_ext, SKL_GT_tag_and_ext, SKL_GT_flag, text_region_flag, meddir, GT_meddir, No_DIBCO] = cehck_the_argin_infile(nargin, varargin)
% Reza

% %
u_tag = '';
u_extention = '.tif';
back_shift_for_u = 0; % 4
back_shift_for_GT = 0;
GT_tag_and_ext = '_GT.tif';
SKL_GT_tag_and_ext = '';
GT_meddir = '';
meddir = '';
text_region_flag = false;
No_DIBCO = true;

%
default_fields = {'u_tag', 'u_extention', 'back_shift_for_u', 'back_shift_for_gt', 'gt_tag_and_ext', 'skl_gt_tag_and_ext', 'gt_meddir', 'meddir', 'text_region_flag', 'No_dibco'};
for temp_label = 1:2:(nargin-3)
    parameter_name = varargin{temp_label};
    parameter_val = varargin{temp_label + 1};
    matched_field = strmatch(lower(parameter_name), default_fields);
    if isempty(matched_field)
        error('ERROR: ', 'Unknown parameter name: %s.\n', parameter_name);
    elseif (length(matched_field) > 1)
        error('ERROR: ', 'Ambiguous parameter name: %s.\n', parameter_name);
    else
        switch(matched_field)
            case 1  % u_tag
                u_tag = parameter_val;
            case 2  % u_extention
                u_extention = parameter_val;
            case 3  % back_shift_for_u
                back_shift_for_u = parameter_val;
            case 4  % back_shift_for_GT
                back_shift_for_GT = parameter_val;
            case 5  % GT_tag_and_ext
                GT_tag_and_ext = parameter_val;
            case 6  % SKL_GT_tag_and_ext
                SKL_GT_tag_and_ext = parameter_val;         
            case 7  % GT_meddir
                GT_meddir = parameter_val;  
            case 8  % meddir
                meddir = parameter_val;     
            case 9  % text_region_flag
                text_region_flag = parameter_val;    
            case 10 % No_DIBCO
                No_DIBCO = parameter_val;    
        end
    end
end

%
if not(iscell(u_extention))
    u_extention = {u_extention};
end

%
if not(iscell(GT_tag_and_ext))
    GT_tag_and_ext = {GT_tag_and_ext};
end

%
if strcmpi(GT_meddir, '')
    GT_meddir = meddir;
end

% check SKL_GT_tag_and_ext
SKL_GT_flag = true;
try 
    SKL_GT_tag_and_ext;
    if (strcmpi(SKL_GT_tag_and_ext, ''))
        SKL_GT_flag = false;
    end
catch ME
    SKL_GT_flag = false;
end


end



