function [y0detect,x0detect,Accumulator] = houghcircle(Imbinary,r,thresh,region)
%HOUGHCIRCLE - detects circles with specific radius in a binary image.
%
%Comments:
%       Function uses Standard Hough Transform to detect circles in a binary image.
%       According to the Hough Transform for circles, each pixel in image space
%       corresponds to a circle in Hough space and vise versa. 
%       upper left corner of image is the origin of coordinate system.
%
%Usage: [y0detect,x0detect,Accumulator] = houghcircle(Imbinary,r,thresh,region)
%
%Implementation:
%       img = imread('coins.png');
%       imshow(img);
%       imgBW = edge(img);
%       rad = 24;
%       [y0detect,x0detect,Accumulator] = houghcircle(imgBW,rad,rad*pi);
%       figure;
%       imshow(imgBW);
%       hold on;
%       plot(x0detect(:),y0detect(:),'x','LineWidth',2,'Color','yellow');
%       figure;
%       imagesc(Accumulator);
%
%Arguments:
%       Imbinary - a binary image. image pixels that have value equal to 1 are
%                  interested pixels for HOUGHLINE function.
%       r        - radius of circles.
%       thresh   - a threshold value that determines the minimum number of
%                  pixels that belong to a circle in image space. threshold must be
%                  bigger than or equal to 4(default).
%       region   - a rectangular region to search for circle centers within
%                  [x,y,w,h]. Must not be larger than the image area.
%                  Default is image area
%
%Returns:
%       y0detect    - row coordinates of detected circles.
%       x0detect    - column coordinates of detected circles. 
%       Accumulator - the accumulator array in Hough space.
%
%Written by :
%       Amin Sarafraz
%       Photogrammetry & Computer Vision Devision
%       Geomatics Department,Faculty of Engineering
%       University of Tehran,Iran
%       sarafraz@geomatics.ut.ac.ir
%
%May 5,2004         - Original version
%November 24,2004   - Modified version,faster and better performance
%November 18,2005   - Modified by Peter Bone, University of Sussex, England, peterbone@hotmail.com 
%                     Much faster and better performance.
%                     Circles drawn properly (without gaps) using midpoint circle algorithm.
%                     Added region to increase speed if a center estimate is known.

imSize = size(Imbinary);

if nargin > 2 && thresh < 4
    error('threshold value must be bigger or equal to 4');
end
if nargin < 3, thresh = 4; end
if nargin < 4, region = [1,1,imSize(2),imSize(1)]; end   

