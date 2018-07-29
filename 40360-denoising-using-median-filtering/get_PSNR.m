function psnr=get_PSNR(im1,im2)
se=0;
if (size(im1)==size(im2))
    [s1,s2]=size(im1);
    for x=1:s1
        for y=1:s2
            se=se+(double(im1(x,y))-double(im2(x,y)))^2;
        end
    end
    mse=se/(s1*s2);
    psnr=10*log10(((s1-1)^2)/mse);
else
    psnr='Sizes of the two images are unequal';
end
