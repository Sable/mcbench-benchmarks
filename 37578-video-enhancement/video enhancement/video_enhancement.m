% Description : This is a matlab file for video enhancement. 
% The following file works with color, b&w images. 
% User defined functions : 1) image_enhancement_sw - modified retinex algorithm
%                          2) gray_level_images    - contrast enhancement
% Author : Vijay Sridharan. 
% Date   : 20th July, 2012. 
%% Video Enhancement for color and black and white images    
video = VideoReader('air.avi');
    for i = 1:video.NumberOfFrames
        img = read(video,i);
        imwrite(img,sprintf('img%d.jpg',i));
    end
    fprintf('Please wait....');
    filebase = dir('*.jpg');                      % If you are using a continous frame of images, start from here. 
    num_files = numel(filebase);
    images = cell(1, num_files);
     MS=cell(1,num_files);
     for k = 1:num_files
         images{k} = imread(filebase(k).name);
         [rows columns color]=size(images{1});
         if (color==3)
             MS{k}=image_enhancement_sw(images{k});
             M(k)=im2frame(MS{k});
         else
             MS{k}=gray_level_images(images{k}); % For gray level images, movie/implay doesn't work. So, I would suggest you
                                                 % to download FIJI or ImageJ to view the sequence of images as Videos. The                                                                                               
         end                                     % default frame rate is 8fps in FIJI
     end
movie(M)