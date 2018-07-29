function imResult = blendMode_LinearLight(A, B, offsetW, offsetH)
%% Linear Light blending mode: this blend mode combines Linear Dodge and 
%   Linear Burn (rescaled so that neutral colors become middle gray). 
%   Dodge applies to values of top layer lighter than middle gray, and burn
%   to darker values. The calculation simplifies to the sum of bottom layer
%   and twice the top layer, subtract 1. The contrast decreases. 
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
blendMode_checkInput(nargin, a, b, func2str(@blendMode_LinearLight));

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

tmp1 = blendMode_LinearBurn(A, 2 * B);
tmp2 = blendMode_LinearDodge(A, 2 * (B - 0.5));
C = ind .* tmp1 + indCompl .* tmp2;

if (((offsetW ~= 1) || (offsetH ~= 1)) || (sum(a == b) ~= length(a)))
    imResult = blendMode_CreateResult(imResult, C, offsetW, offsetH);
else
    imResult = C;
end

end