function out = grayworld(I)
%Color Balancing using the Gray World Assumption
%   I - 24 bit RGB Image
%   out - Color Balanced 24-bit RGB Image
%
%   Gaurav Jain, 2010.

    out = uint8(zeros(size(I,1), size(I,2), size(I,3)));
    
    %R,G,B components of the input image
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);

    %Inverse of the Avg values of the R,G,B
    mR = 1/(mean(mean(R)));
    mG = 1/(mean(mean(G)));
    mB = 1/(mean(mean(B)));
    
    %Smallest Avg Value (MAX because we are dealing with the inverses)
    maxRGB = max(max(mR, mG), mB);
    
    %Calculate the scaling factors
    mR = mR/maxRGB;
    mG = mG/maxRGB;
    mB = mB/maxRGB;
   
    %Scale the values
     out(:,:,1) = R*mR;
     out(:,:,2) = G*mG;
     out(:,:,3) = B*mB;
end