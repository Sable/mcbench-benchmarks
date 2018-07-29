function imResult = blendMode_HardLight(A, B, offsetW, offsetH)
%% Hardlight blending mode: combines Multiply and Screen blend modes.
% Equivalent to Overlay, but with the bottom and top images swapped.
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

imResult = blendMode_Overlay(B, A, offsetW, offsetH);

end