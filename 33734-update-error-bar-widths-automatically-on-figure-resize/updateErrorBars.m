function updateErrorBars(h)
% Function that automatically updates error bar dimensions as a figure is
% zoomed.
%
% EXAMPLE:
% updateErrorBars()

if nargin < 1
    h = gca;
end

hh = handle(h);

prop(1) = findprop(hh,'XLim');
prop(2) = findprop(hh,'YLim');

setappdata(hh,'updateErrorBars',handle.listener(hh,prop,'PropertyPostSet',@updateErrorBars_Callback));
end

function updateErrorBars_Callback(obj, evt)

ch = findobj(evt.AffectedObject,'Type','hggroup');

for idx=1:numel(ch)
    errorbar_tick(ch(idx));
end

end