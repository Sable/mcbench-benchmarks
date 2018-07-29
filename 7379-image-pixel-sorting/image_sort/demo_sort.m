% This is the test script for the image_sort function.
% The pixels of an image are sorted.
% Author: Atakan Varol

I = imread('exp_curve4.bmp');          % Read the image
I_not = uint8(not(I));                 % WB conversion
I_edge = edge(I_not,'sobel');          % Edge detection
[y x] = find(I_edge);                  % determine the edge indices of the images (ones in binary image)


data_ordered = image_sort(x,y);        % sort the pixels

% Plot the results
subplot 211
plot(x,y), title('Unsorted Image')
subplot 212, 
plot(data_ordered(:,1), data_ordered(:,2)), title('Sorted Image')