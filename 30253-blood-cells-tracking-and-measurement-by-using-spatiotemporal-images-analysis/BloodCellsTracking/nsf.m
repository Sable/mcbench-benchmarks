function Idenoised = nsf(I)
% noise supression function(NSF-Eq.(6)in the paper) is used to denoise the enhanced image.
warning off;
I = double(I);
h = fspecial('gaussian');
I = imfilter(I,h);
[m,n] = size(I);
[count,x] = hist(I(:),100);   
[d,ind] = max(count);
t = 2;
x1 = x(1:ind+t);
count1 = count(1:ind+t);
coeffs = create_Fit(x1,count1);

for i = 1:m
    for j = 1:n       
        [d,ind] = min(abs(I(i,j)-x));  
        g(i,j) = shrinkage(I(i,j),ind,count,coeffs);        
    end
end

Idenoised = I.* g;
end

function g = shrinkage(x,k,count,coeffs)
%             (1-w)*p(x|noise)
% g = 1 - -----------------------------
%          w*p(x|edge)+(1-w)*p(x|noise)

a1 = coeffs(1);  
b1 = coeffs(2);
c1 = coeffs(3);

if x < b1
    g = 0.05;  
else
    p1 = a1*exp(-((x-b1)^2/c1^2));
    
    p = count(k);         
    g = abs(1 - (p1/p));
end
end