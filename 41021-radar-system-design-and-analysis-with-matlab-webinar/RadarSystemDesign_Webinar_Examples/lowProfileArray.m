%Copyright 2013 The MathWorks, Inc
function sAnt = lowProfileArray(~,frange,~,view)
% This example shows how to model a pyramidal conformal antenna array made
% of 4 panels.
%% Replicated Array
sSubA = phased.URA([4,4],'ElementSpacing',[.05 .05]); % Subarray
set(sSubA.Element,'FrequencyRange',frange,'BackBaffled', true);
faceSlope = 45;
sAnt = phased.ReplicatedSubarray('Subarray',sSubA,'GridSize',[2 2],...
    'Layout','custom','SubarrayPosition',[.2 0 -.2 0;0 .2 0 -.2; 0 0 0 0],...
    'SubarrayNormal',[0 90 180 -90;90-faceSlope 90-faceSlope 90-faceSlope 90-faceSlope]);
if view,
    atitle = '45-deg Pyramidal Array - Isotropic Antennas'; %#ok<*NASGU>
    hax = plotArray(sAnt,atitle,[]);
end

%% Cosine antennas
sAnt.Subarray.Element = phased.CosineAntennaElement(...
                                                'FrequencyRange',frange,...
                                                'CosinePower',[8 8]);
if view,
    atitle = '45-deg Pyramidal Array - Cosine Antennas';
    hax = plotArray(sAnt,atitle,hax);
end

%% Change face slope
faceSlope = 75;
sAnt.SubarrayNormal = [0 90 180 -90;90-faceSlope 90-faceSlope 90-faceSlope 90-faceSlope];
if view,
    atitle = '75-deg Pyramidal Array - Cosine Antennas';
    hax = plotArray(sAnt,atitle,hax);
end
