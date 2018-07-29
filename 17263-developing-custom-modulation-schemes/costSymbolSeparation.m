function cost = costSymbolSeparation(par, sampleRate, iq)

symbols = computeSymbolsFromParams(par./[1 1 100 100], sampleRate, iq);

%%
aa = mod(angle(symbols),(pi/4));
bb = mod(abs(symbols),.25);

%%
aa = min([aa; pi/4-aa]);
bb = min([bb; .25-bb]);

%%
cost = sum([aa.^2, bb.^2]);