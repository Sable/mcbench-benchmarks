% test example
% April 15th, 2010, By Reza Farrahi Moghaddam, Synchromedia Lab, ETS, Montreal, Canada

%
u0_filename = 'P03.tif';

% method name. Please try one of these methods: 'min_avg'; % 'avg'; 'normal';
% method = 'min_avg' is recommended for document image processing with less dependency on color.
method_name = 'min_avg'; % 'min_avg'; % 'avg'; 'normal';

u0_color = imread(u0_filename);

% ref image, using the standard method.
u0_gray_ref = double(rgb2gray(u0_color));

% main function
u0_gray = universal_color_to_gray_converter(u0_color , 'method', method_name);

% display
figure, imshow(u0_gray_ref / max(max(u0_gray_ref)))
figure, imshow(double(u0_gray) / max(max(double(u0_gray))))

% save the output
imwrite(u0_gray, [u0_filename,'-',method_name,'.tif']);