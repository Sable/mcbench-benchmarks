function initialized = fgrabm_isinit()
%initialized = FGRABM_ISINIT() FrameGrabM Tell if initialized
%   FGRABM_ISINIT will return true if FrameGrabM and the underlying
%   LTI-CIVIL library is already initialized.
%
%   Version 0.8 - 06 March 2012
global FGRABM

% Had we initialized?
if isempty(FGRABM)
    initialized = false;
    return;
end

initialized = FGRABM.class.getState();
