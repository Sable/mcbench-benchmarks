function capturing = fgrabm_iscapturing(varargin)
%capturing = FGRABM_ISCAPTURING([device]) FrameGrabM Tell if capturing
%   FGRABM_ISCAPTURING returns true if a capture operation is underway.
%   A capture operation should be underway if FGRABM_START([device]) was
%   called.  If device is not specified, then the default device is used.
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

capturing = FGRABM.class.getOperState(device);
