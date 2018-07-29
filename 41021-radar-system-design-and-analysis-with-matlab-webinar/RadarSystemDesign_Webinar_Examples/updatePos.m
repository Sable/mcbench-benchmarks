%Copyright 2013 The MathWorks, Inc
function [AzEl,face,antpos,tgtpos,range] = updatePos(sSAntPlat,sTgtMotion,dt,ii)
%% Update antenna position (uniform circular motion)
sSAntPlat.Velocity = 2.5e4*[-sin(ii*dt*pi); cos(ii*dt*pi); 0];
antpos = step(sSAntPlat,dt*pi);

%% Update target position
tgtpos = step(sTgtMotion,1);

%% Range and angle between antenna and target
[range,AzEl] = rangeangle(tgtpos,antpos);

%% Figure out which face(s) of the array are illuminated
faceSlope = 45;
if (AzEl(2) < faceSlope) && (AzEl(2) >= 0)
    if (AzEl(1) > -30) && (AzEl(1) <= 30)
        face = [true false false false];
    elseif (AzEl(1) > 30) && (AzEl(1) <= 60)
        face = [true true false false];
    elseif (AzEl(1) > 60) && (AzEl(1) <= 120)
        face = [false true false false];
    elseif (AzEl(1) > 120) && (AzEl(1) <= 150)
        face = [false true true false];
    elseif (AzEl(1) > 150) || (AzEl(1) <= -150)
        face = [false false true false];
    elseif (AzEl(1) > -150) && (AzEl(1) <= -120)
        face = [false false true true];
    elseif (AzEl(1) > -120) && (AzEl(1) <= -60)
        face = [false false false true];
    else
        face = [true false false true];
    end
elseif AzEl(2) >= faceSlope
    face = [true true true true];
else
    face = [false false false false];
end

