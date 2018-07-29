%% Example for updateErrorBars.m

%% Normal behaviour
hFig = figure();
hAx = gca;
errorbar(1:10,36:45,1.5:-0.1:0.6)
snapnow();

% Zoom in without updateErrorBars
set(hAx,'XLim',[4.8 7.2])

%% Using updateErrorBars
hFig2 = figure();
hAx2 = gca;
errorbar(1:10,36:45,1.5:-0.1:0.6)
updateErrorBars()
snapnow();

% Now zoom in and watch the width of the error bars
set(hAx2,'XLim',[4.8 7.2])
snapnow();
