function phaseData = calculatePhaseError(sRate,fracFreq)
%caculates phase or time data. needed for overlapping ADEV to avoid nested
%loops. Input arguments are fracional frequency array and srate

phaseData=zeros(1,length(fracFreq)+1);
phaseData(2:end) = cumsum(fracFreq)./sRate;
