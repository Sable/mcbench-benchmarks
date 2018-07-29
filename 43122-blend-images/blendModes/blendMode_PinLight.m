function imResult = blendMode_PinLight(A, B, offsetW, offsetH)
%% Pin Light blending mode: replaces colors depending on the brightness of 
%   the blend color. If the blend color is more than 50% brightness and the
%   base color is darker than the blend color, then the base color is 
%   replaced with the blend color. If the blend color is less than 50% 
%   brightness and the base color is lighter than the blend color, then the
%   base color is replaced with the blend color. 
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
blendMode_checkInput(nargin, a, b, func2str(@blendMode_PinLight));

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

ind = B < 0.5;
indCompl = abs(ind - 1);

tmp1 = blendMode_Darken(A, 2 * B);
tmp2 = blendMode_Lighten(A, 2 * (B - 0.5));
C = ind .* tmp1 + indCompl .* tmp2;

if (((offsetW ~= 1) || (offsetH ~= 1)) || (sum(a == b) ~= length(a)))
    imResult = blendMode_CreateResult(imResult, C, offsetW, offsetH);
else
    imResult = C;
end

end