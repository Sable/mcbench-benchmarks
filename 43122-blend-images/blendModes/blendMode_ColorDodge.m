function imResult = blendMode_ColorDodge(A, B, offsetW, offsetH)
%% ColorDodge blending mode: divides the bottom layer by the inverted top 
%   layer. This lightens the bottom layer depending on the value of the top 
%   layer: the brighter the top layer, the more its color affects the 
%   bottom layer. Blending with white gives white. Blending with black does 
%   not change the image. 
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
blendMode_checkInput(nargin, a, b, func2str(@blendMode_ColorDodge));

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

ind = B == 1;
indCompl = abs(ind - 1);
tmp = min(1, A ./ (1 - B));
C = ind .* B + indCompl .* tmp;

if (((offsetW ~= 1) || (offsetH ~= 1)) || (sum(a == b) ~= length(a)))
    imResult = blendMode_CreateResult(imResult, C, offsetW, offsetH);
else
    imResult = C;
end

end