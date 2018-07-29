% ===================================================================
%
% Copyright (C) 2005 The MathWorks, Inc. All rights reserved.
%
% Written By Roger Aarenstrup 2005-01-03
%
% For questions, suggestions or bug reports contact:
%
%   roger.aarenstrup@mathworks.com
%

enable = get_param(gcb,'rt_sim');
if strcmp(enable, 'on')
    set_param(gcb,'MaskEnables',{'on','on','on', 'on','on', 'on'});
    set_param(gcb,'MaskVisibilities',{'on','on','on', 'on','on', 'on'});
else
    set_param(gcb,'MaskEnables',{'on','on','on', 'off','off', 'on'});
    set_param(gcb,'MaskVisibilities',{'on','on','on', 'off','off', 'on'}); 
end