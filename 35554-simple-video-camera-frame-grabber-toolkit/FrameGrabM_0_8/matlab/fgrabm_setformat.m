function fgrabm_setformat(varargin)
%FGRABM_SETFORMAT([device], format) FrameGrabM Set the image capture format
%   FGRABM_SETFORMAT sets the image format according to the index of the
%   structure array returned by FGRABM_FORMATS.  Unless a device ID is
%   given for the device parameter (e.g. it is skipped), the default device
%   is used.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    fgrabm_init
end

param = 1;
if nargin == 0
    error('The format ID must be given.');
elseif nargin == 1 || nargin == 2
    % Get format index from last parameter.
    if nargin == 2
        param = 2;
    end
    device = FGRABM.defaultDevice;
    format = varargin{param};
    % In case someone starts this as a statement, the parameter is a string:
    if ischar(format)
        format = str2double(format);
    end
    
    if nargin == 2
        device = varargin{1};
        % In case someone starts this as a statement, the parameter is a string:
        if ischar(device)
            device = str2double(device);
        end
    end
else
    error('Too many parameters supplied.');
end

% Do we know the number of formats?
if ~isfield(FGRABM, 'formats') || length(FGRABM.formats) < device
    fgrabm_formats(device);
end

FGRABM.class.setFormat(device, format)
