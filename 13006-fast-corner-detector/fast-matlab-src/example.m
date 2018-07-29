i = imread('lab.pgm');

%Make image greyscale
if length(size(i)) == 3
	im =  double(i(:,:,2));
else
	im = double(i);
end

cs = fast_corner_detect_9(im, 30);
c = fast_nonmax(im, 30, cs);

image(im/4)
axis image
colormap(gray)
hold on
plot(cs(:,1), cs(:,2), 'r.')
plot(c(:,1), c(:,2), 'g.')
legend('9 point FAST corners', 'nonmax-suppressed corners')
title('9 point FAST corner detection on an image')

