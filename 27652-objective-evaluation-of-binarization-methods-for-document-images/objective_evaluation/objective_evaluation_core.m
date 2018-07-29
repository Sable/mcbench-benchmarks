function temp_obj_eval = objective_evaluation_core(u, u0_GT, u_SKL_GT)
% This function can be used to evaluate objectively the performance of binarization methods for document image.
%
% December 27th, 2012, By Reza FARRAHI MOGHADDAM and Hossein ZIAEI NAFCHI, Synchromedia Lab, ETS, Montreal, Canada
% May 17th, 2010, By Reza FARRAHI MOGHADDAM, Synchromedia Lab, ETS, Montreal, Canada
% 
% The implemented measures are as follows [1]:
% Precision: 
% Recall: 
% Fmeasure: (used as one of the measures in "Document Image Binarization Contest" (DIBCO'09) in ICDAR'09)
% Sensitivity: (the same as Recall)
% Specificity:
% BCR: The balanced classification rate
% AUC: (The same as BCR)
% BER: The balanced error rate
% SFmeasure: F-measure based on sensitivity and specificity
% Accuracy: 
% GAccuracy: Geometric mean of sens and spec (to be used as the measure in "Quantitative evaluation of binarization algorithms of images of historical documents with bleeding noise" contest in ICFHR'10)
% pFMeasure: pseudo F-Measure
% NRM: Negative rate metric
% PSNR: Peak signal-to-noise ratio
% DRD: Distance reciprocal distortion metric [2]
% MPM: Misclassification penalty metric [3]
%
% [1] M. Sokolova and G. Lapalme, A systematic analysis of performance
% measures for classification tasks, Information Processing & Management,
% 45, pp. 427-437, 2009. DOI: 10.1016/j.ipm.2009.03.002
%
% [2] H. Lu, A. C. Kot, Y. Q. Shi, Distance-Reciprocal Distortion Measure
% for Binary Document Images, IEEE Signal Processing Letters, vol. 11, 
% no. 2, pp. 228-231, 2004.
%
% [3] D. P. Young, J. M. Ferryman, PETS Metrics: On-Line Performance 
% Evaluation Service, ICCCN '05 Proceedings of the 14th International 
% Conference on Computer Communications and Networks, pp. 317-324, 2005.%
%
% USAGE:
% temp_obj_eval = objective_evaluation_core(u, u0_GT, u0_skl_GT);
% where
%       u is: the input binarized image to be evaluated.
%       u0_GT: is the ground-truth binarized image.
%		u0_skl_GT: is an optional input for the ground-truth skeleton of u0_GT. If not specified, the skeleton is automatically calculated using the thininng method.
%       temp_obj_eval: is the output. The measures can be reached as the fields of temp_obj_eval. For example:
%           fprintf('Precision = %9.5f\n', temp_obj_eval.Precision);
%

% get Precision and others
if (nargin == 2)
    temp_obj_eval = my_compute_precision_recall_fmeasure(u, u0_GT);
else
    temp_obj_eval = my_compute_precision_recall_fmeasure(u, u0_GT, u_SKL_GT);
end

 

   
end