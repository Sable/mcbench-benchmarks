function Gimg = gaborConvF(img,G,gWinLen)
%GIMG = GABORCONV(IMG,G,GWINLEN) Computes Gabor transform using FFT
%   G is the generated FFTed Gabor kernels using GENGABORKERNELF, GIMG will
%   be a cell the same size w/ G. GWINLEN is the radius of the origin kernel
%	Yan Ke @ THUEE, xjed09@gmail.com

[scale_num angle_num] = size(G);
Gimg = cell(scale_num,angle_num);
[fftM fftN] = size(G{1});
[imgM imgN] = size(img);

f = padarray(img,[gWinLen gWinLen],'rep');
fimg = fft2(f,fftM,fftN);
for r = 1:scale_num
	for s = 1:angle_num
		filtered = ifft2(fimg.*G{r,s}); % conv in freq domain
		cropped = filtered(gWinLen*2+(1:imgM),gWinLen*2+(1:imgN));
		Gimg{r,s} = abs(cropped); % use magnitude
	end
end

end