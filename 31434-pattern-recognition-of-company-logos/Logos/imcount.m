function [h, v] = imcount(input, Res, level, str)
% IMCOUNT(Inpput, Rows, Level) : applies a 2 -> 1 Dim. transform to an image
%   input = filename
%   Res  = no. of rows for input resizing
%   Level = threshold for binary conversion
% Returns:
%   [h, v] = row/col measures as 1-D series (signatures)
%
% Theophanes E. Raptis, DAT-NCSRD 2010
% http://cag.dat.demokritos.gr
% rtheo@dat.demokritos.gr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
W = imread(input);
ls = length(size(W));
if ls > 1 W = rgb2gray(W);end
W = imresize(W, [Res Res]);
figure(1)
subplot(1,2,1)
imshow(W);
title('Input Image');
subplot(1,2,2)
imhist(W);
title('Image Histogram');
% covert 2 binary
W = im2bw(W, level);
figure(2)
imagesc(W)
colormap gray
title('Binary version')
[x, y] = size(W);
% scan over rows
for j=1:y
    [c, cd] = index0(W(:,j));
    h(j) = log2(sum(abs(c).*log2(abs(c))));
end
h = h./max(nextpow2(max(h)));
% scan over cols
for i=1:x
    [c, cd] = index0(W(i,:));
    v(i) = log2(sum(abs(c).*log2(abs(c))));    
end
v = v./max(nextpow2(max(v)));
index1=norm(h-v);
index2 = norm(h+v);
disp('F. V. indices :')
disp([index1,index2])
% Variance of feature vectors
d = [];
for i=1:Res
    d = [d;h(i), v(i)];
end
w1 = 1000*sum(var(d));
w2 = 1000*sum(var(d,1));
disp('Variances :')
disp([w1,w2])
% transform centre of distribution
h = h + abs(10*index1-index2)+ 10*abs(w1-w2);
v = v + 10*index1 + index2 + 10*(w1+w2);
if strcmp(str,'gr')
figure(3)
subplot(2,1,1)
plot(h)
title('rows')
subplot(2,1,2)
plot(v)
title('columns')
figure(4)
tmax = max(max(h),max(v));
plot(h,v,'r*')
axis([0, tmax+5, 0,tmax+5])
end
end