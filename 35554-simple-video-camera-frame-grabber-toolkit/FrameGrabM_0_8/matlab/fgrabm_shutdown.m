function fgrabm_shutdown
%FGRABM_SHUTDOWN FrameGrabM Shutdown routine
%   FGRABM_SHUTDOWN gracefully shuts down the capture system, automatically
%   stopping any processes that are underway.  It then deallocates the
%   FGRABM global variable.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Only execute this if we had initialized:
if ~isempty(FGRABM)
    FGRABM.class.shutdown
    clear FGRABM
end
