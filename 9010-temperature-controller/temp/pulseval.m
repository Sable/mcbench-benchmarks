function [tt,qq] = pulseval(r)
    i = find(r.time >= 1);
    ii = find(r.time >= 1.01);
    tt = [r.time(1:i(1)); r.time(ii)];
    qq = [r.signals.values(1:i(1)); r.signals.values(ii)];