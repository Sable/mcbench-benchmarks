function F = Gaus_filter(I,sigma)

R = ceil(3*sigma); 
for i = -R:R,
    for j = -R:R,
        M(i+ R+1,j+R+1) = exp(-(i*i+j*j)/2/sigma/sigma)/(2*pi*sigma*sigma);
    end
end
M = M/sum(sum(M));  % normalize
F = xconv2(I,M);


