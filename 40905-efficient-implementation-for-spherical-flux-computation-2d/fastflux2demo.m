img = zeros(128,128);
img(40:80, 60:68)=1;

response = fastflux2(img, 1:5, 1);

figure, imshow(img, []);
title('Input image');

figure, imshow(response(:,:,1),[]);
title('Output image Radius=1');
figure, imshow(response(:,:,2),[]);
title('Output image Radius=2');
figure, imshow(response(:,:,3),[]);
title('Output image Radius=3');
figure, imshow(response(:,:,4),[]);
title('Output image Radius=4');
figure, imshow(response(:,:,5),[]);
title('Output image Radius=5');
