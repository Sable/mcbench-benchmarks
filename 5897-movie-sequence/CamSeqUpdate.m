function [cam] = CamSeqUpdate(cam,period);
% CamSeqUpdate: update a list of views
%
%   [cam] = CamSeqUpdate(cam,period);
%   cam: a structure to list the views to be used by CamSeqGen
%   period: time between new view and previous one
%
%   usage:
%   1. [cam] = CamSeqUpdate([]); to initialize the strucure with the
%   current view
%   2. using the camera toolbar, position the camera for the next view
%   3. [cam] = CamSeqUpdate(cam,3); add the current view 3 secondes after
%   the previous one in the structure
%   4. repeat 2./3. until all the views are defined.
%   5. use CamSeqGen to generate a sequence from the list of views
%   6. use CamSeqPlay to play the sequence and/or generate an .avi file
%
% Olivier Salvado, Case Western Reserve University, 16-Sep-04 

%%
% param check
N = length(cam);
if nargin<2,
    period = 2;   % add 2 sec
else
    if period<0,
        disp('!! period should be >0')
        return
    end
end

%%
% update the list
if N==0,    % if it is the first create the structure
    cam{N+1}.time = 0 ;
else
    cam{N+1}.time = cam{N}.time + period;
end
cam{N+1}.pos = campos;
cam{N+1}.tar = camtarget;


