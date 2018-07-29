function im = IdealLowPass(im0,fc)
% fc is the circular cutoff frequency which is normalized to [0 1], that is,
% the highest radian frequency \pi of digital signals is mapped to 1.

[ir,ic,iz] = size(im0);
hr = (ir-1)/2;
hc = (ic-1)/2;
[x, y] = meshgrid(-hc:hc, -hr:hr); 

mg = sqrt((x/hc).^2 + (y/hr).^2);
lp = double(mg <= fc);

IM = fftshift(fft2(double(im0)));
IP = zeros(size(IM));
for z = 1:iz
    IP(:,:,z) = IM(:,:,z) .* lp;
end
im = abs(ifft2(ifftshift(IP)));
