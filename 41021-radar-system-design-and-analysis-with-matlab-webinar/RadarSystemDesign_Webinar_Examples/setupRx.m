%Copyright 2013 The MathWorks, Inc
function [sCol,sRx,sRD,sMFilt,sTVG,threshold] = setupRx(nint,nf,pfa,maxrange,range_gates,sWav,sAnt,fc)
%% Collector
sCol = phased.Collector('Sensor',sAnt,'Wavefront','Plane',...
                        'OperatingFrequency',fc);
                    
%% Receiver Preamp
sRx = phased.ReceiverPreamp('Gain',20,'NoiseBandwidth',sWav.SweepBandwidth,...
                            'NoiseFigure',nf,'EnableInputPort',true,...
                            'SeedSource','Property','Seed',2007);

%% Range Doppler Estimator
sRD = phased.RangeDopplerResponse(...
    'DopplerWindow','Chebyshev','DopplerSidelobeAttenuation',60,...
    'SampleRate',sWav.SampleRate,'DopplerOutput','Speed','OperatingFrequency',fc);

%% Matched Filter
match_sig = getMatchedFilter(sWav);
sMFilt    = phased.MatchedFilter('Coefficients',match_sig);

%% Time Varying Gain
lambda   = physconst('LightSpeed')/fc;
rng_loss = 2*fspl(range_gates,lambda);   % Factor 2 for round trip
ref_loss = 2*fspl(maxrange,lambda);      % Reference loss for maximum range

sTVG = phased.TimeVaryingGain('RangeLoss',rng_loss,'ReferenceLoss',ref_loss);

%% Detection Threshold
npower    = noisepow(sWav.SweepBandwidth,nf,sRx.ReferenceTemperature);
sG        = phased.ArrayGain('SensorArray',sAnt);
gain      = step(sG,fc,0);
threshold = npower * norm(match_sig)^2 * db2pow(gain)...
                   * db2pow(npwgnthresh(pfa,nint,'noncoherent'));


