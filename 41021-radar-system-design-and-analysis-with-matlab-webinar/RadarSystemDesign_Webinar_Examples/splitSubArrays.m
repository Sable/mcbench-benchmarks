%Copyright 2013 The MathWorks, Inc
function [sSAnt, sSAntPlat] = splitSubArrays(sAnt)
faceSlope = 45; % Change face slope
sAnt.SubarrayNormal = [0 90 180 -90;90-faceSlope 90-faceSlope 90-faceSlope 90-faceSlope];

%% Build 4 separate arrays
epos = getElementPosition(sAnt);
aznorm = [0 90 180 -90];
for i=1:4,
    sSAnt{i} = phased.ConformalArray; %#ok<*AGROW>
    set(sSAnt{i},'ElementPosition',epos(:,(i-1)*16+(1:16)),...
                 'ElementNormal',repmat([aznorm(i);faceSlope],1,16));
    % Use isotropic antenna elements         
    sSAnt{i}.Element.FrequencyRange = sAnt.Subarray.Element.FrequencyRange;
    sSAnt{i}.Element.BackBaffled = true;
end

%% Antenna Platform
sSAntPlat = phased.Platform([2.5e4; 0; 0]);
