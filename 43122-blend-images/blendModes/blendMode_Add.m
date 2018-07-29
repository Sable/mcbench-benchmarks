function imResult = blendMode_Add(A, B, offsetW, offsetH)
%% Add blending mode: This blend mode simply adds pixel values of one layer 
%   with the other. In case of values above 1 (in the case of RGB), white 
%   is displayed. 
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

% %% Check input
% if nargin < 2
%     error('blendMode_Add:argChk', 'Wrong number of input arguments.');
% end
% 
% a = size(A);
% b = size(B);
% 
% if ((length(a) ~= length(b)) || (a(end) ~= b(end)))
%     error('blendMode_Add:argChk', 'The number of dimensions of A must be equal to the number of dimension of B.');
% end

%% Check Input
a = size(A);
b = size(B);
blendMode_checkInput(nargin, a, b, func2str(@blendMode_Add));

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

C = min(1, A + B);

if (((offsetW ~= 1) || (offsetH ~= 1)) || (sum(a == b) ~= length(a)))
    imResult = blendMode_CreateResult(imResult, C, offsetW, offsetH);
else
    imResult = C;
end

end