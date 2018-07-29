% Testing Data points L = 495

% TO RUN
% ---------
% mydata = mgts(3000);
% n = 0;
% RMSE = ttsf(mydata)


function RMSE = ttsf(mydata)               % Test Time Series Forecasting
L=400;                                                           % No. of Test Points
for n = 0:L
    fcs(n+505) = st1(mydata, n);
end

% Plot My Data
t=1001:2000;
subplot(2, 1, 1);
plot(t, mydata)
h = legend('My Data', 1);

% Plot Forecasted & Test Data Simultaneously
t = 505:505+L;
tsd = mydata(505:505+L);
fcd = fcs(505:505+L);
subplot(2, 1, 2);
plot(t, fcd, '-k', t, tsd, ':b')
h = legend('Forecast','Test Data',2);


ErrS = 0;
for t=1:L
    ErrS = ErrS + (tsd(t) - fcd(t))^2;
end

RMSE = sqrt(ErrS/L);