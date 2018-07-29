% test example
% December 27th, 2012, By Reza FARRAHI MOGHADDAM and Hossein ZIAEI NAFCHI, Synchromedia Lab, ETS, Montreal, Canada
% April 15th, 2010, By Reza FARRAHI MOGHADDAM, Synchromedia Lab, ETS, Montreal, Canada

% original file name
u_filename = 'P03.tif';

% GT file name
u_GT_filename = 'P03_GT.tif';

% Binarized file name
u_bw_filename = 'P03_adotsu.tif';

% read files
u = double(imread(u_filename)) / 255;
% figure, imshow(u)
u_GT = [(imread(u_GT_filename)) > 0 ];
u_bw = [(imread(u_bw_filename)) > 0 ];
% figure, imshow([u_GT, u_bw])


% calculate the measures
temp_obj_eval = objective_evaluation_core(u_bw, u_GT);
fprintf(' Precision = %9.5f \n Recall = %9.5f \n F-measure (%%) = %9.5f \n Sensitivity = %9.5f \n Specificity = %9.5f \n BCR = %9.5f \n BER (%%) = %9.5f \n F-measure of sens/spec (%%) = %9.5f\n Geometric Accuracy = %9.5f\n pFMeasure (%%) = %9.5f\n NRM  = %9.5f\n PSNR  = %9.5f\n DRD  = %9.5f\n MPM (x1000) = %9.5f \n\n' , ...
    temp_obj_eval.Precision, temp_obj_eval.Recall, temp_obj_eval.Fmeasure, temp_obj_eval.Sensitivity, temp_obj_eval.Specificity, ...
    temp_obj_eval.BCR, temp_obj_eval.BER, temp_obj_eval.SFmeasure, temp_obj_eval.GAccuracy, temp_obj_eval.P_Fmeasure, temp_obj_eval.NRM, temp_obj_eval.PSNR, temp_obj_eval.DRD, 1000 * temp_obj_eval.MPM);
	
	