function imageOut = setImageToGray( imageIn )
%SETIMAGETOGRAY does checking to deem if image is already in gray or is
%required to be set to gray
if (length(size(imageIn)) == 3)
    imageOut = rgb2gray(imageIn);
else
    imageOut = imageIn;
end

end

