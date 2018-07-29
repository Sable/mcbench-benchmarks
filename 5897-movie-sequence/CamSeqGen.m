function [seq] = CamSeqGen(cam,fps,method);
% CamSeqGen: Generate a movie sequence form a list of view
%
%   [seq] = CamSeqGen(cam,dt);
%   seq: the sequence to be used by CamSeqPlay
%   fps: frame per seconde
%   method: interpolation method as used in interp1. default is spline
%
% Olivier Salvado, Case Western Reserve University, 16-Sep-04 


%%
% check param
if ~exist('fps','var'),
    fps = 20;
end

if ~exist('method','var'),
    method = 'spline';
end

%%
% get the vectors
N = length(cam);
t = cam{1}.time;
time(1) = t;
pos(1,:) = cam{1}.pos;
tar(1,:) = cam{1}.tar;
dt = 1/fps;

for k=2:N,
    beg = cam{k-1}.time + dt;
    t = [ t beg:dt:cam{k}.time];
    
    time(k) = cam{k}.time;
    pos(k,:) = cam{k}.pos;
    tar(k,:) = cam{k}.tar;
end


%%
% interpolate
posi(:,1) = interp1(time',pos(:,1),t',method);
posi(:,2) = interp1(time',pos(:,2),t',method);
posi(:,3) = interp1(time',pos(:,3),t',method);

tari(:,1) = interp1(time',tar(:,1),t',method);
tari(:,2) = interp1(time',tar(:,2),t',method);
tari(:,3) = interp1(time',tar(:,3),t',method);


seq.time = t';  
seq.pos = posi;  
seq.tar = tari;  
