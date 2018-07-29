function visualizeDiff(inputA, inputB, diff, hueA, hueB)
% images are inputA and inputB in rgb format or grayscale. Both has 
% the same size with values in range [0-255].
% diff image contains any real values, zero means zero difference

numOfPixels = size(inputA,1)*size(inputA,2);

if (size(inputA,3) ~= 1) % image is in RGB format
    % convert it into grayscale
    inputA = rgb2gray(inputA);
end

if (size(inputB,3) ~= 1) % input B is in RGB format
    % convert it into grayscale
    inputB = rgb2gray(inputB)
end

% scale input values from range 0/255 into [0,1]
inputA = double(inputA)/255;
inputB = double(inputB)/255;

% if no output color is defined, use default
if (nargin < 4)
    hueA = pi/3;
    hueB = 4*pi/3;
end

% if difference is not in double values - convert it also
diff = double(diff);
% normalize values of difference into range [-pi/4, pi/4]
diff = diff/max(max(abs(diff)))*pi/4

% here magic begins
%  - Lsh (lightness, saturation, hue) conversion
%  - M represents length of color vector
M = double(reshape(inputA + inputB,numOfPixels,1))*50;
hue = reshape(diff > 0, numOfPixels, 1);
hue = (hue * hueA) - ((hue - 1) * hueB);
saturation = reshape(diff, numOfPixels, 1);

% from hue and saturation extract standard values of Lab color space
L = M .* cos(saturation);
a = M .* abs(sin(saturation)) .* cos(hue);
b = M .* abs(sin(saturation)) .* sin(hue);

% create output image in Lab color format
output(:,:,1) = reshape(L, size(inputA,1), size(inputA,2), 1);
output(:,:,2) = reshape(a, size(inputA,1), size(inputA,2), 1);
output(:,:,3) = reshape(b, size(inputA,1), size(inputA,2), 1);

% convert image into RGB
image = Lab2RGB(output);

% image preview
imshow(image);

end