function imResult = blendMode_CreateResult(imResult, C, offsetW, offsetH)
%% Combine the result of the blending to obtain the final image. This
%   function is used by every blend function.
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

sW = offsetW;
eW = offsetW + size(C, 2) - 1;
sH = offsetH;
eH = offsetH + size(C, 1) - 1;

if offsetW < 1
    sW = 1;
    eW = size(C, 2);
end

if offsetH < 1
    sH = 1;
    eH = size(C, 1);
end

if ((sW <= eW) && (sH <= eH))
    imResult(sH : eH, sW : eW, :) = C;
end

end