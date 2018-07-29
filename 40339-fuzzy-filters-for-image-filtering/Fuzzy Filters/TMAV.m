function [ Y ] = TMAV( X, h )
% TMED  - The fuzzy filter with Triangular function with MEDian center
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
       xmav = mean(x);
       xmv = max(xmax-xmav, xmav-xmin);
       
       F(:,:) = 0;
       if xmv==0
           F(:,:) = 1;
       else
           F = (abs(x-xmav)/xmv);
       end
        
       Y(i-f,j-f) = sum(sum(F.*x))/sum(sum(F));
       clear xmax xmin xmed xmm;

   end
end
end