% test example
% September 16th, 2013, By Reza FARRAHI MOGHADDAM and Hossein ZIAEI NAFCHI, Synchromedia Lab, ETS, Montreal, Canada
%
% Description of inputs:
%
% list_of_image_files.txt: List of all imput images of the DIBCO'13 database
% ../../../../datasets/: Relative address of the database. The input images should be in a subfolder of this address with the name "input_box", and GT images in another subfolder with the name "GT".
% measures_complete_EoE_AP.txt: Output file
% _EoE_AP_Howe2012: The tag of the method under study. For example, the bin output of this method for image HW01 is HW01__EoE_AP_Howe2012.png
% .png: The extension of bin images of the method under study.
% '_estGT.tiff': The tag of the GT images (after the core part of the name). For example, for HW01, the GT image is HW01_estGT.tiff

dataset_name = 'DIBCO13';

objective_evaluation(['../../../../datasets/', dataset_name, '/list_of_image_files.txt'], 'measures_complete_EoE_AP.txt', ...
'gt_meddir', ['../../../../datasets/', dataset_name, '/GT/'], 'meddir', [''], ...
'back_shift_for_u', 4, 'u_tag', '_EoE_AP_Howe2012', 'u_extention', '.png', 'back_shift_for_gt', 4, 'gt_tag_and_ext', '_estGT.tiff');

