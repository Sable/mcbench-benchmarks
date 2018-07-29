% Copyright 2013 The MathWorks, Inc
%% Setup Visuals
if m == 1
    sScope = dsp.TimeScope('SampleRate',fs,...
        'TimeSpan',10/prf,'Grid',true,...
        'LayoutDimensions',[1 2],'MaximizeAxes','off', ...
        'Position',[371 646 1000 409],'NumInputPorts',2);
    set(sScope,'ActiveDisplay',2,'YLabel','Magnitude','Title','Collected Signal')
    set(sScope,'ActiveDisplay',1,'YLabel','Magnitude','Title','Transmitted Signal')
    show(sScope);
    %% Range Doppler Map
    figure('WindowStyle','docked')
    hrdmap = imagesc(sgrid,rgrid,abs(rdmap));
    xlabel('Speed (m/s)'); ylabel('Range (m)'); title('Range Doppler Map');

    %% Detection and Range Estimation
    figure('WindowStyle','docked')
    tgtrange = [NaN NaN NaN]; pmax = tgtrange;
    hold on
    for n=1:3,
        plot(sTgtMotion{n}.InitialPosition(1)*ones(2,1),[0 7e-5],'r:')
        htext(n) = text(tgtrange(n),1.05*pmax(n),int2str(tgtrange(n))); %#ok<*SAGROW>
    end
    legend('Initial Range')
    xlabel('Range (m)'); ylabel('Magnitude'); title ('Estimated Range')
    hbar = sqrt(threshold)*ones(numel(fast_time),1);
    hline = plot(range_gates,[hbar hbar]); % Threshold
    offset = numel(sMFilt.Coefficients)-1;
end

%% Stream Signals
step(sScope,abs(s),abs(rsig)); % Ctrl + A to scale axis limits
set(hrdmap,'CData',abs(fliplr(rdmap)))
drawnow
set(hline(2),'YData',[intpulses(offset:numel(fast_time)); NaN*ones(offset-1,1)])
for n=1:3,
    set(htext(n),'String',int2str(tgtrange(n)),'Position',[tgtrange(n) 1.05*pmax(n)]);
end

