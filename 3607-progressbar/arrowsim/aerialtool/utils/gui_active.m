function ret = gui_active(optional_input)
%
% gui_active - used to implement an abort function in a GUI
%
% initially : gui_active(1)
%
% in the aplication, occaisionally 
%  EITHER  1) if (~gui_active) then ... do abort action
%  OR      2) polling gui_active(-1) will cause an error with the value 'abort_requested'
%             that can be caught with a "try-catch" block
%
% to initiate the abort (for both cases) call:  gui_active(0)
%

% the call to drawnow enable other controls to "patch-in" before the
% rest of this code execute and possibly change the "is_active" state

persistent    is_active;

if (nargin > 0)
    if (optional_input == -1) 
        drawnow;
        if (~is_active)
            error('abort_requested');
        end
    else
        prev_is_active  = is_active;
        is_active       = optional_input;
        if ((prev_is_active > 0) & (is_active == 0))
            disp('operation aborted');
        end
    end
else
    drawnow;
end

ret = is_active;

