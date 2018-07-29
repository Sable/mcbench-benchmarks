function formatIndex = fgrabm_getformat(varargin)
%formatIndex = FGRABM_GETFORMAT([device]) FrameGrabM Get the capture format
%   FGRABM_GETFORMAT returns the image format index that corresponds with
%   the structure returned by FGRABM_FORMATS([device]).  If device is not
%   specified, then the default device is used.
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

formatIndex = FGRABM.class.getFormat(device);
