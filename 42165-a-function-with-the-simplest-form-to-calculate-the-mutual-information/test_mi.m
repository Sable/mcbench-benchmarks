function test_mi
% Test for the function to calculate the MI between two images
% just run it!
 img = imread('peppers.png');
 im2 = img(:,:,2); % green component of the RGB image
 im3 = img(:,:,3); % blue  component of the RGB image
 [h w] = size(im2);
 p2 = im2(h/2-50:h/2+50,w/2-50:w/2+50);         % a patch in the middle of im2
 f = [];
 for t = -50:50
     p3 = im2(h/2-50:h/2+50,t+w/2-50:t+w/2+50); % a patch around the middle of im3
     f = [ f cal_mi(p2,p3)];
 end
 figure,imshow(im2),title('the Green component of the RGB image');
 figure,imshow(im3),title('the Blue component of the RGB image');
 figure,plot(f),title('the MI value between two patchs from the left to right side');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = cal_mi(I1,I2)
% A function with the simplest form to
% compute Mutual Information of two images
% written by HU Xiubing
% Wuhan University,China
%  huxb@whu.edu.cn
size1 = size(I1);
size2 = size(I2);
if  ne(size1,size2)
    error('Please enter the same size images ! ');
end

I1 = I1(:);
I2 = I2(:);

min1 = min(I1); max1 = max(I1);
min2 = min(I2); max2 = max(I2);
N1 = max1 - min1 + 1;  % Grayscale of the image I1 
N2 = max2 - min2 + 1;  % Grayscale of the image I2
  
ht = zeros(N1,N2);     % Joint histogram    
for n = 1:length(I1);   
    ht(I1(n)-min1+1,I2(n)-min2+1) = ht(I1(n)-min1+1,I2(n)-min2+1) + 1;
end
    
ht = ht/length(I1);  % normalized joint histogram
ym = sum(ht );       % sum of the rows of normalized joint histogram
xm = sum(ht');       % sum of columns of normalized joint histogran
    
Hy   =      sum(ym.*log2(ym+(ym==0)));
Hx   =      sum(xm.*log2(xm+(xm==0)));
h_xy =  sum(sum(ht.*log2(ht+(ht==0)))); % joint entropy
    
f = -(Hx+Hy)/h_xy;   % Mutual information