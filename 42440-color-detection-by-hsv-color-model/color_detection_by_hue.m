%%--------------------------------------------------------------------------------------------
% Copyright (C) 2010 Marco Chak-Yan YU
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are met:
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%     
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS WITHOUT ANY WARRANTY;
% WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%%--------------------------------------------------------------------------------------------


function output = color_detection_by_hue(I,sThresh,vThresh)
%% Function Help: color_grouping(I,structural_element,se_width)
%**************************************************
%This function auto recognize the 6 zones from image I using hue with
%saturation and value thresholds.
%
%Hue (degree) for different color:
%  red = 0
%  yellow = 60
%  green = 120
%  cyan = 180
%  blue = 240
%  magenta = 300
%
%**************************************************
%Output:
%**************************************************
% .black .white
% .red .yellow .green .cyan .blue .magenta
%
%**************************************************

%% Function code
if nargin > 0
    if nargin < 3
        sThresh = [0.1 1];
        vThresh = [0.1 1];
    else
        sThresh = [min(sThresh) max(sThresh)];
        vThresh = [min(vThresh) max(vThresh)];
    end
    
    % color recognization
    hsvI = rgb2hsv(I);
    hueI = round(hsvI(:,:,1)*360);
    satI = hsvI(:,:,2);
    valI = hsvI(:,:,3);
    threshI = (satI>=sThresh(1))&(satI<=sThresh(2))&(valI>=vThresh(1))&(valI<=vThresh(2));
    
    black = (valI<vThresh(1));
    white = (satI<sThresh(1))&(valI>=vThresh(1));
    red = ((hueI<=30)|(hueI>330))&threshI;
    yellow = ((hueI>30)&(hueI<=90))&threshI;
    green = ((hueI>90)&(hueI<=150))&threshI;
    cyan = ((hueI>150)&(hueI<=210))&threshI;
    blue = ((hueI>210)&(hueI<=270))&threshI;
    magenta = ((hueI>270)&(hueI<=330))&threshI;
    
    output.black = black;
    output.white = white;
    output.red = red;
    output.yellow = yellow;
    output.green = green;
    output.cyan = cyan;
    output.blue = blue;
    output.magenta = magenta;
    
end

end