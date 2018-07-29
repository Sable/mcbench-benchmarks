function rec
global rec_h recs Fs r h_auto
h=rec_h;
if get(h,'value')
    % start recodring
    r = audiorecorder(Fs, 16, 1);
    record(r); % record data
else
    % stop recording
    stop(r);
    s = getaudiodata(r); % get data
    s=s-mean(s);
    recs=s';
    % autoplay:
    if get(h_auto,'value')
        pause(0.3);
        pl;
    end
end




