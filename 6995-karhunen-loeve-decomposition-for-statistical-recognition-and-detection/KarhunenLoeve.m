% Karhunen-Loeve, for face recognition 
% By Alex Chirokov, Alex.Chirokov@gmail.com
clear all;

% Load the ATT image set
k = 0;
for i=1:1:40
    for j=1:1:10
        filename  = sprintf('C:\\MATLAB\\att_faces\\s%d\\%d.pgm',i,j);
        image_data = imread(filename);
        k = k + 1;
        x(:,k) = image_data(:); 
        anot_name(k,:) = sprintf('%2d:%2d',i,j);   % for plot annotations
     end;
end;
nImages = k;                     %total number of images
imsize = size(image_data);       %size of image (they all should have the same size) 
nPixels = imsize(1)*imsize(2);   %number of pixels in image
x = double(x)/255;               %convert to double and normalize
%Calculate the average
avrgx = mean(x')';
for i=1:1:nImages
    x(:,i) = x(:,i) - avrgx; % substruct the average
end;
subplot(2,2,1); imshow(reshape(avrgx, imsize)); title('mean face')
%compute covariance matrix
cov_mat = x'*x;
[V,D] = eig(cov_mat);         %eigen values of cov matrix
V = x*V*(abs(D))^-0.5;               
subplot(2,2,2); imshow(ScaleImage(reshape(V(:,nImages  ),imsize))); title('1st eigen face');
subplot(2,2,3); imshow(ScaleImage(reshape(V(:,nImages-1),imsize))); title('2st eigen face');
subplot(2,2,4); plot(diag(D)); title('Eigen values');

%image decomposition coefficients
KLCoef =  x'*V; 

%reconstruction of Image
%KLCoef(:,1:1:1)= 0;  % filtration
image_index = 12;  %index of face to be reconstructed
reconst = V*KLCoef';
diff = abs(reconst(:,image_index) - x(:,image_index));
strdiff_sum = sprintf('delta per pixel: %e',sum(sum(diff))/nPixels);
figure;
subplot(2,2,1); imshow((reshape(avrgx+reconst(:,image_index), imsize))); title('Reconstructed');
subplot(2,2,2); imshow((reshape(avrgx+x(:,image_index), imsize)));title('original');
subplot(2,2,3); imshow(ScaleImage(reshape(diff, imsize))); title(strdiff_sum);

for i=1:1:nImages
    dist(i) = sqrt(dot(KLCoef(1,:)-KLCoef(i,:), KLCoef(1,:)-KLCoef(i,:))); %euclidean
end;
subplot(2,2,4); plot(dist,'.-'); title('euclidean distance from the first face');

%2D plot of first 2 decomposition coefficients, with annotatons
% annotations have format Face:Extression, i.e 5:6 means image was taken
% from s5/6.pgm expression 6 of the person in the set s5.
figure;
show_faces = 1:1:nImages/2;
plot(KLCoef(show_faces,nImages), KLCoef(show_faces,nImages-1),'.'); title('Desomposition: Numbers indicate (Face:Expression)');
for i=show_faces
    name = anot_name(i,:);
    text(KLCoef(i,nImages), KLCoef(i,nImages-1),name,'FontSize',8);
end;

% Find similar faces,  variable 'image_index' defines face used in comparison 
image_index = 78;
for i=1:1:nImages
    dist_comp(i) = sqrt(dot(KLCoef(image_index,:)-KLCoef(i,:), KLCoef(image_index,:)-KLCoef(i,:))); %euclidean
    strDist(i) = cellstr(sprintf('%2.2f\n',dist_comp(i)));
end;
[sorted, sorted_index] = sort(dist_comp); % sort distances
figure; % open new figure
for i=1:1:9
    subplot(3,3,i); imshow((reshape(avrgx+x(:,sorted_index(i)), imsize))); title(strDist(sorted_index(i)));
end;


