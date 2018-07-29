function ZeroOutput(output)
% Null output to GUI when error checking is not satisfied

set(output.bendmoment,'String','---');
set(output.totaldrag,'String','---');%Convert to lbf
set(output.inddrag,'String','---');%Convert to lbf
set(output.profdrag,'String','---');%Convert to lbf
set(output.range,'String','---');%Convert m to miles
set(output.volume,'String','---');%Convert to ft^3
set(output.calctime,'String','---');
set(output.lift,'String','---');  %Convert to lbf
set(output.fuelweight,'String','---');  %Convert to lbf
set(output.payload,'ForegroundColor','black','String','---');  %Convert to lbf
set(output.SCORE,'String','---');
