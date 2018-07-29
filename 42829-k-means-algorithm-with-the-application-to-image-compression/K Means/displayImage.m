function displayImage(I, XCompressed, K)

% Displays best final compressed image.

% Display the original image 
subplot(1, 2, 1);
imagesc(I); 
title('Original');

% Display compressed image side by side
subplot(1, 2, 2);
imagesc(XCompressed)
title(sprintf('Compressed, with %d colors.', K));