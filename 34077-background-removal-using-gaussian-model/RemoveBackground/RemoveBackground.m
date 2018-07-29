input_image_path = 'image1.jpg';

im = double(imread(input_image_path));

[masked_image] = separate(im,1);

imshow(uint8(masked_image.*im))