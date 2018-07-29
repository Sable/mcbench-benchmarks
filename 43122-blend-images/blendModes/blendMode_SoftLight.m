function imResult = blendMode_SoftLight(A, B, offsetW, offsetH)
%% Soft Light blending mode: combines Multiply and Screen blend modes. 
%   This is a softer version of Hard Light. 
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
blendMode_checkInput(nargin, a, b, func2str(@blendMode_SoftLight));

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

tmp1 = 2 * A .* B + A.^2 .* (1 - 2 * B);
tmp2 = 2 * A .* (1 - B) + sqrt(A) .* (2 * B - 1);
C = ind .* tmp1 + indCompl .* tmp2;

if (((offsetW ~= 1) || (offsetH ~= 1)) || (sum(a == b) ~= length(a)))
    imResult = blendMode_CreateResult(imResult, C, offsetW, offsetH);
else
    imResult = C;
end

end