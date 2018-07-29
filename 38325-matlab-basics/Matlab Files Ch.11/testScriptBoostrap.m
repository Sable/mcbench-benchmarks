% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



% This script demonstrates the use IRDataCurve object on the basis of a
% yiedl curve bootstrapping procedure

% settlement date
settle = datenum(2011,02,16);

% maturity dates of used rates
dates = [datenum(2011,02,21) datenum(2011,03,18) datenum(2011,04,18) ...
         datenum(2011,05,18) datenum(2011,06,20) datenum(2011,07,18) ...
         datenum(2011,08,18) datenum(2011,09,19) datenum(2011,10,18) ...
         datenum(2011,11,18) datenum(2011,12,19) datenum(2012,01,18) ...
         datenum(2012,02,20) datenum(2013,02,18) datenum(2014,02,18) ...
         datenum(2015,02,18) datenum(2016,02,18) datenum(2017,02,20) ...
         datenum(2018,02,19) datenum(2019,02,18) datenum(2020,02,18) ...
         datenum(2021,02,18)]';

% quoted par rates (deposit,swap)
rates = [0.349 0.542 0.729 0.903 0.987 1.072 1.153 1.190 1.233 1.278 ...
         1.317 1.343 1.367 1.791 2.263 2.609 2.874 3.094 3.272 3.416 ...
         3.538 3.642]'/100;

% rate type
InstrumentTypes = {'Deposit';'Deposit';'Deposit';'Deposit';'Deposit';...
                   'Deposit';'Deposit';'Deposit';'Deposit';'Deposit';...
                   'Deposit';'Deposit'; 'Deposit';'Swap';'Swap';'Swap';...
                   'Swap';'Swap';'Swap';'Swap';'Swap';'Swap'};


Instruments = [repmat(settle,length(dates),1),dates,rates];

% start bootstrapping procedure
bootcurve = IRDataCurve.bootstrap('Zero', settle, ...
    InstrumentTypes, Instruments,'InterpMethod','pchip');

% bootstrapped zero rates
zeroRates = bootcurve.getZeroRates(dates);
% bootstrapped forward rates
fwdRates = bootcurve.getForwardRates(dates);


figure
hold on
plot(dates,zeroRates,'k')
plot(dates,fwdRates,'k--')
title('Bootstrapped Curve')
legend({'Forward','Zero'})
datetick('x',24,'keeplimits')