%Voting
Accumulator = zeros(imSize);
xmin = region(1); xmax = xmin + region(3) - 1;
ymin = region(2); ymax = ymin + region(4) - 1;
[yIndex xIndex] = find(Imbinary);
% loop through edge points
for cnt = 1:length(xIndex) 
    xCenter = xIndex(cnt); yCenter = yIndex(cnt);
    xmx=xCenter-r; xpx=xCenter+r;
    ypx=yCenter+r; ymx=yCenter-r;    
    % skip this point if circle is completely outside region
    if xpx<xmin || xmx>xmax || ypx<ymin || ymx>ymax, continue; end   
    if ypx<=imSize(1) && ymx>=1 && xpx<=imSize(2) && xmx>=1 % circle is completely inside region    
        x = 1;
        y = r;
        d = 5/4 - r;
        Accumulator(ypx,xCenter) = Accumulator(ypx,xCenter) + 1; 
        Accumulator(ymx,xCenter) = Accumulator(ymx,xCenter) + 1;  
        Accumulator(yCenter,xpx) = Accumulator(yCenter,xpx) + 1;
        Accumulator(yCenter,xmx) = Accumulator(yCenter,xmx) + 1;
        while y > x           
            xpx = xCenter+x; xmx = xCenter-x; 
            ypy = yCenter+y; ymy = yCenter-y;
            ypx = yCenter+x; ymx = yCenter-x;
            xpy = xCenter+y; xmy = xCenter-y;
            Accumulator(ypy,xpx) = Accumulator(ypy,xpx) + 1;
            Accumulator(ymy,xpx) = Accumulator(ymy,xpx) + 1;
            Accumulator(ypy,xmx) = Accumulator(ypy,xmx) + 1;
            Accumulator(ymy,xmx) = Accumulator(ymy,xmx) + 1;
            Accumulator(ypx,xpy) = Accumulator(ypx,xpy) + 1;
            Accumulator(ymx,xpy) = Accumulator(ymx,xpy) + 1;
            Accumulator(ypx,xmy) = Accumulator(ypx,xmy) + 1;
            Accumulator(ymx,xmy) = Accumulator(ymx,xmy) + 1;
            if d < 0
                d = d + x * 2 + 3;
	            x = x + 1;
            else
                d = d + (x - y) * 2 + 5;
	            x = x + 1;
	            y = y - 1;
            end    
        end 
        if x == y
            xpx = xCenter+x; xmx = xCenter-x;
            ypy = yCenter+y; ymy = yCenter-y;
            Accumulator(ypy,xpx) = Accumulator(ypy,xpx) + 1;
            Accumulator(ymy,xpx) = Accumulator(ymy,xpx) + 1;
            Accumulator(ypy,xmx) = Accumulator(ypy,xmx) + 1;
            Accumulator(ymy,xmx) = Accumulator(ymy,xmx) + 1;
        end
    else % circle is partly outside region - need boundary checking  
        ypxin = ypx>=ymin & ypx<=ymax;
        ymxin = ymx>=ymin & ymx<=ymax;
        xpxin = xpx>=xmin & xpx<=xmax;
        xmxin = xmx>=xmin & xmx<=xmax;
        if ypxin, Accumulator(ypx,xCenter) = Accumulator(ypx,xCenter) + 1; end 
        if ymxin, Accumulator(ymx,xCenter) = Accumulator(ymx,xCenter) + 1; end  
        if xpxin, Accumulator(yCenter,xpx) = Accumulator(yCenter,xpx) + 1; end 
        if xmxin, Accumulator(yCenter,xmx) = Accumulator(yCenter,xmx) + 1; end
        x = 1;
        y = r;
        d = 5/4 - r;
        while y > x         
            xpx = xCenter+x; xpxin = xpx>=xmin & xpx<=xmax;
            xmx = xCenter-x; xmxin = xmx>=xmin & xmx<=xmax;
            ypy = yCenter+y; ypyin = ypy>=ymin & ypy<=ymax;
            ymy = yCenter-y; ymyin = ymy>=ymin & ymy<=ymax;
            ypx = yCenter+x; ypxin = ypx>=ymin & ypx<=ymax;
            ymx = yCenter-x; ymxin = ymx>=ymin & ymx<=ymax;
            xpy = xCenter+y; xpyin = xpy>=xmin & xpy<=xmax;
            xmy = xCenter-y; xmyin = xmy>=xmin & xmy<=xmax;
            if ypyin && xpxin, Accumulator(ypy,xpx) = Accumulator(ypy,xpx) + 1; end
            if ymyin && xpxin, Accumulator(ymy,xpx) = Accumulator(ymy,xpx) + 1; end
            if ypyin && xmxin, Accumulator(ypy,xmx) = Accumulator(ypy,xmx) + 1; end
            if ymyin && xmxin, Accumulator(ymy,xmx) = Accumulator(ymy,xmx) + 1; end
            if ypxin && xpyin, Accumulator(ypx,xpy) = Accumulator(ypx,xpy) + 1; end
            if ymxin && xpyin, Accumulator(ymx,xpy) = Accumulator(ymx,xpy) + 1; end
            if ypxin && xmyin, Accumulator(ypx,xmy) = Accumulator(ypx,xmy) + 1; end
            if ymxin && xmyin, Accumulator(ymx,xmy) = Accumulator(ymx,xmy) + 1; end
            if d < 0
                d = d + x * 2 + 3;
	            x = x + 1;
            else
                d = d + (x - y) * 2 + 5;
	            x = x + 1;
	            y = y - 1;
            end  
        end 
        if x == y
            xpx = xCenter+x; xpxin = xpx>=xmin & xpx<=xmax;
            xmx = xCenter-x; xmxin = xmx>=xmin & xmx<=xmax;
            ypy = yCenter+y; ypyin = ypy>=ymin & ypy<=ymax;
            ymy = yCenter-y; ymyin = ymy>=ymin & ymy<=ymax;
            if ypyin && xpxin, Accumulator(ypy,xpx) = Accumulator(ypy,xpx) + 1; end
            if ymyin && xpxin, Accumulator(ymy,xpx) = Accumulator(ymy,xpx) + 1; end
            if ypyin && xmxin, Accumulator(ypy,xmx) = Accumulator(ypy,xmx) + 1; end
            if ymyin && xmxin, Accumulator(ymy,xmx) = Accumulator(ymy,xmx) + 1; end
        end
    end
end

% Finding local maxima in Accumulator
y0detect = []; x0detect = [];
AccumulatorbinaryMax = imregionalmax(Accumulator);
[Potential_y0 Potential_x0] = find(AccumulatorbinaryMax == 1);
Accumulatortemp = Accumulator - thresh;
for cnt = 1:length(Potential_y0)
    if Accumulatortemp(Potential_y0(cnt),Potential_x0(cnt)) >= 0
        y0detect = [y0detect;Potential_y0(cnt)];
        x0detect = [x0detect;Potential_x0(cnt)];
    end
end

