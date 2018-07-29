function M = gaussianMask(k,s)
% k: the scaling factor
% s: standard variance

R = ceil(3*s); % cutoff radius of the gaussian kernal  
for i = -R:R,
    for j = -R:R,
        M(i+ R+1,j+R+1) = k * exp(-(i*i+j*j)/2/s/s)/(2*pi*s*s);
    end
end

