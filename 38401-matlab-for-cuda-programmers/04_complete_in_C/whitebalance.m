function imageData = whitebalance(imageData)
% WHITEBALANCE forces the average image colour to be gray.
 
% Find the average values for each channel.
avg_rgb = mean(mean(imageData));
 
% Find the average gray value and compute the scaling 
% factor.
factors = max(mean(avg_rgb), 128)./avg_rgb;

% Adjust the image to the new gray value.
imageData(:,:,1) = uint8(imageData(:,:,1)*factors(1));
imageData(:,:,2) = uint8(imageData(:,:,2)*factors(2));
imageData(:,:,3) = uint8(imageData(:,:,3)*factors(3));





