clc; clear;
%Read the decoded frames
img_folder_decoded = 'decoded\4500kbit\';
img_files_decoded = dir([img_folder_decoded '\*.bmp']);

%Read the source frames
img_folder_encoded = 'source\';
img_files_encoded = dir([img_folder_encoded '\*.bmp']);

%Read the number of frames decoded and use it to calculate the PSNR
PSNR_Val = zeros(numel(img_files_decoded),1);
for i = 1:numel(img_files_decoded)
    PSNR_Val(i) = PSNRCals([img_folder_encoded img_files_encoded(i).name]...
        ,[img_folder_decoded img_files_decoded(i).name]);
end
display(sum(PSNR_Val)/numel(img_files_decoded));