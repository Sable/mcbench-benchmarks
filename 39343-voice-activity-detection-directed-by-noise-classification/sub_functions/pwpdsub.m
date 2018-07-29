function [wpt,N,coef] = pwpdsub(sig)


wpt = wpdec(sig,3,'db6');
wpt = wpsplt(wpt,[3 4]);
wpt = wpsplt(wpt,[3 3]);
wpt = wpsplt(wpt,[3 2]);
wpt = wpsplt(wpt,[3 1]);
wpt = wpsplt(wpt,[3 0]);
wpt = wpsplt(wpt,[4 0]);
wpt = wpsplt(wpt,[4 1]);
wpt = wpsplt(wpt,[4 2]);
wpt = wpsplt(wpt,[4 3]);

N = leaves(wpt);
for i=1:length(N)
    coef{i} = abs(wpcoef(wpt,N(i)));
end