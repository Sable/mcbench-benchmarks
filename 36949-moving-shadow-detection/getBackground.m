function background = getBackground(sequence, bgFramesRange)
%getBackground  Computes background model for a video sequence.
%  background = getBackground(sequence, bgFramesRange) computes
%  background model for a grayscale video sequence based on the its
%  frames in the range bgFramesRange. The model (background image)
%  is computed using the median method.

%  Written by: Elad Bullkich, Idan Ilan, Yair Moshe
%  Signal and Image Processing Laboratory (SIPL)
%  Department of Electrical Engineering
%  Technion - Israel Institute of Technology
%
%  $Revision 1.0        $Date: 5/30/2012

% Reference:
% E. Bullkich, I. Ilan, Y. Moshe, Y. Hel-Or, and H. Hel-Or, "Moving Shadow
% Detection by Nonlinear Tone-Mapping," Proc. of 19th Intl. Conf. on
% Systems, Signals and Image Processing (IWSSIP 2012), Vienna, April 2012.
% [Online]  http://sipl.technion.ac.il/~yair/

height = size(sequence,1);
width = size(sequence,2);

sequence2 = zeros(height, width, bgFramesRange(2)-bgFramesRange(1)+1);
for curFrame = bgFramesRange(1):bgFramesRange(2)
    sequence2(:, :, curFrame-bgFramesRange(1)+1) = sequence(:, :, curFrame);
end

background = zeros(height, width);
for y = 1:height
    for x = 1:width
        background(y,x) = median(sequence2(y,x, :));
    end
end

end