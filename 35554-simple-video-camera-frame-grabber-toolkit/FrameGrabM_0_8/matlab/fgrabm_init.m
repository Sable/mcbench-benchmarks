function fgrabm_init
%FGRABM_INIT FrameGrabM Initialization routine
%   FGRABM_INIT is the first activity that must be performed to start up
%   the underlying video capture library.  This produces a global variable
%   FGRABM that will be used by other FrameGrabM functions.  Most other
%   FrameGrabM functions will call FGRABM_INIT automatically if needed.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Declare our Java classpath:
import com.academiken.framegrabm.util.*;

% Create our persistent structure:
if isempty(FGRABM)
    FGRABM = struct();
end

% Instanciate the Java object:
if ~isfield(FGRABM, 'class')
    FGRABM.class = GrabCore;
end

% Set the default device:
if ~isfield(FGRABM, 'defaultDevice')
    FGRABM.defaultDevice = 1;
end

% Prune off formats field so formats can be refreshed:
if isfield(FGRABM, 'formats')
    FGRABM = rmfield(FGRABM, 'formats');
end

% Initialize:
FGRABM.class.init()
