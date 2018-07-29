function fgrabm_start(varargin)
%FGRABM_START([device]) FrameGrabM Begin capturing process
%   FGRABM_START begins the capture process in the underlying capture
%   library.  After starting, frames will be continuously captured.  The
%   latest individual frame may then obtained by calling FGRABM_GRAB.
%   Frames not grabbed will not be retained.  If device is not specified,
%   then the default device is used.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    fgrabm_init
end

if nargin == 0
    device = FGRABM.defaultDevice;
elseif nargin == 1
    device = varargin{1};
    % In case someone starts this as a statement, the parameter is a string:
    if ischar(device)
        device = str2double(device);
    end
else
    error('Too many parameters supplied.');
end

% Cache the formats information so that grabs are quicker:
fgrabm_formats(device);

FGRABM.class.start(device);
