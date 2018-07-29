clear all;

[X,Y,Z] = peaks(100);
X = single(X);
Y = single(Y);
Z = single(Z);
Z_index = uint8((Z - min(Z(:))) * (255 / (max(Z(:)) - min(Z(:)))));
Z_color = uint8(ind2rgb(Z_index, hsv(256)*256));
Z_color_multiframe = reshape([Z_color(:)*0.2 Z_color(:)*0.6 Z_color(:)], 100, 100, 3, 3);
Z_color_noisy = uint8(single(Z_color) + rand(100, 100, 3).*50);

% 8-bit, grayscale image
saveastiff(uint8(Z_index), 'Z_uint8.tif');

% Lossless LZW compression
options.comp = 'lzw';
saveastiff(uint8(Z_index), 'Z_uint8_LZW.tif', options);
options.comp = 'no';

% Ask a question if the file is already exist
options.ask = true;
saveastiff(uint8(Z_index), 'Z_uint8_LZW.tif', options);
options.ask = false;

% Allow message printing.
options.message = true;
saveastiff(uint8(Z_index), 'Z_uint8_LZW.tif', options);
options.message = false;

% 16-bit, grayscale image
saveastiff(uint16(Z_index), 'Z_uint16.tif');

% 32-bit single, grayscale image
saveastiff(Z, 'Z_single.tif');

% RGB color image
options.color = true;
saveastiff(Z_color, 'Z_rgb.tif', options);
options.color = false;

% Save each R, G and B chanels of the color image, separately.
saveastiff(Z_color, 'Z_rgb_channel.tif');

% Save the multi-frame RGB color image
options.color = true;
saveastiff(Z_color_multiframe, 'Z_rgb_multiframe.tif', options);
options.color = false;

% Save the noise-added RGB color image
options.color = true;
saveastiff(Z_color_noisy, 'Z_rgb_noisy.tif', options);
options.color = false;

% 32-bit single, 50x50x50 volume data
saveastiff(single(rand(50, 50, 50)), 'volume_50x50x50.tif');

% Append option is ignored if path dose not exist.
options.append = true;
saveastiff(Z_index, 'Z_uint8_append.tif', options);
options.append = false;

% You can append any type of image to an existing tiff file.
options.append = true;
saveastiff(Z, 'complex_frame.tif');
saveastiff(single(rand(10, 10, 3)), 'complex_frame.tif', options);
options.color = true;
saveastiff(Z_color_multiframe, 'complex_frame.tif', options);
options.color = false;
options.append = false;

% Load multiframe tiff
multiframe = loadtiff('volume_50x50x50.tif');
complexframe = loadtiff('complex_frame.tif');