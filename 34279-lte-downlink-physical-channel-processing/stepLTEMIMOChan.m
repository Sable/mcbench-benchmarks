function y = stepLTEMIMOChan(in, prmLTEPDSCH)
%#codegen

% Get simulation params
numTx = prmLTEPDSCH.numTx;
numRx = prmLTEPDSCH.numRx;
chanSRate = prmLTEPDSCH.chanSRate;
SampleTime = 1/chanSRate; 

EPAPathDelays = [0 30 70 90 110 190 410]*1e-9;
EPAPathGains  = [0 -1 -2 -3 -8 -17.2 -20.8];
EVAPathDelays = [0 30 150 310 370 710 1090 1730 2510]*1e-9;
EVAPathGains  = [0 -1.5 -1.4 -3.6 -0.6 -9.1 -7 -12 -16.9];
ETUPathDelays = [0 50 120 200 230 500 1600 2300 5000]*1e-9;
ETUPathGains  = [-1 -1 -1 0 0 0 -3 -5 -7];

switch prmLTEPDSCH.chanMdl
    case 'Static MIMO'
        PathDelays          = 0;
        AveragePathGains    = 0;
        MaximumDopplerShift = 0;
    case 'EPA 5Hz'
        PathDelays          = EPAPathDelays;
        AveragePathGains    = EPAPathGains;
        MaximumDopplerShift = 5;
    case 'EVA 5Hz'
        PathDelays          = EVAPathDelays;
        AveragePathGains    = EVAPathGains;
        MaximumDopplerShift = 5;
    case 'EVA 70Hz'
        PathDelays          = EVAPathDelays;
        AveragePathGains    = EVAPathGains;
        MaximumDopplerShift = 70;
    case 'ETU 70Hz'
        PathDelays          = ETUPathDelays;
        AveragePathGains    = ETUPathGains;
        MaximumDopplerShift = 70;
    case 'ETU 300Hz'
        PathDelays          = ETUPathDelays;
        AveragePathGains    = ETUPathGains;
        MaximumDopplerShift = 300;
end

% Create the MIMO Channel object
persistent chanObj;
if isempty(chanObj)
    chanObj = mimochan(numTx, numRx, SampleTime, ...
                       MaximumDopplerShift, PathDelays, AveragePathGains);
end

% Process data through MIMO Channel
y  = filter(chanObj, in);
