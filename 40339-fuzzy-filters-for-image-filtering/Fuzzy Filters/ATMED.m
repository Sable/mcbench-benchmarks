function [ Y ] = ATMED( X, h )
% ATMED  - The fuzzy filter with Triangular function with MEDian center
% x     - input (noisy image)
% y     - output (de-noised image)
% F     - window function, weighting function

if nargin < 2
    h=3;    % local search window size: h=3; h=5; h=7; h=9; h=11;
    f=1;    % padding value for window: f=1; f=2; f=3; f=4; f=5;
else
    f=(h-1)/2;    % padding value for window: f=1; f=2; f=3; f=4; f=5;
end
F = zeros(h*h,1);
Y  = zeros(size(X));

X = double(padarray(X,[f f],'symmetric'));
[m n ~] = size(X);

for i=1+f:1:m-f
   for j=1+f:1:n-f
       x=reshape(X(i-f:i+f, j-f:j+f),[],1);
       xmax = max(x);
       xmin = min(x);
       xmed = median(x);       
       
       F(:,:) = 0;
       if (xmed-xmin==0)||(xmax-xmed==0)
           F(:,:) = 1;
       else
           ind1 = find((x>=xmin)&(x<=xmed));
           F(ind1) = 1-(xmed-x(ind1))/(xmed-xmin);
           
           ind2 = find((x>=xmed)&(x<=xmax));
           F(ind2) = 1-(x(ind2)-xmed)/(xmax-xmed);
       end
        
       Y(i-f,j-f) = sum(sum(F.*x))/sum(sum(F));
       clear xmax xmin xmed;
   end
end
end