function [pdetect,tetadetect,Accumulator] = houghline(Imbinary,pstep,tetastep,thresh)
%HOUGHLINE - detects lines in a binary image using common computer vision operation 
%known as the Hough Transform. This is just a standard implementaion of Hough transform 
%for lines in order to show how this method works.
%
%Comments:
%       Function uses Standard Hough Transform to detect Lines in a binary image.
%       According to the Hough Transform, each pixel in image space
%       corresponds to a line in Hough space and vise versa.This function uses
%       polar representation of lines i.e. x*cos(teta)+y*sin(teta)=p to detect 
%       lines in binary image. upper left corner of image is the origin of polar coordinate
%       system.
%
%Usage: [pdetect,tetadetect,Accumulator] = houghline(Imbinary,pstep,tetastep,thresh)
%
%Arguments:
%       Imbinary - A binary image. image pixels that have value equal to 1 are
%                  interested pixels for HOUGHLINE function.
%       pstep    - Interval for radius of lines in polar coordinates.
%       tetastep - Interval for angle of lines in polar coordinates.
%       thresh   - A threshold value that determines the minimum number of
%                  pixels that belong to a line in image space. threshold must 
%                  be bigger than or equal to 3(default).
%
%Returns:
%       pdetect     - A vactor that contains radius of detected lines in
%                     polar coordinates system.
%       tetadetect  - A vector that contains angle of detcted lines in
%                     polar coordinates system.
%       Accumulator - The accumulator array in Hough space.
%
%Written by :
%       Amin Sarafraz
%       Computer Vision Online 
%       http://www.computervisiononline.com
%       amin@computervisiononline.com
%
% Acknowledgement: Thanks to Nicolas HUOT for his comment
%
%May 5,2004         - Original version
%November 24,2004   - Modified version,slightly faster and better performance.
%August 31, 2012    - Error handling/ Better documentation/ Evaluating the comment by Nicolas HUOT
                          

if nargin == 3
    thresh = 3;
end

if thresh < 3
    error('HOUGHLINE:: Threshold must be bigger than or equal to 3')
end

p = 1:pstep:sqrt((size(Imbinary,1))^2+(size(Imbinary,2))^2);
teta = 0:tetastep:180-tetastep;

%Voting
Accumulator = zeros(length(p),length(teta)); % initialize the accumulator
[yIndex xIndex] = find(Imbinary); % find x,y of edge pixels
for cnt = 1:numel(xIndex)
    Indteta = 0;
    for tetai = teta*pi/180
        Indteta = Indteta+1;
        roi = xIndex(cnt)*cos(tetai)+yIndex(cnt)*sin(tetai);
        if roi >= 1 && roi <= p(end)
            temp = abs(roi-p);
            mintemp = min(temp);
            Indp = find(temp == mintemp);
            Indp = Indp(1);
            Accumulator(Indp,Indteta) = Accumulator(Indp,Indteta)+1;
        end
    end
end

% Finding local maxima in Accumulator
AccumulatorbinaryMax = imregionalmax(Accumulator);
[Potential_p Potential_teta] = find(AccumulatorbinaryMax == 1);
Accumulatortemp = Accumulator - thresh;
pdetect = [];tetadetect = [];
for cnt = 1:numel(Potential_p)
    if Accumulatortemp(Potential_p(cnt),Potential_teta(cnt)) >= 0
        pdetect = [pdetect;Potential_p(cnt)];
        tetadetect = [tetadetect;Potential_teta(cnt)];
    end
end

% Calculation of detected lines parameters(Radius & Angle).
pdetect = pdetect * pstep;
tetadetect = tetadetect *tetastep - tetastep;