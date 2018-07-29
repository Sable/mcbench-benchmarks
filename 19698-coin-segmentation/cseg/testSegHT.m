%% HT coin segmenter demo
% a short demo for the HT coin segmenter
%% load image
img = imread('img1.png');
img = img(1:512,:);
%% benchmark
n = 10;
disp('Benchmarking coin segmenter');
disp(['-> Performing ' num2str(n) ' segmantations, please wait . . .']);
tic;
for k=1:n
  result = segScaleAccHT(img);
end
s = toc;
disp('-> Benchmarking done.');
disp(['-> Segmenting at approx. ' num2str(s/n) ' coins per second']);
%% display image and segmentation
ShowCoinSeg(img,result);

