%Copyright 2013 The MathWorks, Inc
function [sTgt,sTgtMotion,sChan] = setupTheater(tgtRCS,tgtpos,tgtvel,fc,fs)

for n = 1:numel(tgtRCS),
    %% Target
    sTgt{n} = phased.RadarTarget('MeanRCS',tgtRCS(n),'Model','Swerling2',...
                                 'OperatingFrequency',fc, ...
                                 'SeedSource', 'Property',...
                                 'Seed',2000+round(100*tgtRCS(n)));  %#ok<*AGROW>
    %% Target platform
    sTgtMotion{n} = phased.Platform('InitialPosition',tgtpos(:,n),...
                                    'Velocity',tgtvel(:,n));
    %% Propagation Channel
    sChan{n} = phased.FreeSpace('SampleRate',fs,'TwoWayPropagation',true,...
                                'OperatingFrequency',fc);
end

