function pos =  DECODE_MFSK(Metrics,M)

%give the most likely output, given a set of input Metrics

max_metric = Metrics(1);
pos = 0;

for i = 2:M
    if Metrics(i) > max_metric
        max_metric = Metrics(i);
        pos = i - 1;
    end
end