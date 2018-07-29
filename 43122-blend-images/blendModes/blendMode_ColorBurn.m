function imResult = blendMode_ColorBurn(A, B, offsetW, offsetH)
%% Color Burn blending mode: divides the inverted bottom layer by the top
%   layer, and then inverts the result. This darkens the top layer 
%   increasing the contrast to reflect the color of the bottom layer. 
%   The darker the bottom layer, the more its color is used. Blending with 
%   white produces no difference.
% 
% Input:
%       A       -       Base Image
%       B       -       Top Image
%   offsetW     -   move picture B horizontally in respect to the top-left
%                   corner of picture A. Default value = 1.
%   offsetH     -   move picture B vertically in respect to the top-left
%                   corner of picture A. Default value = 1.
%
% Output:
%       imResult    -   Result of the blending, having the same size of the
%                       Base Image A.
% 

%% Check Input
a = size(A);
b = size(B);
blendMode_checkInput(nargin, a, b, func2str(@blendMode_ColorBurn));

if nargin < 3
    offsetW = 1;
    offsetH = 1;
end

if nargin < 4
    offsetH = 1;
end

%% Implementation
imResult = A;

if (((offsetW ~= 1) || (offsetH ~= 1)) || (sum(a == b) ~= length(a)))
    [A, B] = blendMode_ResizeImages(A, B, a, b, offsetW, offsetH);
end

ind = B == 0;
indCompl = abs(ind - 1);
tmp = max(0, 1 - (1 - A) ./ B);
C = ind .* B + indCompl .* tmp;

if (((offsetW ~= 1) || (offsetH ~= 1)) || (sum(a == b) ~= length(a)))
    imResult = blendMode_CreateResult(imResult, C, offsetW, offsetH);
else
    imResult = C;
end

end