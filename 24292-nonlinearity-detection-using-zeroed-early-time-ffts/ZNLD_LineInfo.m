% Routine to display the time for a line for ZNLDetect
%
% Matt Allen, July 2005-Aug 2006

global ZNLD

% Find Extrapolation line and add to plot
lineh = gco;
if isempty(lineh) | isempty(get(get(lineh,'Parent'),'Parent'))
    error('No Line on Figure 102 was selected. Select a line and run the script again.');
end
if get(get(lineh,'Parent'),'Parent') ~= 102;
    error('No Line on Figure 102 was selected. Select a line and run the script again.');
end

disp(['Current line is number: ',num2str(get(gco,'UserData')),', for time response starting at: ',...
    num2str(ZNLD.ts_zc(get(gco,'UserData'))),' seconds.']);