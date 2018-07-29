%BCSESTIMATE BlueChipStock estimation and analysis for DJIA period

addpath ./source

% Get data

load BlueChipStocks

Benchmark = 'djia';

disp('Estimation without market adjustment ...');

[DateHistory0, RetHistory0, PortHistory0, X0, Y0, Z0] ...
	= DJIAestimate(Asset, Date, Data, Map, '');

save BlueChipBacktest0  Asset Benchmark DateHistory0 RetHistory0 PortHistory0 X0 Y0 Z0

disp('Estimation with market adjustment ...');

[DateHistory, RetHistory, PortHistory, X, Y, Z] ...
	= DJIAestimate(Asset, Date, Data, Map, 'djia');

save BlueChipBacktest  Asset Benchmark DateHistory RetHistory PortHistory X Y Z
