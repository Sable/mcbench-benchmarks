function s = snrdbadd(x,n,db)


ls = length(x);




%% signal and noise power

sigpower = 10*log10(sum(x.^2)/ls);

noisepower = 10*log10(sum(n.^2)/ls);

%%

npower = sigpower-noisepower-db;

%%

s = x+sqrt(10^(npower/10)).*n;
